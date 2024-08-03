//
//  LargeWidgetView6.swift
//  HeyWeather
//
//  Created by RezaRg on 9/19/20.
//

import SwiftUI
import WidgetKit

struct LargeWidgetView6: View {
    var weather : WeatherData = WeatherData()
    var theme : WidgetTheme = WidgetTheme()
    var id = 0
    var isPreviewForAppWidgetTab: Bool = false

    var body :some View {
        let todayWeather = weather.today
        let daily = weather.dailyForecast
        let hourly = weather.hourlyForecast
        
        GeometryReader { geometry in
            let height = geometry.size.height - (isPreviewForAppWidgetTab || Constants.systemVersionIn4Digit < 17.0 ? 32 : 0)
            VStack(spacing: 0) {
                
                HStack(spacing: 0){
                    
                    VStack(spacing : 0) {
                        Text(todayWeather.temperature.now.localizedTemp)
                            .fonted(size: 34, weight: .regular, custom: theme.font)
                            .contentTransition(.numericText())
                        
                        Color.white
                            .frame(width: 70, height: 1)
                        
                        Text(todayWeather.condition.description)
                            .fonted(size: 20, weight: .regular, custom: theme.font)
                            .padding(.top, 2)
                            .frame(maxWidth: 80)
                            .accessibilitySortPriority(-1)
                            .transition(.push(from: .leading))
                        
                    }
                    .lineLimit(1)
                    .foregroundColor(theme.fontColor).padding(3)
                    
                    Spacer()
                    
                    VStack(alignment: .center) {
                        ConditionIcon(iconSet: theme.iconSet, condition: todayWeather.condition)
                            .frame(width: 46, height: 46)
                            .accessibilityHidden(true)
                    }
                    
                    Spacer()
                    
                    VStack {
                        MaxMinView(maxTemp: todayWeather.temperature.max.localizedTemp, minTemp: todayWeather.temperature.min.localizedTemp, fontColor: theme.fontColor, font: theme.font).padding(.vertical, 4)
                            .accessibilitySortPriority(-2)
                        LocationView(theme: theme, weather: weather, id: id)
                            .accessibilitySortPriority(-6)
                    }
                    
                }
                .frame(height: height * 0.25)
                .frame(maxWidth : .infinity)
                
                HStack {
                    let hourlyItems = hourly.prefix(7)
                    ForEach(0..<hourlyItems.count, id: \.self) { i in
                        NextHourVertical(weather: hourlyItems[i], theme: theme)
                        if i != hourlyItems.count - 1 {
                            Spacer(minLength: 0)
                        }
                    }
                }
                .padding(.horizontal, 4)
                .frame(height: height * 0.25)
                .frame(maxWidth : .infinity)
                .accessibilitySortPriority(-3)
                
                
                HStack{
                    ForEach(daily.prefix(5)) { daily in
                        SingleCapsuleDetailViewMedium(theme: theme, weather: daily)
                    }   
                }
                .frame(height: height * 0.5)
                .frame(maxWidth : .infinity)
                .accessibilitySortPriority(-4)
                
            }
            .dynamicTypeSize(...DynamicTypeSize.large)
            .widgetBackground(theme.getBackground(), isPreviewForAppWidgetTab)
            .accessibilityElement(children: .combine)
        }
        
    }
    
}

#if DEBUG
struct LargeWidgetView6_Previews: PreviewProvider {
    static var previews: some View {
        LargeWidgetView6()
            .previewContext(WidgetPreviewContext(family: .systemLarge))
    }
}
#endif
