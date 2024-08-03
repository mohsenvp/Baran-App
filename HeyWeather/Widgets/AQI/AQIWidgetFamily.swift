//
//  AQIWidgetFamily.swift
//  HeyWeather
//
//  Created by Mohammad Yeganeh on 7/22/23.
//

import SwiftUI
import WidgetKit
import UIKit

struct AQIWidgetFamily: View {
    var weather: WeatherData
    var aqiData: AQIData
    var setting: AQIWidgetSetting
    var widgetSize : WidgetFamily
    var id = 0
    var isPreviewForAppWidgetTab: Bool = false

    var body: some View {
        switch setting.widgetStyle {
        case .simple:
            SimpleAQIWidgetView(weather: weather, aqiData: aqiData, setting: setting, widgetSize: widgetSize, id: id, isPreviewForAppWidgetTab: isPreviewForAppWidgetTab)
        case .guage:
            GuageAQIWidgetView(weather: weather, aqiData: aqiData, setting: setting, widgetSize: widgetSize, id: id, isPreviewForAppWidgetTab: isPreviewForAppWidgetTab)
        case .detailed:
            DetailedAQIWidgetView(weather: weather, aqiData: aqiData, setting: setting, widgetSize: widgetSize, id: id, isPreviewForAppWidgetTab: isPreviewForAppWidgetTab)
        }
    }
}


private struct SimpleAQIWidgetView: View {
    var weather: WeatherData
    var aqiData: AQIData
    var setting: AQIWidgetSetting
    var widgetSize : WidgetFamily
    var id = 0
    var isPreviewForAppWidgetTab: Bool = false

    var body: some View {
        HStack {
            if widgetSize == .systemMedium {
                VStack(alignment: .leading){
                    BodyOfSmallWidgetView3(
                        weather: weather,
                        theme: .init(
                            city: weather.location,
                            showCityName: setting.showCityName,
                            showAddress: setting.showAddress
                        )
                    )
                    .foregroundStyle(.primary)
                    .foregroundColor(.white)
                    
                    LocationView(theme: .init(city: weather.location, showCityName: setting.showCityName, showAddress: setting.showAddress), weather: weather)
                        .foregroundStyle(.secondary)
                }
            }
            SimpleAQIContent(weather: weather, aqiData: aqiData, setting: setting, widgetSize: widgetSize, id: id)
        }
        .widgetBackground(Constants.aqiColors[aqiData.current.index], isPreviewForAppWidgetTab)
    }
}

private struct GuageAQIWidgetView: View {
    var weather: WeatherData
    var aqiData: AQIData
    var setting: AQIWidgetSetting
    var widgetSize : WidgetFamily
    var id = 0
    var isPreviewForAppWidgetTab: Bool = false

    @Environment(\.colorScheme) var colorScheme

    var body: some View {
        if widgetSize == .systemSmall {
            VStack(spacing: 0){
                AQIGuageView(aqi: aqiData.current)
                    .foregroundStyle(.primary)
                    .widgetAccentable()

                LocationView(theme: .init(city: weather.location, showCityName: setting.showCityName, showAddress: setting.showAddress, textColor: colorScheme == .dark ? UIColor.white.hexString! : UIColor.black.hexString!), weather: weather)
                    .foregroundStyle(.secondary)
                
            }
            .widgetBackground(Color(.systemBackground), isPreviewForAppWidgetTab)


        }else {
            VStack {
                AQIView(aqi: aqiData.current)
                    .foregroundColor(.primary)
                    .widgetAccentable()

                HStack {
                    ConditionIcon(iconSet: Constants.defaultIconSet, condition: weather.today.condition)
                        .frame(width: 50, height: 50)
                        
                    VStack(alignment: .leading, spacing: -4){
                        LocationView(
                            theme: .init(
                                city: weather.location,
                                showCityName: setting.showCityName,
                                showAddress: setting.showAddress,
                                textColor: colorScheme == .dark ? UIColor.white.hexString! : UIColor.black.hexString!
                            ), weather: weather
                        )
                        .foregroundStyle(.secondary)
                        .padding(.leading, 2)
                        
                        Text(weather.today.temperature.now?.localizedTemp ?? "")
                            .fonted(.largeTitle, weight: .bold)
                            .foregroundStyle(.primary)
                            .contentTransition(.numericText())

                            
                        Text(weather.today.description.shortDescription)
                            .fonted(.callout, weight: .semibold)
                            .foregroundStyle(.primary)
                            .minimumScaleFactor(0.7)
                            .padding(.top, -4)
                            .padding(.leading, 2)
                    }
                    .frame(maxWidth: Constants.mediumWidgetSize.width * 0.3, alignment: .leading)
                    
                    Spacer(minLength: 6)
                    
                
                    VStack {
                        if weather.dailyForecast.count > 2 && aqiData.dailyForecast.count > 2{
                            ForEach(Array(weather.dailyForecast.prefix(3))) { weather in
                                let aqi = aqiData.dailyForecast.filter({$0.date.isOnSameDay(with: weather.localDate)}).first ?? .init()
                                Spacer(minLength: 0)
                                HStack(spacing: 4){
                                    Group {
                                        if weather.localDate.isRealNow(timezone : weather.timezone) {
                                            Text("Now", tableName: "General")
                                        }else{
                                            Text(weather.localDate.shortWeekday.capitalized)
                                        }
                                    }
                                    .fonted(.caption2, weight: .semibold)
                                        .foregroundStyle(.tertiary)
                                        .frame(width: 30, alignment: .leading)
                                    
                                    Text(weather.temperature.max?.localizedTemp ?? "")
                                        .fonted(.caption, weight: .medium)
                                        .foregroundStyle(.primary)
                                        .frame(width: 26)
                                        .contentTransition(.numericText())

                                    
                                    Text(weather.temperature.min?.localizedTemp ?? "")
                                        .fonted(.caption, weight: .regular)
                                        .foregroundStyle(.secondary)
                                        .frame(width: 24)
                                        .contentTransition(.numericText())

                                    ConditionIcon(iconSet: Constants.defaultIconSet, condition: weather.condition)
                                        .frame(width: 18, height: 18)
                                    
                                    Capsule().fill(Constants.aqiColors[aqi.index])
                                        .frame(width: 16, height: 3)
                                    
                                    Text("\(aqi.value)")
                                        .fonted(.caption, weight: .semibold)
                                        .foregroundColor(Constants.aqiColors[aqi.index])
                                        .frame(width: 24)
                                        .contentTransition(.numericText())

                                }
                            }
                        }
                        
                    }
                }
            }
            .widgetBackground(Color(.systemBackground), isPreviewForAppWidgetTab)

        }
    }
}

private struct DetailedAQIWidgetView: View {
    var weather: WeatherData
    var aqiData: AQIData
    var setting: AQIWidgetSetting
    var widgetSize : WidgetFamily
    var id = 0
    var isPreviewForAppWidgetTab: Bool = false

    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        let textColor = colorScheme == .dark ? UIColor.white.hexString! : UIColor.black.hexString!
        if widgetSize == .systemSmall {
            VStack(spacing: -14){
                
                AQIDegreeView(aqi: aqiData.current)
                
                LocationView(theme: .init(city: weather.location, showCityName: setting.showCityName, showAddress: setting.showAddress, textColor: textColor), weather: weather)
                    .opacity(0.7)
            }
            .widgetBackground(Color(.systemBackground), isPreviewForAppWidgetTab)

        }else {
            HStack {
                VStack(alignment: .leading){
                    BodyOfSmallWidgetView3(
                        weather: weather,
                        theme: .init(
                            city: weather.location,
                            showCityName: setting.showCityName,
                            showAddress: setting.showAddress,
                            textColor: textColor
                        )
                    )

                    Spacer(minLength: 0)
                    
                    LocationView(theme: .init(city: weather.location, showCityName: setting.showCityName, showAddress: setting.showAddress, textColor: textColor), weather: weather)
                }

                VStack {
                    let aqiItems = aqiData.dailyForecast[0..<4]
                    ForEach(0..<aqiItems.count, id: \.self) { i in
                        let aqi = aqiItems[i]
                        AQIDashView(
                            name: aqi.localDate.isTodayReal() ? Text("Today (Now)", tableName: "General") : Text(aqi.localDate.weekday),
                            value: CGFloat(aqi.value),
                            aqiIndex: aqi.index,
                            lineWidth: 3,
                            lineSpacing: 6,
                            textToBarSpacing: 3,
                            titleFontSize: 12,
                            valueFontSize: 12
                        )
                        if i != aqiItems.count - 1 {
                            Spacer()
                        }
                    }
                }
                .foregroundColor(Color.init(.label).opacity(0.8))
            }
            .widgetBackground(Color(.systemBackground), isPreviewForAppWidgetTab)


        }
    }
}

struct SimpleAQIContent: View {
    var weather: WeatherData
    var aqiData: AQIData
    var setting: AQIWidgetSetting
    var widgetSize : WidgetFamily
    var id = 0

    var body: some View {
        VStack(alignment: .leading, spacing: -4){
            Group {
                                
                Text("Air Quality", tableName: "AQI")
                    .fonted(.callout, weight: .medium)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                Spacer(minLength: 0)
                
                Text("US AQI:", tableName: "AQI")
                    .fonted(.caption2, weight: .regular)
                
                Text("\(aqiData.current.value)")
                    .fonted(.largeTitle, weight: .bold)
                    .contentTransition(.numericText())

                
                Text(aqiData.current.status)
                    .fonted(.body, weight: .regular)
                    .padding(.top, 2)
                
                Spacer(minLength: 0)
                
                if widgetSize == .systemSmall {
                    LocationView(theme: .init(city: weather.location, showCityName: setting.showCityName, showAddress: setting.showAddress), weather: weather)
                }else {
                    AQIDashView(
                        name: Text("Tomorrow", tableName: "General"),
                        lineWidth: 3,
                        lineSpacing: 4,
                        foregroundColor: .white,
                        titleFontSize: 12,
                        valueFontSize: 12
                    )
                    .fonted(.caption2)
                }
            }
        }
        .foregroundColor(.white)
    }
}


struct AQIWidgetFamily_Previews: PreviewProvider {
    static var previews: some View {
        AQIWidgetFamily(weather: .init(), aqiData: .init(), setting: .init(widgetStyle: .detailed, showCityName: true), widgetSize: .systemSmall)
            .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}
