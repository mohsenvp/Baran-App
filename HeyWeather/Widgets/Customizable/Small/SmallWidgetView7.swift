//
//  SmallWidgetView7.swift
//  HeyWeather
//
//  Created by RezaRg on 9/21/20.
//


import SwiftUI
import WidgetKit

struct SmallWidgetView7: View {

    var weather : WeatherData = WeatherData()
    var theme : WidgetTheme = WidgetTheme()
    var id = 0
    var isPreviewForAppWidgetTab: Bool = false

    var body :some View {
        
        VStack(spacing: 0){
            BodyOfSmallWidgetView7(weather: weather, theme: theme)
            Spacer()
            LocationView(theme: theme, weather: weather, id: id).padding(.vertical, 2)
        }
        .widgetBackground(theme.getBackground(), isPreviewForAppWidgetTab)
        .accessibilityElement(children: .combine)
        
    }
}
struct BodyOfSmallWidgetView7 : View {
    
    var weather : WeatherData = WeatherData()
    var theme : WidgetTheme = WidgetTheme()
    

    
    
    var body: some View {
        let daily = weather.dailyForecast
        
        HStack {
            VStack(alignment: .leading) {
                ForEach(daily[0...4]) { day in
                    Spacer()
                    Text(day.localDate.shortWeekday)
                        .foregroundColor(theme.fontColor)
                        .fonted(size: 12, weight: .regular, custom: theme.font)
                        .frame(alignment: .leading)
                        .accessibilityLabel(Text(day.localDate.shortWeekday))
                        .accessibilityValue(Text(day.description.shortDescription))
                }
            }
            Spacer()
            VStack(alignment: .center) {
                ForEach(daily[0...4]) { day in
                    Spacer()
                    ConditionIcon(iconSet: theme.iconSet, condition: day.condition)
                        .frame(width: 18, height: 18)
                        .accessibilityHidden(true)
                }
            }
            Spacer()
            VStack(alignment: .trailing) {
                ForEach(daily[0...4]) { day in
                    Spacer()
                    MaxMinView(maxTemp: day.temperature.max.localizedTemp, minTemp: day.temperature.min.localizedTemp,  fontColor: theme.fontColor, font: theme.font)
                }
            }
        }
        .dynamicTypeSize(...DynamicTypeSize.large)
    }
    
}

#if DEBUG
struct SmallWidgetView7_Previews: PreviewProvider {
    static var previews: some View {
        
        SmallWidgetView7()
            .previewContext(WidgetPreviewContext(family: .systemSmall))
        
    }
}
#endif
