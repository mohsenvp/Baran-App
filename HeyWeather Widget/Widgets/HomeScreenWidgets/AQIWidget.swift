//
//  AQIWidget.swift
//  HeyWeather WidgetExtension
//
//  Created by Mohammad Yeganeh on 7/23/23.
//

import WidgetKit
import SwiftUI

struct AQIWidgetEntry : TimelineEntry {
    var date = Date()
    //Reza TODO: Make it Optional
    var weather : WeatherData
    var aqiData : AQIData
    var widgetSetting : AQIWidgetSetting
    var hideIt : Bool = false
    var id : Int = 0 // This is really weird, If I dont pass id from ForecastViewEntry to view, views dont fucking update!
}

struct AQIWidgetProvider: IntentTimelineProvider {
    
    func placeholder(in context: Context) -> AQIWidgetEntry {
        let defaultSetting = AQIWidgetSetting(widgetStyle: .simple, showCityName: true)
        return AQIWidgetEntry(weather: .init(), aqiData: .init(isBlank: false), widgetSetting : defaultSetting)
    }
    
    func getSnapshot(for configuration: AQIWidgetConfigIntent, in context: Context, completion: @escaping (AQIWidgetEntry) -> Void) {
        let defaultSetting = AQIWidgetSetting(widgetStyle: .simple, showCityName: true)
        provideData(configuration: configuration, context: context) { tempEntry in
            var entry = tempEntry
            entry.widgetSetting = defaultSetting
            completion(entry)
        }
    }
    
    
    func getTimeline(for configuration: AQIWidgetConfigIntent, in context: Context, completion: @escaping (Timeline<AQIWidgetEntry>) -> Void) {
        provideData(configuration: configuration, context: context) { (tempEntry)  in
            
            let calendar = Calendar.current
            let currentDate = Date()
            
            let numberOfForecastData = 12
            let currentHour = calendar.component(.hour, from: currentDate)
            let hoursFromNowForNewForecastData = (currentHour < 8 || currentHour >= 22 ) ? 6 : 3
            
            var entries : [AQIWidgetEntry] = []
            
            for i in 0...numberOfForecastData {
                var entry = tempEntry
                
                // MARK: Calculating Refresh Date to make view update exactly on new hour like : 20:00:00
                
                let currentMinutes = calendar.component(.minute, from: currentDate)
                let currentSeconds = calendar.component(.second, from: currentDate)
                
                var toNextHour = DateComponents()
                toNextHour.minute = -1 * currentMinutes
                toNextHour.second = -1 * currentSeconds
                toNextHour.hour   = i
                
                let calculatedDate = calendar.date(byAdding: toNextHour, to: currentDate)!
                let refreshDate = max(calculatedDate, currentDate)
                
                // MARK: Calcualting Updated Current and Hourly Weather
                
                let combinedArray = [entry.weather.today] + entry.weather.hourlyForecast
                let currentWeather = combinedArray.min{abs($0.utcDate.timeIntervalSince(refreshDate)) < abs($1.utcDate.timeIntervalSince(refreshDate))}!
                let hourlyWeather = entry.weather.hourlyForecast.filter{ $0.utcDate > refreshDate}
                let dailyWeather = entry.weather.dailyForecast.filter{ calendar.date(from: calendar.dateComponents([.year, .month, .day], from: $0.utcDate))! >= calendar.date(from: calendar.dateComponents([.year, .month, .day], from: refreshDate))! }
                
                
                let combinedArrayAqi = [entry.aqiData.current] + entry.aqiData.hourlyForecast
                let currentAqi = combinedArrayAqi.min{abs($0.utcDate.timeIntervalSince(refreshDate)) < abs($1.utcDate.timeIntervalSince(refreshDate))}!
                let hourlyAqi = entry.aqiData.hourlyForecast.filter{ $0.utcDate > refreshDate}
                let dailyAqi = entry.aqiData.dailyForecast.filter{ calendar.date(from: calendar.dateComponents([.year, .month, .day], from: $0.utcDate))! >= calendar.date(from: calendar.dateComponents([.year, .month, .day], from: refreshDate))! }
                
                // MARK: Updating entry
                entry.weather.updateTime = refreshDate
                entry.weather.today = currentWeather
                entry.weather.hourlyForecast = hourlyWeather
                entry.weather.dailyForecast = dailyWeather
                
                entry.aqiData.updateTime = refreshDate
                entry.aqiData.current = currentAqi
                entry.aqiData.hourlyForecast = hourlyAqi
                entry.aqiData.dailyForecast = dailyAqi
                
                
                entry.id = 1000 + i
                entry.date = refreshDate
                //  MARK: This is for test, make view update every minutes.
                // let testRefreshDate = Calendar.current.date(byAdding: DateComponents(minute: i), to: currentDate)!
                // entry.date = testRefreshDate
                // print(testRefreshDate)
                
                entries.append(entry)
            }
            
            let futureDate = calendar.date(byAdding: .hour, value: hoursFromNowForNewForecastData, to: currentDate)!
            let timeline = Timeline(entries: entries, policy: .after(futureDate))
            
            completion(timeline)
        }
    }
    
    func provideData(configuration : AQIWidgetConfigIntent, context: Context, completion: @escaping (AQIWidgetEntry) -> Void) {
        var settings = AQIWidgetSetting()
        let selectedCity = CityAgent.returnCityFromId(cityId: Int(configuration.widgetCity?.identifier ?? "0" )!)
        
        settings.showCityName = configuration.showCityName as! Bool? ?? false
        settings.showAddress = configuration.showAddressIfAvailable as! Bool? ?? false
        
        let styles : [AQIWidgetStyle] = [.simple, .guage, .detailed]
        settings.widgetStyle = styles[Int(configuration.widgetStyle?.identifier ?? "0")!]
        
        let repository = Repository()
        
        
        var aqiRequestItems: [AQIRequestItem] = [.current, .hourly]
        var weatherRequestItems: [WeatherRequestItem] = []
        
        // -------------- Simple --------------
        // Small: hourly AQI
        // Medium: hourly AQI, Daily Aqi | hourly Weather
        
        // -------------- Guage --------------
        // Small: hourly AQI
        // Medium: hourly AQI, Daily Aqi | hourly Weather, daily Weather
        
        // ------------ Detailed -------------
        // Small: hourly AQI
        // Medium: hourly AQI, Daily Aqi | hourly Weather
        
        
        if context.family == .systemMedium {
            aqiRequestItems = [.current, .hourly, .daily]
            weatherRequestItems = [.current, .hourly]
            if (settings.widgetStyle == .guage) {
                weatherRequestItems.append(.daily)
            }
        }
        
        
        // TODO Reza: I should check it later
        Task { [settings, aqiRequestItems, weatherRequestItems] in
            do {
                if context.isPreview {
                    let aqiData = try await repository.getAQI(for: selectedCity, requestItems: aqiRequestItems, requestOrigin: .homescreenWidget)
                    if weatherRequestItems.count > 0 {
                        let weatherData = try await repository.getWeather(for: selectedCity, requestItems: weatherRequestItems, requestOrigin: .homescreenWidget, forceCache: true)
                        let entry = AQIWidgetEntry(weather: weatherData, aqiData: aqiData, widgetSetting: settings)
                        completion(entry)
                    }else {
                        let entry = AQIWidgetEntry(weather: .init(), aqiData: aqiData, widgetSetting: settings)
                        completion(entry)
                    }
                }else {
                    let premium = try await repository.checkPremiumStatus()

                    if (!premium.isPremium && settings.widgetStyle != .simple) {
                        let entry = AQIWidgetEntry(weather: .init(), aqiData: .init(isBlank: false), widgetSetting: settings, hideIt : true)
                        completion(entry)
                        return
                    }
                    let updatedCity = await repository.CheckAutoLocationAndReturnCity(city: selectedCity, isWidget: true)
                    let aqiData = try await repository.getAQI(for: updatedCity, requestItems: aqiRequestItems, requestOrigin: .homescreenWidget, forceCache: false)
                    if weatherRequestItems.count > 0 {
                        let weatherData = try await repository.getWeather(for: updatedCity, requestItems: weatherRequestItems, requestOrigin: .homescreenWidget, forceCache: false)
                        let entry = AQIWidgetEntry(weather: weatherData, aqiData: aqiData, widgetSetting: settings)
                        completion(entry)
                    }else {
                        let entry = AQIWidgetEntry(weather: WeatherData(), aqiData: aqiData, widgetSetting: settings)
                        completion(entry)
                    }
                }
                
            }catch {
                
            }
        }
        
    }
}


struct AQIWidgetEntryView : View {
    let entry : AQIWidgetEntry
    @Environment(\.widgetFamily) var family
    @ObservedObject var localizeHelper = LocalizeHelper.shared
    
    @ViewBuilder
    var body: some View {
        Group {
            if (entry.hideIt) {
                PremiumOverlayView(kind: .aqi)
            }else {
                AQIWidgetFamily(weather: entry.weather, aqiData: entry.aqiData, setting: entry.widgetSetting, widgetSize : family, id : entry.id)
            }
        }
        .environment(\.locale, Locale(identifier: localizeHelper.currentLanguage.rawValue))
        .environment(\.layoutDirection, localizeHelper.currentLanguage.isRTL ? .rightToLeft : .leftToRight)
    }
}

struct AQIWidget: Widget {
    private let kind: String = WidgetKind.aqi.rawValue
    public var body: some WidgetConfiguration {
        return IntentConfiguration(kind: kind, intent: AQIWidgetConfigIntent.self, provider: AQIWidgetProvider()) { entry in
            LocalizeHelper.reset()
            return AQIWidgetEntryView(entry: entry)
        }
        .configurationDisplayName(Text("AQI Widgets", tableName: "Widgets"))
        .description(Text("Protect yourself from pollution with AQI Forecast Widgets", tableName: "Widgets"))
        .supportedFamilies([.systemSmall ,.systemMedium])
        .containerBackgroundRemovable()
        
    }
}
