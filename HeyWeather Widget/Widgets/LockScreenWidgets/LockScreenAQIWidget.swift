//
//  LockScreenAQIWidget.swift
//  HeyWeather
//
//  Created by Mohammad Yeganeh on 7/22/23.
//
//
import WidgetKit
import SwiftUI

struct LockScreenAQIWidgetEntry : TimelineEntry {
    var date = Date()
    var aqiData : AQIData
    var hideIt : Bool = false
    var id : Int = 0
}

struct LockScreenAQIWidgetProvider: IntentTimelineProvider {
    
    
    func recommendations() -> [IntentRecommendation<LockScreenWidgetConfigIntent>] {
        return [
            IntentRecommendation(intent: LockScreenWidgetConfigIntent(), description: WidgetStrings.getLockScreenTitle(for: .aqi))
        ]
    }
    
    func placeholder(in context: Context) -> LockScreenAQIWidgetEntry {
        return LockScreenAQIWidgetEntry(aqiData: AQIData())
    }
    
    func getSnapshot(for configuration: LockScreenWidgetConfigIntent, in context: Context, completion: @escaping (LockScreenAQIWidgetEntry) -> Void) {
        provideData(configuration: configuration, context: context) { entry in
            completion(entry)
        }
    }
    
    func getTimeline(for configuration: LockScreenWidgetConfigIntent, in context: Context, completion: @escaping (Timeline<LockScreenAQIWidgetEntry>) -> Void) {
        provideData(configuration: configuration, context: context) { (tempEntry)  in
            
            let calendar = Calendar.current
            let currentDate = Date()
            
            let numberOfForecastData = 12
            let currentHour = calendar.component(.hour, from: currentDate)
            let hoursFromNowForNewForecastData = (currentHour < 8 || currentHour >= 22 ) ? 6 : 4
            
            var entries : [LockScreenAQIWidgetEntry] = []
            
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
                
                
                // MARK: Calcualting Updated Current and Hourly Aqi
                
                let combinedArrayAqi = [entry.aqiData.current] + entry.aqiData.hourlyForecast
                let currentAqi = combinedArrayAqi.min{abs($0.utcDate.timeIntervalSince(refreshDate)) < abs($1.utcDate.timeIntervalSince(refreshDate))}!
                let hourlyAqi = entry.aqiData.hourlyForecast.filter{ $0.utcDate > refreshDate}
                let dailyAqi = entry.aqiData.dailyForecast.filter{ calendar.date(from: calendar.dateComponents([.year, .month, .day], from: $0.utcDate))! >= calendar.date(from: calendar.dateComponents([.year, .month, .day], from: refreshDate))! }
                
                // MARK: Updating entry
                entry.aqiData.updateTime = refreshDate
                entry.aqiData.current = currentAqi
                entry.aqiData.hourlyForecast = hourlyAqi
                entry.aqiData.dailyForecast = dailyAqi
                
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
    
    func provideData(configuration : LockScreenWidgetConfigIntent, context: Context, completion: @escaping (LockScreenAQIWidgetEntry) -> Void) {
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
                let aqiData = try await repository.getAQI(for: selectedCity, requestItems: [.current], requestOrigin: requestOrigin, forceCache: true)
                let entry = LockScreenAQIWidgetEntry(aqiData: aqiData)
                completion(entry)
            }else {
                
                
                let premium = try await repository.checkPremiumStatus()
                
                if (!premium.isPremium) {
                    let entry = LockScreenAQIWidgetEntry(aqiData: AQIData(), hideIt : true)
                    completion(entry)
                }

                let updatedCity = await repository.CheckAutoLocationAndReturnCity(city : selectedCity, isWidget: true)
                let aqiData = try await repository.getAQI(for: updatedCity, requestItems: [.current, .hourly], requestOrigin: requestOrigin)
                let entry = LockScreenAQIWidgetEntry(aqiData: aqiData)
                completion(entry)
            }
        }
    }
}


struct LockScreenAQIWidgetEntryView : View {
    let entry : LockScreenAQIWidgetEntry
    @Environment(\.widgetFamily) var family
    @ObservedObject var localizeHelper = LocalizeHelper.shared
    
    @ViewBuilder
    var body: some View {
        Group {
            if (entry.hideIt) {
                LockScreenPremiumOverlayView(family: family)
            }else {
                LockScreenAQIWidgetFamily(aqi: entry.aqiData.current, widgetSize: family, id: entry.id)
            }
        }
        .environment(\.locale, Locale(identifier: localizeHelper.currentLanguage.rawValue))
        .environment(\.layoutDirection, localizeHelper.currentLanguage.isRTL ? .rightToLeft : .leftToRight)
        
    }
}

struct LockScreenAQIWeatherWidget: Widget {
    
    public var body: some WidgetConfiguration {
        let widgetKind = LockScreenWidgetKind.aqi
        var families: [WidgetFamily] = [.accessoryInline ,.accessoryCircular, .accessoryRectangular]
        #if os(watchOS)
        families.append(.accessoryCorner)
        #endif
        return IntentConfiguration(kind: widgetKind.rawValue , intent: LockScreenWidgetConfigIntent.self, provider: LockScreenAQIWidgetProvider()) { entry in
            LocalizeHelper.reset()
            return LockScreenAQIWidgetEntryView(entry: entry)
        }
        .configurationDisplayName(WidgetStrings.getLockScreenTitle(for: widgetKind))
        .description(WidgetStrings.getLockScreenDescription(for: widgetKind))
        .supportedFamilies(families)
    }
}
