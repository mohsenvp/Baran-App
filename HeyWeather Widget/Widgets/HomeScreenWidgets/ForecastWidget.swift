//
//  ForecastWidget.swift
//  HeyWeather
//
//  Created by Reza Ranjbaran on 16/05/2023.
//

import WidgetKit
import SwiftUI

struct ForecastWidgetEntry : TimelineEntry {
    var date = Date()
    var weather : WeatherData
    var widgetSetting : ForecastWidgetSetting
    var hideIt : Bool = false
    var id : Int = 0 // This is really weird, If I dont pass id from ForecastViewEntry to view, views dont fucking update!
}

struct ForecastWidgetProvider: IntentTimelineProvider {
    
    func placeholder(in context: Context) -> ForecastWidgetEntry {
        let defaultSetting = ForecastWidgetSetting(widgetLook: .original, widgetBackground: .def, forcastType: .hourly, showCityName: true)
        return ForecastWidgetEntry(weather: WeatherData(), widgetSetting : defaultSetting)
    }
    
    func getSnapshot(for configuration: ForecastWidgetConfigIntent, in context: Context, completion: @escaping (ForecastWidgetEntry) -> Void) {
        
        let defaultSetting = ForecastWidgetSetting(widgetLook: .original, widgetBackground: .def, forcastType: .hourly, showCityName: true)
        provideData(configuration: configuration, context: context) { tempEntry in
            var entry = tempEntry
            entry.widgetSetting = defaultSetting
            completion(entry)
        }
    }
    
    func getTimeline(for configuration: ForecastWidgetConfigIntent, in context: Context, completion: @escaping (Timeline<ForecastWidgetEntry>) -> Void) {
        provideData(configuration: configuration, context: context) { (tempEntry)  in
            
            let calendar = Calendar.current
            let currentDate = Date()
            
            let numberOfForecastData = 12
            let currentHour = calendar.component(.hour, from: currentDate)
            let hoursFromNowForNewForecastData = (currentHour < 8 || currentHour >= 22 ) ? 6 : 3
            
            var entries : [ForecastWidgetEntry] = []
            
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
                
                
                // MARK: Updating entry
                entry.weather.updateTime = refreshDate
                entry.weather.today = currentWeather
                entry.weather.hourlyForecast = hourlyWeather
                entry.weather.dailyForecast = dailyWeather
                
                entry.id = 1000 + i
                entry.date = refreshDate
                //  MARK: This is for test, make view update every minutes.
//                  let testRefreshDate = Calendar.current.date(byAdding: DateComponents(minute: i), to: currentDate)!
//                  entry.date = testRefreshDate
                
                entries.append(entry)
            }
            
            let futureDate = calendar.date(byAdding: .hour, value: hoursFromNowForNewForecastData, to: currentDate)!
            let timeline = Timeline(entries: entries, policy: .after(futureDate))
            
            completion(timeline)
        }
    }
    
    func provideData(configuration : ForecastWidgetConfigIntent, context: Context, completion: @escaping (ForecastWidgetEntry) -> Void) {
        var settings = ForecastWidgetSetting()
        let selectedCity = CityAgent.returnCityFromId(cityId: Int(configuration.widgetCity?.identifier ?? "0" )!)
        
        settings.showCityName = configuration.showCityName as! Bool? ?? false
        settings.showAddress = configuration.showAddressIfAvailable as! Bool? ?? false
        settings.showFeelsLike = configuration.showFeelsLike as! Bool? ?? false
        settings.showUpdateTime = configuration.showUpdateTime as! Bool? ?? false
        
        switch configuration.forecastType {
        case .unknown:
            settings.forecastType = ForecastType.hourly
        case .hourly:
            settings.forecastType = ForecastType.hourly
        case .daily:
            settings.forecastType = ForecastType.daily
        case .both:
            settings.forecastType = ForecastType.both
        }
        
        if (context.family == .systemLarge) {
            settings.forecastType = ForecastType.hourly
        }
        
        let looks : [WidgetLook] = [.original, .neumorph,.simple, .skeumorph]
        settings.widgetLook = looks[Int(configuration.widgetLook?.identifier ?? "0")!]
        
        let backgrounds : [WidgetBackground] = [.def, .auto, .light, .dark, .blue, .teal, .orange, .red]
        settings.widgetBackground = backgrounds[Int(configuration.widgetBackground?.identifier ?? "0")!]
        
        let repository = Repository()
        
        Task { [settings] in
            do {
                if (context.isPreview) {
                    let weatherData = try await repository.getWeather(for: selectedCity, requestItems: [.current, .hourly, .daily], requestOrigin: .homescreenWidget, forceCache: true)
                    let entry = ForecastWidgetEntry(weather: weatherData, widgetSetting: settings)
                    completion(entry)
                }else {
                    let premium = try await repository.checkPremiumStatus()

                    if (!premium.isPremium) {
                        let entry = ForecastWidgetEntry(weather: WeatherData(), widgetSetting: settings, hideIt : true)
                        completion(entry)
                        return
                    }
                    
                    let updatedCity = await repository.CheckAutoLocationAndReturnCity(city : selectedCity, isWidget: true)
                    let weatherData = try await repository.getWeather(for: updatedCity, requestItems: [.current, .hourly, .daily], requestOrigin: .homescreenWidget)
                    let entry = ForecastWidgetEntry(weather: weatherData, widgetSetting: settings)
                    completion(entry)
                }
            } catch { }
        }
    }
}


struct ForecastWidgetEntryView : View {
    let entry : ForecastWidgetEntry
    @Environment(\.widgetFamily) var family
    @ObservedObject var localizeHelper = LocalizeHelper.shared
    
    @ViewBuilder
    var body: some View {
        Group {
            if (entry.hideIt) {
                PremiumOverlayView(kind: .forecast)
            }else {
                ForecastWidgetFamily(weather: entry.weather, setting: entry.widgetSetting, widgetSize : family, id : entry.id)
            }
        }
        .environment(\.locale, Locale(identifier: localizeHelper.currentLanguage.rawValue))
        .environment(\.layoutDirection, localizeHelper.currentLanguage.isRTL ? .rightToLeft : .leftToRight)
    }
}

struct ForecastWidget: Widget {
    private let kind: String = WidgetKind.forecast.rawValue
    public var body: some WidgetConfiguration {
        return IntentConfiguration(kind: kind, intent: ForecastWidgetConfigIntent.self, provider: ForecastWidgetProvider()) { entry in
            LocalizeHelper.reset()
            return ForecastWidgetEntryView(entry: entry)
        }
        .configurationDisplayName(Text("Forecast Widgets", tableName: "Widgets"))
        .description(Text("Forecast Widgets offering hourly and daily forecast, customizable by long-pressing the widget (PREMIUM)", tableName: "Widgets"))
        .supportedFamilies([.systemSmall ,.systemMedium, .systemLarge])
        .containerBackgroundRemovable()
    }
}
