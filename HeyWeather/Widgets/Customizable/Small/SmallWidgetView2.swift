//
//  SmallWidgetView2.swift
//  NeonWeather
//
//  Created by RezaRg on 7/18/20.
//

import SwiftUI
import WidgetKit
struct SmallWidgetView2 : View {

    var weather : WeatherData = WeatherData()
    var theme : WidgetTheme = WidgetTheme()
    var id = 0
    var isPreviewForAppWidgetTab: Bool = false

    var body: some View {
        let todayWeather = weather.today
        
        VStack(spacing : 0) {
            GeometryReader { geometry in
                let height = geometry.size.height - (isPreviewForAppWidgetTab || Constants.systemVersionIn4Digit < 17.0 ? 32 : 0)
                
                VStack(spacing : 0) {
                    
                    HStack(spacing: 10) {
                        ConditionIcon(iconSet: theme.iconSet, condition: todayWeather.condition)
                            .frame(width: 36.0,height: 36)
                            .padding([.top],4)
                            .accessibilityHidden(true)
                        
                        Spacer()
                        MaxMinView(maxTemp: todayWeather.temperature.max.localizedTemp, minTemp: todayWeather.temperature.min.localizedTemp, fontColor: theme.fontColor, font: theme.font)
                            .accessibilitySortPriority(-2)
                    }
                    .frame(maxWidth: .infinity)
                    .frame(height: height * 0.25)
                    
                    HStack(spacing: 20) {
                        Text(todayWeather.temperature.now.localizedTemp)
                            .fonted(size: 56, weight: .semibold, custom: theme.font)
                            .foregroundColor(theme.fontColor)
                            .accessibilityValue(Text(todayWeather.description.shortDescription))
                            .contentTransition(.numericText())
                    }
                    .frame(height: height * 0.60)
                    .frame(maxWidth: .infinity)
                    
                    LocationView(theme: theme, weather: weather, id: id)
                        .frame(maxWidth: .infinity)
                        .frame(height : height * 0.15)
                        .accessibilitySortPriority(-3)
                }
            }
            
            
        }
        .dynamicTypeSize(...DynamicTypeSize.large)
        .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .topLeading)
        .widgetBackground(theme.getBackground(), isPreviewForAppWidgetTab)
        .accessibilityElement(children: .combine)
    }
}

#if DEBUG
struct SmallWidgetView2_Previews: PreviewProvider {
    static var previews: some View {
        WidgetsPreviewAllSizes(widgetSize: .systemSmall) {
            SmallWidgetView2()
        }
    }
}
#endif
