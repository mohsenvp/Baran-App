//
//  SmallWidgetView.swift
//  NeonWeather
//
//  Created by RezaRg on 7/18/20.
//

import SwiftUI
import WidgetKit

struct SmallWidgetView1: View {
    var weather : WeatherData = WeatherData()
    var theme : WidgetTheme = WidgetTheme()
    var id = 0
    var isPreviewForAppWidgetTab: Bool = false

    var body :some View {
        let todayWeather = weather.today
        
        VStack(alignment : .center, spacing : 0) {
            Spacer()
            ConditionIcon(iconSet: theme.iconSet, condition: todayWeather.condition)
                .frame(width: 150, height: 60)
                .padding(0)
                .accessibilityHidden(true)
            Spacer()
            
            Group {
                Text(todayWeather.temperature.now.localizedTemp)
                    .fonted(size: 17, weight: .semibold, custom: theme.font)
                    .contentTransition(.numericText())

                Text(todayWeather.description.shortDescription)
                    .fonted(size: 13, weight: .regular, custom: theme.font)
                    .transition(.push(from: .leading))

            }
            .lineLimit(1)
            .foregroundColor(theme.fontColor)
            
            Spacer()
            LocationView(theme: theme, weather: weather, id: id)
                .padding(.bottom, 8)
        }
        .dynamicTypeSize(...DynamicTypeSize.large)
        .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
        .widgetBackground(theme.getBackground(), isPreviewForAppWidgetTab)
        .accessibilityElement(children: .combine)
    }
}

#if DEBUG
struct SmallWidgetView1_Previews: PreviewProvider {
    static var previews: some View {
        WidgetsPreviewAllSizes(widgetSize: .systemSmall) {
            SmallWidgetView1()
        }
    }
}
#endif
