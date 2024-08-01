//
//  MediumWidgetView2.swift
//  NeonWeather
//
//  Created by RezaRg on 7/18/20.
//

import SwiftUI
import WidgetKit

struct MediumWidgetView2: View {
    var weather : WeatherData = WeatherData()
    var theme : WidgetTheme = WidgetTheme()
    var id = 0
    var isPreviewForAppWidgetTab: Bool = false

    var body: some View {
        let todayWeather = weather.today
        let hourlyWeather = weather.hourlyForecast
//        let updatedAt = todayWeather.updatedAt
        
        GeometryReader { geometry in
            
            let height = geometry.size.height - (isPreviewForAppWidgetTab || Constants.systemVersionIn4Digit < 17.0 ? 32 : 0)
            
            
            HStack(spacing: 0) {
                VStack(spacing: 0) {
                    
                    ConditionIcon(iconSet: theme.iconSet, condition: todayWeather.condition)
                        .frame(width: 40, height: 40, alignment: .leading)
                        .accessibilityHidden(true)
                    
                    Text(todayWeather.condition.description)
                        .fonted(size: 13, weight: .semibold, custom: theme.font)
                        .foregroundColor(theme.fontColor)
                        .lineLimit(1)
                        .frame(width: 90)
                        .padding(.vertical, 2)
                        .transition(.push(from: .leading))
                    
                    Text(todayWeather.temperature.now.localizedTemp)
                        .fonted(size: 20, weight: .semibold, custom: theme.font)
                        .foregroundColor(theme.fontColor)
                        .padding(.bottom, 8)
                        .contentTransition(.numericText())
                    
                    MaxMinView(maxTemp: todayWeather.temperature.max.localizedTemp, minTemp: todayWeather.temperature.min.localizedTemp, fontColor: theme.fontColor, font: theme.font)
                    
                    Spacer()
                    
                    LocationView(theme: theme, weather: weather, id: id)
                        .accessibilitySortPriority(-3)
                    
                }
                
                VStack(spacing: 0) {
                    HStack(spacing: 0) {
                        
                        ForEach(hourlyWeather[0...4]) { hourly in
                            NextHourVertical(weather: hourly, theme: theme)
                                .frame(maxWidth: .infinity)
                        }
                    }
                    .accessibilitySortPriority(-1)
                    .frame(height: height * 0.4)

                    
                    Spacer(minLength: 0)
                    
                    VStack(spacing: 0) {
                        HStack(spacing: 0){
                            ConditionView(conditaionKeyText: Text("Feels like", tableName: "WeatherTab"), conditionValue: todayWeather.temperature.feels.localizedTemp, theme: theme)
                            
                            ConditionView(conditaionKeyText: Text("Clouds", tableName: "WeatherDetails") , conditionValue: todayWeather.details.cloudsDescription!, theme: theme)
                        }
                        .frame(maxWidth: .infinity)
                        .frame(maxHeight: .infinity)

                        HStack(spacing: 0){
                            ConditionView(conditaionKeyText: Text("Wind", tableName: "WeatherDetails"), conditionValue: todayWeather.details.windSpeed!.localizedWindSpeed, theme: theme, reversed: true)
                            
                            ConditionView(conditaionKeyText: Text("Humidity", tableName: "WeatherDetails"), conditionValue: todayWeather.details.humidity!.description, conditionValueUnit: "%", theme: theme, reversed: true)
                        }
                        .frame(maxWidth: .infinity)

                    }
                    .accessibilitySortPriority(-2)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)

                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                
            }
            .dynamicTypeSize(...DynamicTypeSize.large)
            .widgetBackground(theme.getBackground(), isPreviewForAppWidgetTab)
            .accessibilityElement(children: .combine)
        }
    }

    struct ConditionView: View {
        var conditaionKeyText : Text
        var conditionValue : String
        var conditionValueUnit : String?
        var theme : WidgetTheme = WidgetTheme()
        var reversed: Bool = false
        
        var body: some View {
            let fontColor : Color = theme.fontColor
            
            VStack(spacing: 0){
                
                Spacer(minLength: 0)
                if reversed {
                    
                    conditaionKeyText
                        .fonted(size: 12, weight: .light, custom: theme.font)
                        .opacity(0.8)
                        .foregroundColor(fontColor)
                        .transition(.push(from: .leading))
                    
                    Text(conditionValue + (conditionValueUnit ?? ""))
                        .fonted(size: 14, weight: .semibold, custom: theme.font)
                        .foregroundColor(fontColor)
                        .contentTransition(.numericText())
                 
                    
                }else {
                    Text(conditionValue + (conditionValueUnit ?? ""))
                        .fonted(size: 14, weight: .semibold, custom: theme.font)
                        .foregroundColor(fontColor)
                        .contentTransition(.numericText())
                    
                    conditaionKeyText
                        .fonted(size: 12, weight: .light, custom: theme.font)
                        .opacity(0.8)
                        .foregroundColor(fontColor)
                        .transition(.push(from: .leading))
                    
                }
                
               
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .accessibilityElement(children: .ignore)
            .accessibilityLabel(conditaionKeyText + Text(":") + Text(conditionValue) + Text(conditionValueUnit ?? ""))
            
        }
    }
}

#if DEBUG
struct MediumWidgetView2_Previews: PreviewProvider {
    static var previews: some View {
        
        MediumWidgetView2()
            .previewContext(WidgetPreviewContext(family: .systemMedium))
        
    }
}
#endif
