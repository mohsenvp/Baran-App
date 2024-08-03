//
//  SmallWidgetView4.swift
//  WeatherApp
//
//  Created by Alfredo Uzumaki on 8/30/20.
//

import SwiftUI
import WidgetKit

struct SmallWidgetView4: View {
    
    var weather : WeatherData = WeatherData()
    var theme : WidgetTheme = WidgetTheme()
    var id = 0
    var isPreviewForAppWidgetTab: Bool = false

    var body :some View {
        VStack(spacing: 0){
            BodyOfSmallWidgetView4(weather: weather, theme: theme)
                .padding(.horizontal)


            LocationView(theme: theme, weather: weather, id: id)
                .padding(.top, 10)
        }
        .widgetBackground(theme.getBackground(), isPreviewForAppWidgetTab)
        .accessibilityElement(children: .combine)
        
    }
}
struct BodyOfSmallWidgetView4 : View {
    var weather : WeatherData = WeatherData()
    var theme : WidgetTheme = WidgetTheme()
    
    var body: some View {
        let hourlyItems = weather.hourlyForecast.prefix(5)
        
        VStack(spacing: 0){
            ForEach(0..<hourlyItems.count, id: \.self) { i in
                let hourly = hourlyItems[i]
                HStack {
                    Text(hourly.date.atHour)
                        .foregroundColor(theme.fontColor)
                        .fonted(size: 13, weight: .regular, custom: theme.font)
                        .frame(alignment: .leading)
                        .accessibilityLabel(Text(hourly.temperature.now.localizedTemp) + Text(hourly.description.shortDescription) + Text(", at".localized + hourly.date.atHour))
                        .contentTransition(.numericText())
                    
                    Spacer(minLength: 0)
                    
                    ConditionIcon(iconSet: theme.iconSet, condition: hourly.condition)
                        .frame(width: 18, height: 18)
                        .accessibilityHidden(true)
                    
                    Spacer(minLength: 0)
                    
                    Text(hourly.temperature.now.localizedTemp)
                        .foregroundColor(theme.fontColor)
                        .fonted(size: 13, weight: .regular, custom: theme.font)
                        .frame(alignment: .trailing)
                        .accessibilityHidden(true)
                        .contentTransition(.numericText())
                }
                if i != hourlyItems.count - 1 {
                    Spacer(minLength: 6)
                }
            }
        }
        .dynamicTypeSize(...DynamicTypeSize.large)
    }
    
    
}

#if DEBUG
struct SmallWidgetView4_Previews: PreviewProvider {
    static var previews: some View {
        SmallWidgetView4()
            .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}
#endif
