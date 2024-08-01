//
//  LockScreenWidgetEntry.swift
//  HeyWeather WidgetExtension
//
//  Created by Reza Ranjbaran on 17/06/2023.
//

import WidgetKit
import SwiftUI

struct LockScreenWidgetEntry : TimelineEntry {
    var date = Date()
    var weather : WeatherData
    var astronomoy: Astronomy
    var hideIt : Bool = false
    var id : Int = 0
}

struct LockScreenWidgetProvider: IntentTimelineProvider {
    var widgetKind: LockScreenWidgetKind
    
    @available(iOSApplicationExtension 17.0, *)
    func recommendations() -> [IntentRecommendation<LockScreenWidgetConfigIntent>] {
        [
            IntentRecommendation(intent: LockScreenWidgetConfigIntent(), description: WidgetStrings.getLockScreenTitle(for: widgetKind)),
        ]
    }
    
    func placeholder(in context: Context) -> LockScreenWidgetEntry {
        return LockScreenWidgetEntry(weather: WeatherData(), astronomoy: Astronomy())
    }
    
    func getSnapshot(for configuration: LockScreenWidgetConfigIntent, in context: Context, completion: @escaping (LockScreenWidgetEntry) -> Void) {
        provideData(configuration: configuration, context: context) { entry in
            completion(entry)
        }
    }
    
    func getTimeline(for configuration: LockScreenWidgetConfigIntent, in context: Context, completion: @escaping (Timeline<LockScreenWidgetEntry>) -> Void) {
        provideData(configuration: configuration, context: context) { (tempEntry)  in
            
            let calendar = Calendar.current
            let currentDate = Date()
            
            let numberOfForecastData = 12
            let currentHour = calendar.component(.hour, from: currentDate)
            let hoursFromNowForNewForecastData = (currentHour < 8 || currentHour >= 22 ) ? 6 : 4
            
            var entries : [LockScreenWidgetEntry] = []
            
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
                
                let combinedArray = ([entry.weather.today] + entry.weather.hourlyForecast).sorted{$0.utcDate < $1.utcDate}
                let currentWeather = combinedArray.filter({ $0.utcDate < refreshDate}).last ?? combinedArray.first
                let hourlyWeather = entry.weather.hourlyForecast.filter{ $0.utcDate >= refreshDate}
                let dailyWeather = entry.weather.dailyForecast.filter{ calendar.date(from: calendar.dateComponents([.year, .month, .day], from: $0.utcDate))! >= calendar.date(from: calendar.dateComponents([.year, .month, .day], from: refreshDate))! }
                
                
                // MARK: Updating entry
                entry.weather.updateTime = refreshDate
                entry.weather.today.localDate = refreshDate
                entry.weather.today = currentWeather!
                entry.weather.hourlyForecast = hourlyWeather
                entry.weather.dailyForecast = dailyWeather
                
                entry.id = 1000 + i
                entry.date = refreshDate
                //  MARK: This is for test, make view update every minutes.
                //  let refreshDate = Calendar.current.date(byAdding: DateComponents(minute: i), to: currentDate)!
                //  entry.date = refreshDate
                
                entries.append(entry)
            }
            
            let futureDate = calendar.date(byAdding: .hour, value: hoursFromNowForNewForecastData, to: currentDate)!
            let timeline = Timeline(entries: entries, policy: .after(futureDate))
            
            completion(timeline)
        }
    }
    
    func provideData(configuration : LockScreenWidgetConfigIntent, context: Context, completion: @escaping (LockScreenWidgetEntry) -> Void) {
        #if os(watchOS)
        let selectedCity = CityAgent.getMainCity()
        let requestOrigin : WeatherRequestOrigin = .appleWatchWidget
        #else
        let selectedCity = CityAgent.returnCityFromId(cityId: Int(configuration.widgetCity?.identifier ?? "0" )!)
        let requestOrigin : WeatherRequestOrigin = .lockscreenWidget
        #endif
        
        let repository = Repository()
        Task {
            if (context.isPreview) {
                
                var weatherData = try await repository.getWeather(for: selectedCity, requestItems: [.current, .hourly, .daily], requestOrigin: .lockscreenWidget, forceCache: true)

                if (weatherData.hourlyForecast.first!.utcDate <  weatherData.today.utcDate) {
                    weatherData.hourlyForecast.removeFirst()
                }
                let entry = LockScreenWidgetEntry(weather: weatherData, astronomoy: Astronomy())
                completion(entry)
                
            }else {
                
                let premium = try await repository.checkPremiumStatus()
                
                if (!premium.isPremium) {
                    let entry = LockScreenWidgetEntry(weather: WeatherData(), astronomoy: .init(), hideIt : true)
                    completion(entry)
                    return
                }
                
                let updatedCity = await repository.CheckAutoLocationAndReturnCity(city : selectedCity, isWidget: true)
                
                let weatherData = try await repository.getWeather(for: updatedCity, requestItems: [.current, .hourly, .daily], requestOrigin: requestOrigin)
                #if os(watchOS)
                let astronomy = repository.getAstronomy(city: updatedCity, count: 1,timeZone: weatherData.timezone).first!
                #else
                let astronomy = Astronomy()
                #endif
                
                let entry = LockScreenWidgetEntry(weather: weatherData, astronomoy: astronomy)
                completion(entry)
                
            }
            
        }
    }
}


struct LockScreenWidgetEntryView : View {
    let entry : LockScreenWidgetEntry
    let widgetKind : LockScreenWidgetKind
    @Environment(\.widgetFamily) var family
    @ObservedObject var localizeHelper = LocalizeHelper.shared
    
    @ViewBuilder
    var body: some View {
        Group {
            if (entry.hideIt) {
                LockScreenPremiumOverlayView(family: family)
            }else {
                LockScreenWidgetFamily(weather: entry.weather, astronomy: entry.astronomoy, widgetKind:widgetKind, widgetSize: family, id: entry.id)
            }
        }
        .environment(\.locale, Locale(identifier: localizeHelper.currentLanguage.rawValue))
        .environment(\.layoutDirection, localizeHelper.currentLanguage.isRTL ? .rightToLeft : .leftToRight)
        
    }
}


struct LockScreenWeatherWidget: Widget {
    var widgetKind: LockScreenWidgetKind = .currentOne
    
    public var body: some WidgetConfiguration {
        
        var families: [WidgetFamily]
        
        
        switch widgetKind {
        case .currentOne, .currentTwo:
            families = [.accessoryInline ,.accessoryCircular, .accessoryRectangular]
            #if os(watchOS)
            families.append(.accessoryCorner)
            #endif
        case .hourlyOne, .hourlyTwo, .dailyOne, .dailyTwo:
            families = [.accessoryRectangular]
        case .precipitation:
            families = [.accessoryInline]
        case .cloudiness, .humidity, .uv:
            families = [.accessoryInline ,.accessoryCircular]
            #if os(watchOS)
            families.append(.accessoryCorner)
            #endif
        default:
            families = []
        }
        
        
        return IntentConfiguration(kind: widgetKind.rawValue , intent: LockScreenWidgetConfigIntent.self, provider: LockScreenWidgetProvider(widgetKind: widgetKind)) { entry in
            LocalizeHelper.reset()
            return LockScreenWidgetEntryView(entry: entry, widgetKind: widgetKind)
        }
        .configurationDisplayName(WidgetStrings.getLockScreenTitle(for: widgetKind))
        .description(WidgetStrings.getLockScreenDescription(for: widgetKind))
        .supportedFamilies(families)
    }
}
