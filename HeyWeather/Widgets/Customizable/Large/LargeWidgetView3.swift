//
//  LargeWidgetView3.swift
//  WeatherApp
//
//  Created by RezaRg on 8/31/20.
//

import SwiftUI
import WidgetKit

struct LargeWidgetView3: View {
    var weather : WeatherData = WeatherData()
    var theme : WidgetTheme = WidgetTheme()
    var id = 0
    var isPreviewForAppWidgetTab: Bool = false

    var body: some View {
        let todayWeather = weather.today
        
        VStack {
            HStack{
                VStack (alignment : .leading){
                    Text(todayWeather.condition.description)
                        .fonted(size: 34, weight: .regular, custom: theme.font)
                        .lineLimit(2)
                        .foregroundColor(theme.fontColor)
                        .transition(.push(from: .leading))
                    Text(theme.city.name)
                        .lineLimit(1)
                        .fonted(size: 17, weight: .regular, custom: theme.font)
                        .foregroundColor(theme.fontColor.opacity(0.6))
                        .accessibilitySortPriority(-2)
                        .transition(.push(from: .leading))
                }
                .frame(height : 80)
                
                Spacer()
                ConditionIcon(iconSet: theme.iconSet, condition: todayWeather.condition)
                    .frame(width: 60, height: 60)
                    .accessibilityHidden(true)
                Spacer()
                
                Text(todayWeather.temperature.now.localizedTemp)
                    .lineLimit(1)
                    .foregroundColor(theme.fontColor)
                    .fonted(size: 60, weight: .regular, custom: theme.font)
                    .frame(height : 80)
                    .contentTransition(.numericText())

            }
            
            theme.fontColor
                .frame(height: 1)
                .frame(maxWidth : .infinity)
            
            Spacer(minLength: 20)
            
            HStack(spacing : 0) {
                let hourlyItems = weather.hourlyForecast[0...6]
                ForEach(0..<hourlyItems.count, id: \.self) { i in
                    let hourly = hourlyItems[i]
                    VStack(spacing : 0) {
                        Text(hourly.date.atHour)
                            .fonted(size: 20, weight: .regular, custom: theme.font)
                            .foregroundColor(theme.fontColor)
                            .contentTransition(.numericText())
                        Spacer()
                        ConditionIcon(iconSet: theme.iconSet, condition: hourly.condition)
                            .frame(width: 30, height: 30)
                        Spacer()
                        Text(hourly.temperature.now.localizedTemp)
                            .fonted(size: 20, weight: .regular, custom: theme.font)
                            .foregroundColor(theme.fontColor)
                            .contentTransition(.numericText())
                    }
                    .accessibilityElement(children: .ignore)
                    .accessibilityLabel(Text(hourly.temperature.now.localizedTemp + hourly.condition.description + "at".localized + hourly.date.atHour))
                    
                    if i != hourlyItems.count - 1 {
                        Spacer()
                    }
                }
            }
            Spacer()
        }
        .dynamicTypeSize(...DynamicTypeSize.large)
        .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .topLeading)
        .widgetBackground(theme.getBackground(), isPreviewForAppWidgetTab)
        .accessibilityElement(children: .combine)
    }
}

#if DEBUG
struct LargeWidgetView3_Previews: PreviewProvider {
    static var previews: some View {
        LargeWidgetView3()
            .previewContext(WidgetPreviewContext(family: .systemLarge))
    }
}
#endif
