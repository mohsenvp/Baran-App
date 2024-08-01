//
//  CustomizableWidget.swift
//  HeyWeather WidgetExtension
//
//  Created by Reza Ranjbaran on 15/05/2023.
//

import WidgetKit
import SwiftUI

struct CustomizableWidgetEntry : TimelineEntry {
    var date = Date()
    var weather : WeatherData
    var widgetTheme : WidgetTheme
    var hideIt : Bool = false
    var id : Int = 0 // This is really weird, If I dont pass id from ForecastViewEntry to view, views dont fucking update!
}

struct CustomizableWidgetProvider: IntentTimelineProvider {
    
    func placeholder(in context: Context) -> CustomizableWidgetEntry {
        return CustomizableWidgetEntry(weather: WeatherData(), widgetTheme: WidgetTheme())
    }
    
    func getSnapshot(for configuration: CustomizableWidgetConfigIntent, in context: Context, completion: @escaping (CustomizableWidgetEntry) -> Void) {
        provideData(configuration: configuration, context: context) { tempEntry in
            let entry = tempEntry
            completion(entry)
        }
    }
    
    func getTimeline(for configuration: CustomizableWidgetConfigIntent, in context: Context, completion: @escaping (Timeline<CustomizableWidgetEntry>) -> Void) {
        provideData(configuration : configuration, context: context) { tempEntry  in
            
            let calendar = Calendar.current
            let currentDate = Date()
            
            let numberOfForecastData = 12
            let currentHour = calendar.component(.hour, from: currentDate)
            let hoursFromNowForNewForecastData = (currentHour < 8 || currentHour >= 22 ) ? 6 : 3
            
            var entries : [CustomizableWidgetEntry] = []
            
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
    
    func provideData(configuration : CustomizableWidgetConfigIntent, context : Context, completion: @escaping (CustomizableWidgetEntry) -> Void) {
        
        var selectedCity = CityAgent.returnCityFromId(cityId: Int(configuration.widgetCity?.identifier ?? "0") ?? 0)
        if (context.isPreview) {
            selectedCity = CityAgent.getMainCity()
        }
        var selectedWidgetTheme = WidgetTheme()
        
        if let allThemes : [WidgetTheme] = UserDefaults.get(for: .allCustomizableThems) {
            
            var widgetSize = ""
            switch context.family {
            case .systemSmall :
                widgetSize = "small"
            case .systemMedium :
                widgetSize = "medium"
            case .systemLarge :
                widgetSize = "large"
            default:
                widgetSize = "small"
            }
            
            selectedWidgetTheme = allThemes.first { $0.forSize == widgetSize && $0.viewNo == Int(configuration.widgetStyle?.identifier ?? "0") ?? 0 }!
        }
        
        selectedWidgetTheme.city = selectedCity
        
        selectedWidgetTheme.showCityName = configuration.showCityName  as! Bool? ?? false
        selectedWidgetTheme.showAddress = configuration.showAddressIfAvailable as! Bool? ?? false
        selectedWidgetTheme.showUpdateTime = configuration.showUpdateTime as! Bool? ?? false
        
        let repository = Repository()
        
        Task { [selectedWidgetTheme, selectedCity] in
            do {
                if context.isPreview {
                    let weatherData = try await repository.getWeather(for: selectedCity, requestItems: [.current, .hourly, .daily], requestOrigin: .homescreenWidget, forceCache: true)
                    let entry = CustomizableWidgetEntry(weather: weatherData, widgetTheme: selectedWidgetTheme)
                    completion(entry)
                    
                }else {
                    
                    
                    let premium = try await repository.checkPremiumStatus()

                    if (!premium.isPremium && selectedWidgetTheme.viewNo > 0) {
                        let entry = CustomizableWidgetEntry(weather: WeatherData(), widgetTheme: WidgetTheme(), hideIt: true)
                        completion(entry)
                        return
                    }
                    
                    let updatedCity = await repository.CheckAutoLocationAndReturnCity(city : selectedCity, isWidget: true)
                    var weatherRequestItems: [WeatherRequestItem]
                    switch context.family {
                    case .systemSmall :
                        switch (selectedWidgetTheme.viewNo + 1) {
                        case 7,8:
                            weatherRequestItems = [.current, .hourly, .daily]
                        default /* 1,2,3,4,5,6 */:
                            weatherRequestItems = [.current, .hourly]
                        }
                    case .systemMedium :
                        switch (selectedWidgetTheme.viewNo + 1) {
                        case 1,5,8,9:
                            weatherRequestItems = [.current, .hourly, .daily]
                        default: /* 2,3,4,6,7 */
                            weatherRequestItems = [.current, .hourly]
                        }
                    case .systemLarge :
                        switch (selectedWidgetTheme.viewNo + 1) {
                        case 2,3:
                            weatherRequestItems = [.current, .hourly]
                        default: /* 1,4,5,6 */
                            weatherRequestItems = [.current, .hourly, .daily]
                        }
                    default:
                        weatherRequestItems = [.current, .hourly]
                    }
                    
                    let weatherData = try await repository.getWeather(for: updatedCity, requestItems: weatherRequestItems, requestOrigin: .homescreenWidget)
                    let entry = CustomizableWidgetEntry(weather: weatherData, widgetTheme: selectedWidgetTheme)
                    completion(entry)
                    
                }
            }catch {
                print(error.localizedDescription)
            }
        }
        
    }
}


struct CustomizableWidgetEntryView : View {
    var entry : CustomizableWidgetEntry
    @Environment(\.widgetFamily) var family
    @ObservedObject var localizeHelper = LocalizeHelper.shared
    
    @ViewBuilder
    var body: some View {
        Group {
            
            if (entry.hideIt) {
                PremiumOverlayView(kind: .customizable)
            }else {
                switch family {
                case .systemSmall:
                    switch (entry.widgetTheme.viewNo + 1) {
                    case 1:
                        SmallWidgetView1(weather: entry.weather, theme: entry.widgetTheme, id: entry.id)
                    case 2 :
                        SmallWidgetView2(weather: entry.weather, theme: entry.widgetTheme, id: entry.id)
                    case 3:
                        SmallWidgetView3(weather: entry.weather, theme: entry.widgetTheme, id: entry.id)
                    case 4:
                        SmallWidgetView4(weather: entry.weather, theme: entry.widgetTheme, id: entry.id)
                    case 5:
                        SmallWidgetView5(weather: entry.weather, theme: entry.widgetTheme, id: entry.id)
                    case 6:
                        SmallWidgetView6(weather: entry.weather, theme: entry.widgetTheme, id: entry.id)
                    case 7:
                        SmallWidgetView7(weather: entry.weather, theme: entry.widgetTheme, id: entry.id)
                    case 8:
                        SmallWidgetView8(weather: entry.weather, theme: entry.widgetTheme, id: entry.id)
                    default:
                        SmallWidgetView1(weather: entry.weather, theme: entry.widgetTheme, id: entry.id)
                    }
                case .systemMedium:
                    switch (entry.widgetTheme.viewNo + 1) {
                    case 1:
                        MediumWidgetView1(weather: entry.weather, theme: entry.widgetTheme, id: entry.id)
                    case 2 :
                        MediumWidgetView2(weather: entry.weather, theme: entry.widgetTheme, id: entry.id)
                    case 3:
                        MediumWidgetView3(weather: entry.weather, theme: entry.widgetTheme, id: entry.id)
                    case 4:
                        MediumWidgetView4(weather: entry.weather, theme: entry.widgetTheme, id: entry.id)
                    case 5:
                        MediumWidgetView5(weather: entry.weather, theme: entry.widgetTheme, id: entry.id)
                    case 6:
                        MediumWidgetView6(weather: entry.weather, theme: entry.widgetTheme, id: entry.id)
                    case 7:
                        MediumWidgetView7(weather: entry.weather, theme: entry.widgetTheme, id: entry.id)
                    case 8:
                        MediumWidgetView8(weather: entry.weather, theme: entry.widgetTheme, id: entry.id)
                    default:
                        MediumWidgetView1(weather: entry.weather, theme: entry.widgetTheme, id: entry.id)
                    }
                case .systemLarge:
                    switch (entry.widgetTheme.viewNo + 1) {
                    case 1:
                        LargeWidgetView1(weather: entry.weather, theme: entry.widgetTheme, id: entry.id)
                    case 2 :
                        LargeWidgetView2(weather: entry.weather, theme: entry.widgetTheme, id: entry.id)
                    case 3:
                        LargeWidgetView3(weather: entry.weather, theme: entry.widgetTheme, id: entry.id)
                    case 4:
                        LargeWidgetView4(weather: entry.weather, theme: entry.widgetTheme, id: entry.id)
                    case 5:
                        LargeWidgetView5(weather: entry.weather, theme: entry.widgetTheme, id: entry.id)
                    case 6:
                        LargeWidgetView6(weather: entry.weather, theme: entry.widgetTheme, id: entry.id)
                    default:
                        LargeWidgetView2(weather: entry.weather, theme: entry.widgetTheme, id: entry.id)
                    }
                default:
                    SmallWidgetView1(weather: entry.weather, theme: entry.widgetTheme, id: entry.id)
                }
            }
        }
        .environment(\.locale, Locale(identifier: localizeHelper.currentLanguage.rawValue))
        .environment(\.layoutDirection, localizeHelper.currentLanguage.isRTL ? .rightToLeft : .leftToRight)
        
        
    }
}

struct CustomizableWidget: Widget {
    private let kind: String = WidgetKind.customizable.rawValue
    public var body: some WidgetConfiguration {
        return IntentConfiguration(kind: kind, intent: CustomizableWidgetConfigIntent.self, provider: CustomizableWidgetProvider()) { entry in
            LocalizeHelper.reset()
            return CustomizableWidgetEntryView(entry: entry)
        }
        .configurationDisplayName(Text("Customizable Widgets", tableName: "Widgets"))
        .description(Text("Customizable widgets: Personalize every aspect as desired in the app.", tableName: "Widgets"))
        .supportedFamilies([.systemSmall ,.systemMedium, .systemLarge])
        .containerBackgroundRemovable()
    }
}
