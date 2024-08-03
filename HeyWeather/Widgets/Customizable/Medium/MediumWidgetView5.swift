//
//  MediumWidgetView5.swift
//  WeatherApp
//
//  Created by GCo iMac on 8/31/20.
//

import SwiftUI
import WidgetKit

struct MediumWidgetView5: View {
    var weather : WeatherData = WeatherData()
    var theme : WidgetTheme = WidgetTheme()
    var id = 0
    var isPreviewForAppWidgetTab: Bool = false

    var body :some View {
        let todayWeather = weather.today
        let dailyWeather = weather.dailyForecast
//        let updatedAt = todayWeather.updatedAt
        
        HStack(alignment: .center, spacing : 0) {
                        
            VStack(alignment: .leading, spacing : 0) {
                                
                ConditionIcon(iconSet: theme.iconSet, condition: todayWeather.condition)
                    .frame(width: 40, height: 40)
                    .accessibilityHidden(true)
                
                Group {
                    Text(todayWeather.temperature.now.localizedTemp)
                        .fonted(size: 28, weight: .regular, custom: theme.font)
                        .contentTransition(.numericText())

                    MaxMinView(maxTemp: todayWeather.temperature.max.localizedTemp, minTemp: todayWeather.temperature.min.localizedTemp, fontColor: theme.fontColor, font: theme.font)
                        .accessibilityLabel(Text("\(todayWeather.temperature.max.localizedTemp) \("at.max".localized), \(todayWeather.temperature.min.localizedTemp) \("at.min".localized)"))             
                    
                    Text(todayWeather.condition.description)
                        .fonted(size: 15, weight: .regular, custom: theme.font)
                        .transition(.push(from: .leading))
                }
                .lineLimit(1)
                .foregroundColor(theme.fontColor)
                
                Spacer(minLength: 0)
                
                LocationView(theme: theme, weather: weather, id: id)
                    .accessibilitySortPriority(-2)

            }
            
            Spacer(minLength: 8)
            
            HStack(spacing: 0) {
                ForEach(dailyWeather[0...3]) { daily in
                    Spacer()
                    SingleCapsuleDetailViewMedium(theme: theme, weather: daily)
                        .accessibilitySortPriority(-1)
                }
            }
        }
        .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
        .widgetBackground(theme.getBackground(), isPreviewForAppWidgetTab)
        .accessibilityElement(children: .combine)
    }
}

struct SingleCapsuleDetailViewMedium: View {
    let theme: WidgetTheme
    let weather: Weather
    var body: some View {
        let weekDay = weather.date.weekday.lowercased().localized
        ZStack {
            Color.white.opacity(0.3)
            VStack(spacing: 0) {
                ConditionIcon(iconSet: theme.iconSet, condition: weather.condition)
                    .frame(width: 30, height: 30)
                    .padding(.top, 10)
                    .accessibilityHidden(true)
                Spacer(minLength: 0)
                
                Group {
                    Text(weather.temperature.max?.localizedTemp ?? "")
                        .fonted(size: 12, weight: .medium, custom: theme.font)
                        .padding(.leading, 3)
                        .contentTransition(.numericText())
                    
                    Text(weather.temperature.min?.localizedTemp ?? "")
                        .fonted(size: 11, weight: .medium, custom: theme.font)
                        .opacity(0.8)
                        .padding(.leading, 2)
                        .contentTransition(.numericText())
                }
                .foregroundColor(theme.fontColor)
                .accessibilityElement(children: .ignore)
                .accessibilityLabel(Text("\(weather.temperature.max?.localizedTemp ?? "") \("at.max".localized), \(weather.temperature.min?.localizedTemp ?? "") \("at.min".localized)"))
            
                Spacer(minLength: 0)
                Text(weather.condition.description)
                    .fonted(size: 11, weight: .light, custom: theme.font)
                    .lineLimit(2)
                    .foregroundColor(theme.fontColor)
                    .multilineTextAlignment(.center)
                    .padding([.leading, .trailing], 1)
                    .transition(.push(from: .leading))
                Spacer(minLength: 0)

                Text(weekDay.prefix(3).lowercased().localized)
                    .fonted(size: 11, weight: .regular, custom: theme.font)
                    .lineLimit(1)
                    .foregroundColor(theme.fontColor)
                    .padding(.vertical, 10)
                    .frame(maxWidth: .infinity)
                    .background(Color.black.opacity(0.4))
            }
            
            .accessibilityElement(children: .ignore)
            .accessibilityLabel(Text("\(weather.temperature.now.localizedTemp),") + Text(weather.description.shortDescription) + Text(", ") + Text("on".localized + weekDay))
        }
        .dynamicTypeSize(...DynamicTypeSize.large)
        .cornerRadius(15)
    }
}

#if DEBUG
struct MediumWidgetView5_Previews: PreviewProvider {
    static var previews: some View {
        
        WidgetsPreviewAllSizes(widgetSize: .systemMedium) {
            MediumWidgetView5()
        }
        
    }
}
#endif
