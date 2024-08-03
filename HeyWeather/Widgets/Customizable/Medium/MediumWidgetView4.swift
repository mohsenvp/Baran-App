//
//  MediumWidgetView4.swift
//  WeatherApp
//
//  Created by Alfredo Uzumaki on 8/30/20.
//

import SwiftUI

import SwiftUI
import WidgetKit

struct MediumWidgetView4: View {
    var weather : WeatherData = WeatherData()
    var theme : WidgetTheme = WidgetTheme()
    var id = 0
    var isPreviewForAppWidgetTab: Bool = false

    var body :some View {
        let todayWeather = weather.today
        
        VStack {
            HStack(alignment: .center, spacing : 5) {
                Spacer()
                VStack(alignment: .center) {
                    ConditionIcon(iconSet: theme.iconSet, condition: todayWeather.condition)
                        .frame(width: 50, height: 50)
                        .accessibilityHidden(true)
                    
                    MaxMinView(maxTemp: todayWeather.temperature.max.localizedTemp, minTemp: todayWeather.temperature.min.localizedTemp, fontColor: theme.fontColor, font: theme.font)
                    
                }.accessibilitySortPriority(-1)
                
                Spacer()
                
                VStack(spacing : 0) {
                    Text(todayWeather.temperature.now.localizedTemp)
                        .fonted(size: 34, weight: .regular, custom: theme.font)
                        .contentTransition(.numericText())
                    
                    Color.white
                        .frame(width: 60, height: 1)
                    
                    Text(todayWeather.description.shortDescription)
                        .fonted(size: 20, weight: .regular, custom: theme.font)
                        .padding(.top, 2)
                        .transition(.push(from: .leading))
                    
                }
                .lineLimit(1)
                .foregroundColor(theme.fontColor).padding(3)
                
                Spacer()
                
            }.frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .center)
            
            LocationView(theme: theme, weather: weather, id: id)
                .accessibilitySortPriority(-2)
        }
        .dynamicTypeSize(...DynamicTypeSize.large)
        .widgetBackground(theme.getBackground(), isPreviewForAppWidgetTab)
        .accessibilityElement(children: .combine)
    }
}

#if DEBUG
struct MediumWidgetView4_Previews: PreviewProvider {
    static var previews: some View {
        
        //        WidgetsPreviewAllSizes(widgetSize: .systemMedium) {
        //            MediumWidgetView4()
        //        }
        
        ForEach(["iPhone SE", "iPhone 11 Pro Max"], id: \.self) { deviceName in
            MediumWidgetView4()
                .previewContext(WidgetPreviewContext(family: .systemMedium))
                .previewDisplayName(deviceName)
        }
    }
}
#endif
