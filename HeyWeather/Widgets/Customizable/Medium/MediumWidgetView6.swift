//
//  MediumWidgetView6.swift
//  WeatherApp
//
//  Created by GCo iMac on 8/31/20.
//


import SwiftUI
import WidgetKit

struct MediumWidgetView6: View {
    var weather : WeatherData = WeatherData()
    var theme : WidgetTheme = WidgetTheme()
    var id = 0
    var isPreviewForAppWidgetTab: Bool = false

    var body :some View {
        let todayWeather = weather.today
        VStack(alignment: .center, spacing : 0) {
            
            
            HStack() {
                
                Spacer()
                
                VStack {
                    Text(todayWeather.temperature.now.localizedTemp)
                        .fonted(size: 34, weight: .regular, custom: theme.font)
                        .contentTransition(.numericText())
                    
                    MaxMinView(maxTemp: todayWeather.temperature.max.localizedTemp, minTemp: todayWeather.temperature.min.localizedTemp, fontColor: theme.fontColor, font: theme.font)
                }
                .foregroundColor(theme.fontColor)
                
                Spacer()
                
                VStack() {
                    ConditionIcon(iconSet: theme.iconSet, condition: todayWeather.condition)
                        .frame(width: 66, height: 46)
                        .accessibilityHidden(true)
                    
                    Text(todayWeather.description.shortDescription)
                        .foregroundColor(theme.fontColor)
                        .fonted(size: 17, weight: .regular, custom: theme.font)
                        .lineLimit(1)
                        .transition(.push(from: .leading))
                }
                .frame(maxHeight : .infinity)
                .accessibilitySortPriority(-1)
                Spacer()
            }
            Spacer(minLength: 12)
            
            HStack (){
                LocationView(theme: theme, weather: weather, id: id)
            }
            .accessibilitySortPriority(-3)
            
            
            HStack() {
                let none = Constants.none
                Spacer()
                ConditionView3(icon: Constants.SystemIcons.wind, color: theme.fontColor, title: Strings.WeatherDetails.getWeatherDetailsTitle(for: .wind), value: todayWeather.details.windSpeed?.localizedWindSpeed ?? none, theme: theme, width: 48)
                Spacer()
                ConditionView3(icon: Constants.SystemIcons.sparkles, color: theme.fontColor, title: Strings.WeatherDetails.getWeatherDetailsTitle(for: .humidity), value: todayWeather.details.humidity?.description ?? none, valueUnit: "%",theme: theme, width: 48)
                Spacer()
                ConditionView3(icon: Constants.SystemIcons.uCircle, color: theme.fontColor, title: Strings.WeatherDetails.getWeatherDetailsTitle(for: .uvIndex), value: todayWeather.details.uvIndex?.localizedNumber() ?? none, theme: theme, width: 48)
                Spacer()
            }
            .frame(height: 48)
            .frame(maxWidth: .infinity)
            .accessibilitySortPriority(-2)
        }
        .dynamicTypeSize(...DynamicTypeSize.large)
        .widgetBackground(theme.getBackground(), isPreviewForAppWidgetTab)
        .accessibilityElement(children: .combine)
    }
}

#if DEBUG
struct MediumWidgetView6_Previews: PreviewProvider {
    static var previews: some View {
        WidgetsPreviewAllSizes(widgetSize: .systemMedium) {
            MediumWidgetView6()
        }
    }
}
#endif
