//
//  SmallWidgetView3.swift
//  WeatherApp
//
//  Created by RezaRg on 8/2/20.
//

import SwiftUI
import WidgetKit

struct SmallWidgetView3: View {

    var weather : WeatherData = WeatherData()
    var theme : WidgetTheme = WidgetTheme()
    var id = 0
    var isPreviewForAppWidgetTab: Bool = false

    var body: some View {
        VStack {
            BodyOfSmallWidgetView3(weather: weather, theme: theme)
            HStack {
                LocationView(theme: theme, weather: weather, id: id)
                Spacer()
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        .widgetBackground(theme.getBackground(), isPreviewForAppWidgetTab)
        .accessibilityElement(children: .combine)
        
    }
}

struct BodyOfSmallWidgetView3 : View {
    var weather : WeatherData = WeatherData()
    var theme : WidgetTheme = WidgetTheme()
    
    var body: some View {
        let todayWeather = weather.today
        
        VStack(spacing : 0) {
            
            HStack (spacing : 0) {
                ConditionIcon(iconSet: theme.iconSet, condition: todayWeather.condition)
                    .scaledToFit()
                    .frame(width: 26, height: 26)
                    .padding(.trailing, 8)
                    .accessibilityHidden(true)
                
                Text(todayWeather.description.shortDescription)
                    .fonted(size: 12, weight: .regular, custom: theme.font)
                    .foregroundColor(theme.fontColor)
                    .transition(.push(from: .leading))
                Spacer(minLength: 0)
            }
            
            HStack {
                Text(todayWeather.temperature.now.localizedTemp)
                    .fonted(size: 28, weight: .bold, custom: theme.font)
                    .foregroundColor(theme.fontColor)
                    .contentTransition(.numericText())
                Spacer()
            }
            .padding(.vertical, 10)
            HStack {
                Group {
                    Text("Feels like: \(todayWeather.temperature.feels.localizedTemp)", tableName: "WeatherTab")
                }
                .fonted(size: 13, weight: .regular, custom: theme.font)
                .foregroundColor(theme.fontColor.opacity(0.6))
                .contentTransition(.numericText())
                Spacer()
            }
            
            HStack {
                MaxMinView(maxTemp: todayWeather.temperature.max.localizedTemp, minTemp: todayWeather.temperature.min.localizedTemp,  fontColor: theme.fontColor, font: theme.font)
                Spacer()
            }
            
            Spacer()
        }.dynamicTypeSize(...DynamicTypeSize.large)
    }
    
}



#if DEBUG
struct SmallWidgetView3_Previews: PreviewProvider {
    static var previews: some View {
        WidgetsPreviewAllSizes(widgetSize: .systemSmall) {
            SmallWidgetView3()
        }
    }
}
#endif
