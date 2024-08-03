//
//  MediumForecastWidgest.swift
//  HeyWeather
//
//  Created by Reza Ranjbaran on 16/05/2023.
//

import SwiftUI
import WidgetKit

struct ForecastWidgetFamily: View {
    @Environment(\.colorScheme) var colorScheme

    var weather : WeatherData = WeatherData()
    var setting : ForecastWidgetSetting = ForecastWidgetSetting(widgetLook: .skeumorph, widgetBackground: .dark, forcastType: .daily, showCityName: true, showAddress: true, showUpdateTime: true)
    var setBg = true
    var widgetSize : WidgetFamily
    var id = 0 // This is really weird, If I dont pass id from ForecastViewEntry to view, views dont fucking update!
    var isPreviewForAppWidgetTab: Bool = false
    

    var theme: ForecastTheme {
        get {
            switch setting.widgetBackground {
            case .def:
                return Constants.purpleTheme
            case .auto:
                return colorScheme == .dark ? Constants.darkTheme : Constants.lighTheme
            case .light:
                return Constants.lighTheme
            case .dark:
                return Constants.darkTheme
            case .blue:
                return Constants.blueTheme
            case .teal:
                return Constants.tealTheme
            case .orange:
                return Constants.orangeTheme
            case .red:
                return Constants.redTheme
            }
        }
    }
    
    var iconsColorScheme: ColorScheme {
        get {
            switch setting.widgetBackground {
            case .def, .blue, .teal, .red:
                return .dark
            case .light, .orange:
                return .light
            case .dark:
                return .dark
            case .auto:
                return colorScheme
            }
        }
    }
    var compatibalityBGName: String {
        get {
            switch widgetSize {
            case .systemSmall:
                return Constants.flatWidgetsBackground
            case .systemMedium:
                return ""
            default:
                return ""
            }
        }
    }
    
    var body: some View {
        let dailyCount = widgetSize == .systemSmall ? 3 : 6
        let hourlyCount = widgetSize == .systemSmall ? 3 : 6
        let bothCount = widgetSize == .systemSmall ? 1 : 3
        
        let topPortion = widgetSize == .systemLarge ? 0.43 : 1
        let bottomPortion = widgetSize == .systemLarge ? 1.04 : 0
        
        let currentWeather = weather.today
        let hourlyWeather = weather.hourlyForecast.prefix(hourlyCount)
        let dailyWeather = weather.dailyForecast.prefix(dailyCount)
        
        let hasAnyPop : Bool =
        (setting.forecastType == .hourly ? hourlyWeather : dailyWeather).contains(where: { $0.details.pop! > 0 })
        
        
        let hasAnyPrecipitation : Bool = dailyWeather.contains(where: { $0.details.precipitation! > 0.0 })
//        let hasAnyPop : Bool = dailyWeather.contains(where: { $0.details.pop! > 0 })
        
        let minTempOfAll: Int = dailyWeather.compactMap({$0.temperature.min}).min() ?? 0
        let maxTempOfAll: Int = dailyWeather.compactMap({$0.temperature.max}).max() ?? 0
        
        GeometryReader { geometry in
            
            let height = geometry.size.height - (isPreviewForAppWidgetTab || Constants.systemVersionIn4Digit < 17.0 ? 32 : 0)
            
            VStack(spacing: 0) {
                HStack(spacing: 0) {
                    let location = weather.location
                    let updateTime = weather.updateTime
                    
                    CurrentTempView(currentWeather : currentWeather,
                                    location : weather.location,
                                    updateTime : weather.updateTime,
                                    theme : theme,
                                    setting: setting)
                    
                    if (widgetSize != .systemSmall) {
                        
                        Spacer()
                        VStack(alignment: .trailing, spacing : 2) {
                            
                            let t = "\(setting.showCityName ? (location.placeMarkCityName ?? "") : "")\(setting.showUpdateTime ? " " + updateTime.localizedHourAndMinutes(forceCurrentTimezone: true) : "")"
                            
                            if (t != " ") {
                                Text(t)
                                    .fonted(.caption, weight: .semibold)
                                    .lineLimit(1)
                                    .foregroundColor(theme.primaryTextColor)
                                    .shadow(color: setting.widgetLook == .skeumorph ? .black.opacity(0.3) : .clear ,radius: 1, y: 1)
                            }
                                
                            

                            CurrentDetailsView(currentWeather : weather.today,
                                               theme : theme,
                                               setting: setting)
                            .frame(width: geometry.size.width * 0.36)

                            Spacer()

                        }
                    }
                }
                .frame(height : height * 0.45 * topPortion)
                .frame(maxWidth : .infinity)
                
                
                HStack(spacing: 0) {
                    
                    if (setting.forecastType == .daily) {
                        let dailyItems = dailyWeather.prefix(dailyCount)
                        ForEach(0..<dailyCount, id:\.self) { i in
                            VerticalForecastView(weatherDetailsType: .daily, weather: dailyItems[i], iconSet: setting.iconSet, hasAnyPop: hasAnyPop, theme: theme, widgetLook: setting.widgetLook)
                            if i != dailyCount - 1 {
                                Spacer(minLength: 0)
                            }
                        }

                    }else if (setting.forecastType == .hourly) {
                        let hourlyItems = hourlyWeather.prefix(hourlyCount)
                        ForEach(0..<hourlyCount, id:\.self) { i in
                            VerticalForecastView(
                                weatherDetailsType: .hourly,
                                weather: hourlyItems[i],
                                iconSet: setting.iconSet,
                                hasAnyPop: hasAnyPop,
                                theme: theme,
                                widgetLook: setting.widgetLook
                            )
                            if i != hourlyCount - 1 {
                                Spacer(minLength: 0)
                            }
                        }
                        
                    }else if (setting.forecastType == .both) {
                        HStack(spacing : 0) {
                            let hourlyItems = hourlyWeather.prefix(bothCount)
                            ForEach(0..<bothCount, id:\.self) { i in
                                VerticalForecastView(weatherDetailsType: .hourly, weather: hourlyItems[i], iconSet: setting.iconSet, hasAnyPop: hasAnyPop, theme: theme, widgetLook: setting.widgetLook)
                                if i != bothCount - 1 {
                                    Spacer(minLength: 0)
                                }
                            }
                        }
                        

                        Divider()
                            .overlay(theme.primaryTextColor.opacity(0.6))
                            .padding(.bottom, -2)
                            .padding(.horizontal)
                        

                        
                        HStack(spacing : 0) {
                            let dailyItems = dailyWeather.prefix(bothCount)
                            ForEach(0..<bothCount, id:\.self) { i in
                                VerticalForecastView(weatherDetailsType: .daily, weather: dailyItems[i], iconSet: setting.iconSet, hasAnyPop: hasAnyPop, theme: theme, widgetLook: setting.widgetLook)
                                if i != bothCount - 1 {
                                    Spacer(minLength: 0)
                                }
                            }
                        }
                    }
                }
                .frame(height : height * 0.55 * topPortion)
                
                
                if (widgetSize == .systemLarge) {
                    VStack(spacing: 0) {
                        ForEach(dailyWeather.prefix(5)) { weather in
                            Spacer(minLength: 4)
                            HorizontalForecastView(
                                weather: weather,
                                minTempOfAll: minTempOfAll,
                                maxTempOfAll: maxTempOfAll,
                                hasAnyPop: hasAnyPop,
                                hasAnyPrecipitation: hasAnyPrecipitation,
                                iconSet: setting.iconSet,
                                theme: theme,
                                widgetLook: setting.widgetLook
                            )
                        }
                    }
                    .frame(height : height * 0.55 * bottomPortion)
                }
            }
            .environment(\.colorScheme, iconsColorScheme)
            .widgetBackground(
                    ForecastBackgroundView(
                        widgetLook: setting.widgetLook,
                        widgetBackground: setting.widgetBackground,
                        widgetSize: .medium,
                        theme: theme,
                        compatibalityBGName: compatibalityBGName,
                        geo: geometry,
                        clear: !setBg
                    ),
                    isPreviewForAppWidgetTab
            )
        }
        .dynamicTypeSize(...DynamicTypeSize.large)
    }
    
    
    
    private struct CurrentDetailsView : View {
        let currentWeather : Weather
        let theme: ForecastTheme
        let setting : ForecastWidgetSetting
        
        var body: some View {
            
            VStack(alignment : .leading, spacing : 0) {
                
                HStack {
                    Text("Wind", tableName: "WeatherDetails")
                        .fonted(.caption2, weight: .medium)
                        .foregroundColor(theme.secondaryTextColor)
                        .shadow(color: setting.widgetLook == .skeumorph ? .black.opacity(0.3) : .clear ,radius: 1, y: 1)
                        
                    
                    Spacer(minLength: 0)
                    
                    Text(currentWeather.details.windSpeed!.localizedWindSpeed)
                        .fonted(.caption2, weight: .semibold)
                        .foregroundColor(theme.primaryTextColor)
                        .shadow(color: setting.widgetLook == .skeumorph ?
                            .black.opacity(0.3) : .clear ,radius: 1, y: 1)
                        .contentTransition(.numericText())
                    
                }
                .accessibilityElement(children: .combine)
                
                HStack {
                    Text("Humidity", tableName: "WeatherDetails")
                        .fonted(.caption2, weight: .medium)
                        .foregroundColor(theme.secondaryTextColor)
                        .shadow(color: setting.widgetLook == .skeumorph ? .black.opacity(0.3) : .clear ,radius: 1, y: 1)
                    
                    Spacer(minLength: 0)

                    Text(currentWeather.details.humidityDescription!)
                        .fonted(.caption2, weight: .semibold)
                        .foregroundColor(theme.primaryTextColor)
                        .shadow(color: setting.widgetLook == .skeumorph ? .black.opacity(0.3) : .clear ,radius: 1, y: 1)
                        .contentTransition(.numericText())
                    
                }
                .accessibilityElement(children: .combine)
                
            }
        }
    }
    
    private struct VerticalForecastView : View {
        var weatherDetailsType : ForecastType
        var weather: Weather
        let iconSet:  String
        let hasAnyPop: Bool
        var theme: ForecastTheme
        var widgetLook: WidgetLook
        
        var body: some View {
            VStack(spacing : 0) {
                Text(weatherDetailsType == .daily ? weather.date.shortWeekday.lowercased().localized.capitalized : weather.date.atHourWithAmPm)
                    .fonted(size: 11, weight: .semibold)
                
                    .foregroundColor(theme.primaryTextColor.opacity(0.8))
                    .shadow(color: widgetLook == .skeumorph ? .black.opacity(0.2) : .clear ,radius: 1, y: 1)
                    .accessibilityLabel(weatherDetailsType == .daily ? weather.date.weekday.localized : weather.date.atHourWithAmPm)
                    .padding(.top, 4)
                    .contentTransition(.numericText())
                
                ConditionIcon(
                    iconSet: iconSet,
                    condition: weather.condition,
                    customForegroundColor: widgetLook == .simple ? theme.primaryTextColor : nil
                )
                .accessibilityElement(children: .combine)
                .accessibilityLabel(weather.description.shortDescription)
                .frame(width:24, height: 24)
                .shadow(color: widgetLook == .neumorph ? .black.opacity(0.3) : .clear ,radius: 2, y: 1)
                .padding(.top, 2)
                
                
                if (hasAnyPop) {
                    Text(weather.details.rainPossibility ?? Constants.space)
                        .fonted(size: 10, weight: .medium)
                        .foregroundColor(theme.primaryTextColor.opacity(0.6))
                        .shadow(color: widgetLook == .skeumorph ? .black.opacity(0.15) : .clear ,radius: 1, y: 1)
                        .padding(.top, 3)
                        .contentTransition(.numericText())
                }
                
                Text(weather.temperature.now.localizedTemp)
                    .fonted(.caption, weight: .bold)
                    .foregroundColor(theme.primaryTextColor)
                    .shadow(color: widgetLook == .skeumorph ? .black.opacity(0.25) : .clear ,radius: 1, y: 1)
                    .padding(.top, 4)
                    .padding(.bottom, -2)
                    .contentTransition(.numericText())

            }
            .accessibilityElement(children: .combine)
        }
    }
    
    private struct HorizontalForecastView : View {
            let weather: Weather
            let minTempOfAll: Int
            let maxTempOfAll: Int
            let hasAnyPop: Bool
            let hasAnyPrecipitation : Bool
            let iconSet : String
            var theme: ForecastTheme
            var widgetLook: WidgetLook
            
        var body: some View {
            HStack(spacing : 0) {
                
                HStack(spacing: 0, content: {
                    VStack(alignment: .leading){
                        Text(weather.date.shortWeekday.lowercased().localized)
                            .fonted(.caption, weight: .medium)
                            .foregroundColor(theme.secondaryTextColor)
                            .accessibilityLabel(weather.date.weekday.localized)
                            .shadow(color: widgetLook == .skeumorph ? .black.opacity(0.25) : .clear ,radius: 1, y: 1)
                        
                        Text(Constants.openParen + weather.date.shortLocalizedString + Constants.closeParen)
                            .fonted(size: 8, weight: .light)
                            .opacity(Constants.secondaryOpacity)
                            .foregroundColor(theme.primaryTextColor)
                    }
                    Spacer(minLength: 0)
                })
                .frame(width: 50)
                .accessibilityElement(children: .combine)
                
                Spacer()
                    
                    
                    Text(weather.temperature.min.localizedTemp)
                        .fonted(.callout, weight: .semibold)
                        .foregroundColor(theme.secondaryTextColor)
                        .padding(.trailing, 4)
                        .shadow(color: widgetLook == .skeumorph ? .black.opacity(0.25) : .clear ,radius: 1, y: 1)
                        .accessibilityLabel(Text("at min", tableName: "Accessibility"))
                        .accessibilityValue(weather.temperature.min.localizedTemp)
                        .contentTransition(.numericText())

                    
                    TemperatureForecastBar(minTempValue: weather.temperature.min, maxTempValue: weather.temperature.max, meanTempValue: nil, minTempOfAll: minTempOfAll, maxTempOfAll: maxTempOfAll)
                        .frame(height: 18)
                        .accessibilityHidden(true)
                        .contentTransition(.numericText())

                    
                    Text(weather.temperature.max.localizedTemp)
                        .fonted(.callout, weight: .semibold)
                        .foregroundColor(theme.primaryTextColor)
                        .padding(.leading, 4)
                        .shadow(color: widgetLook == .skeumorph ? .black.opacity(0.25) : .clear ,radius: 1, y: 1)
                        .accessibilityLabel(Text("at max", tableName: "Accessibility"))
                        .accessibilityValue(weather.temperature.max.localizedTemp)
                        .contentTransition(.numericText())

                    
                    Spacer()
                    
                    HStack(alignment:.center, spacing:0) {
                        if (hasAnyPop) {
                            Text(weather.details.rainPossibility ?? Constants.space)
                                .fonted(.caption2, weight: .medium)
                                .foregroundColor(theme.primaryTextColor.opacity(0.7))
                                .frame(width: 30, height: 30, alignment: .trailing)
                                .shadow(color: widgetLook == .skeumorph ? .black.opacity(0.25) : .clear ,radius: 1, y: 1)
                                .accessibilityLabel(Text("Chance of rain", tableName: "Accessibility"))
                                .accessibilityValue(weather.details.rainPossibility ?? "")
                                .contentTransition(.numericText())

                        }
                        
                        ConditionIcon(
                            iconSet: iconSet,
                            condition: weather.condition,
                            customForegroundColor: widgetLook == .simple ? theme.primaryTextColor : nil
                        )
                        .frame(width:24, height: 24)
                        .accessibilityHidden(true)
                        .padding(.horizontal, 4)
                        .shadow(color: widgetLook == .neumorph ? .black.opacity(0.3) : .clear ,radius: 2, y: 1)
                        
                        
                        if (hasAnyPrecipitation) {
                            Text(String(weather.details.precipitation!.localizedPrecipitation.removeZerosFromEnd()))
                                .fonted(.caption2, weight: .medium)
                                .lineLimit(1)
                                .opacity(weather.details.precipitation == 0 ? 0 : 1)
                                .foregroundColor(theme.primaryTextColor)
                                .frame(width: 36, height: 30, alignment: .trailing)
                                .accessibilityHidden(true)
                                .contentTransition(.numericText())
                        }
                    }
                }
            }
        }
    
}

struct CurrentTempView : View {
    let currentWeather : Weather
    let location : City
    let updateTime : Date
    let theme: ForecastTheme
    let setting : ForecastWidgetSetting
    
    var body: some View {
        VStack(alignment: .leading, spacing : 0) {

            Text(currentWeather.description.shortDescription)
                .foregroundColor(theme.primaryTextColor)
                .fonted(.footnote, weight: .semibold)
                .lineLimit(1)
                .overlay {
                    if setting.widgetLook == .skeumorph {
                        LinearGradient(colors: [theme.textStartColor, theme.textEndColor], startPoint: .top, endPoint: .bottom)
                            .mask {
                                Text(currentWeather.description.shortDescription)
                                    .fonted(.footnote, weight: .semibold)
                                    .lineLimit(1)
                            }
                    }
                }
                .shadow(color: setting.widgetLook == .skeumorph ? .black.opacity(0.2) : .clear ,radius: 1.5, y: 1)
                .accessibilitySortPriority(1)
                .transition(.push(from: .leading))
            
            
            HStack(spacing:0) {
                Text(setting.showFeelsLike ? currentWeather.temperature.feels.localizedTemp : currentWeather.temperature.now.localizedTemp)
                    .fonted(.title, weight: .semibold)
                    .foregroundColor(theme.primaryTextColor)
                    .lineLimit(1)
                    .overlay {
                        if setting.widgetLook == .skeumorph {
                            LinearGradient(colors: [theme.textStartColor, theme.textEndColor], startPoint: .top, endPoint: .bottom)
                                .mask {
                                    Text(setting.showFeelsLike ? currentWeather.temperature.feels.localizedTemp :   currentWeather.temperature.now.localizedTemp)
                                        .fonted(.title, weight: .semibold)
                                        .lineLimit(1)
                                }
                        }
                    }
                    .contentTransition(.numericText())
                    .shadow(color: setting.widgetLook == .skeumorph ? .black.opacity(0.2) : .clear ,radius: 1.5, y: 1)
                
                ConditionIcon(
                    iconSet: setting.iconSet,
                    condition: currentWeather.condition,
                    customForegroundColor: setting.widgetLook == .simple ? theme.primaryTextColor : nil
                )
                .frame(width: 48)
                .shadow(color: setting.widgetLook == .neumorph ? .black.opacity(0.3) : .clear ,radius: 2, y: 1)
                .accessibilityHidden(true)
                
            }
        }
    }
    
}

#if DEBUG
struct ForecastWidgetMedium_Previews: PreviewProvider {
    static var previews: some View {
        ForecastWidgetFamily(widgetSize: .systemMedium).previewContext(WidgetPreviewContext(family: .systemMedium))
        
    }
}
#endif
