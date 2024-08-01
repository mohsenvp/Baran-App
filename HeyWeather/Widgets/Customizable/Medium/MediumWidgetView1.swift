//
//  MediumWidgetView1.swift
//  NeonWeather
//
//  Created by RezaRg on 7/18/20.
//

import SwiftUI
import WidgetKit

struct MediumWidgetView1: View {
    var weather : WeatherData = WeatherData()
    var theme : WidgetTheme = WidgetTheme()
    var id = 0
    var isPreviewForAppWidgetTab: Bool = false
    
    var body: some View {
        
        let todayWeather = weather.today
        let hourlyWeather = weather.hourlyForecast
        let dailyWeather = weather.dailyForecast
        
        let fontColor : Color = theme.fontColor
        let location = weather.location
        
        GeometryReader { geo in
            HStack(spacing: 0) {
                VStack(spacing: 0) {
                    
                    if (theme.showUpdateTime) {
                        Text(weather.updateTime.localizedHourAndMinutes(forceCurrentTimezone: true))
                            .fonted(size: 12, weight: .semibold, custom: theme.font)
                            .foregroundColor(fontColor)
                            .contentTransition(.numericText())
                    }
                    
                    Spacer(minLength: 0)
                    
                    ConditionIcon(iconSet: theme.iconSet, condition: todayWeather.condition)
                        .frame(width: 50, height: 50)
                        .accessibilityHidden(true)
                        .padding(.bottom, 6)
                    
                    Text(todayWeather.description.shortDescription)
                        .foregroundColor(theme.fontColor)
                        .fonted(size:13, weight: .semibold, custom: theme.font)
                        .lineLimit(2)
                        .multilineTextAlignment(.center)
                        .fixedSize(horizontal: false, vertical: true)
                        .minimumScaleFactor(0.99)
                        .transition(.push(from: .leading))
                    
                    Spacer(minLength: 0)
                    
                    if (theme.showCityName) {
                        
                        Text(theme.showAddress ? location.name : (location.placeMarkCityName ?? location.name))
                            .fonted(size:12, weight: .medium, custom: theme.font)
                            .lineLimit(2)
                            .multilineTextAlignment(.center)
                            .fixedSize(horizontal: false, vertical: true)
                            .minimumScaleFactor(0.8)
                            .foregroundColor(fontColor)
                    }
                }
                .padding(.horizontal, 2)
                .frame(width: geo.size.width * 0.26)
                .frame(maxHeight: .infinity)
                
                
                
                
                VStack(spacing: 0) {
                    VStack(spacing: 0) {
                        
                        
                        Text(todayWeather.temperature.now.localizedTemp)
                            .fonted(size: 40, weight: .medium, custom: theme.font)
                            .foregroundColor(theme.fontColor)
                            .contentTransition(.numericText())
                        
                        MaxMinView(maxTemp: todayWeather.temperature.max.localizedTemp, minTemp: todayWeather.temperature.min.localizedTemp, fontColor: theme.fontColor, fontSize: 13, font: theme.font)
                            .accessibilitySortPriority(-1)
                        
                    }
                    Spacer(minLength: 0)
                    
                    HStack(alignment : .center){
                        ForEach(hourlyWeather[0...3]) { hourly in
                            Spacer(minLength: 1)
                            NextHourVertical(weather: hourly, theme: theme)
                        }
                        Spacer(minLength: 1)
                    }
                    .accessibilitySortPriority(-2)
                }
                .frame(width: geo.size.width * 0.44)
                
                
                VStack(alignment: .leading, spacing: 0) {
                    ForEach(0...3, id: \.self) { i in
                        NextDayHorizontal(weather: dailyWeather[i], theme: theme)
                        if i != 3 {
                            Spacer(minLength: 0)
                        }
                    }
                }
                .frame(width: geo.size.width * 0.30)
                .accessibilitySortPriority(-3)
                
            }
        }
        .widgetBackground(theme.getBackground(), isPreviewForAppWidgetTab)
        .dynamicTypeSize(...DynamicTypeSize.large)
        .accessibilityElement(children: .combine)
    }
}

#if DEBUG
struct MediumWidgetView1_Previews: PreviewProvider {
    static var previews: some View {
        
        MediumWidgetView1(id : 12)
            .previewContext(WidgetPreviewContext(family: .systemMedium))
        
        //        ForEach(["iPhone SE", "iPhone 11 Pro Max"], id: \.self) { deviceName in
        //            MediumWidgetView1()
        //                .previewContext(WidgetPreviewContext(family: .systemMedium))
        //                .previewDisplayName(deviceName)
        //        }
    }
}
#endif
