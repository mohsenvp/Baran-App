//
//  MediumWidgetView7.swift
//  HeyWeather
//
//  Created by RezaRg on 9/23/20.
//

import SwiftUI
import WidgetKit

struct MediumWidgetView7: View {
    var weather : WeatherData = WeatherData()
    var theme : WidgetTheme = WidgetTheme()
    var id = 0
    var isPreviewForAppWidgetTab: Bool = false

    var body: some View {
        let todayWeather = weather.today
        
        GeometryReader { geometry in
            let width = geometry.size.width - (isPreviewForAppWidgetTab || Constants.systemVersionIn4Digit < 17.0 ? 32 : 0)
            
            HStack (spacing : 0) {
                VStack {
                    VStack (alignment : .leading, spacing : 2) {
                        
                        ConditionIcon(iconSet: theme.iconSet, condition:todayWeather.condition)
                            .frame(width: 36, height: 36, alignment: .center)
                            .accessibilityHidden(true)
                        
                        Text(todayWeather.temperature.now.localizedTemp)
                            .foregroundColor(theme.fontColor)
                            .fonted(size: 22, weight: .bold, custom: theme.font)
                            .contentTransition(.numericText())
                        
                        Text(todayWeather.condition.description)
                            .foregroundColor(theme.fontColor.opacity(0.8))
                            .fonted(size: 16, weight: .regular, custom: theme.font)
                            .lineLimit(1)
                            .transition(.push(from: .leading))
                        
                    }
                    Spacer()
                    
                    LocationView(theme: theme, weather: weather, id: id)
                        .accessibilitySortPriority(-3)
                }
                
                Spacer(minLength: 0)
                
                BodyOfSmallWidgetView4(weather: weather, theme: theme)
                    .frame(width: width * 0.35)
                    .accessibilitySortPriority(-1)
                
                Spacer(minLength: 0)

                VStack() {
                    let none = Constants.none
                    ConditionView3(icon: Constants.SystemIcons.wind, color: theme.fontColor, title: Strings.WeatherDetails.getWeatherDetailsTitle(for: .wind), value: todayWeather.details.windSpeed?.localizedWindSpeed ?? none, theme: theme, width: 48)
                        .frame(maxWidth : .infinity, alignment: .leading)
                    Spacer(minLength: 0)
                    ConditionView3(icon: Constants.SystemIcons.sparkles, color: theme.fontColor, title: Strings.WeatherDetails.getWeatherDetailsTitle(for: .humidity), value: todayWeather.details.humidity?.description ?? none, valueUnit: "%",theme: theme, width: 48)
                        .frame(maxWidth : .infinity, alignment: .leading)
                    Spacer(minLength: 0)
                    ConditionView3(icon: Constants.SystemIcons.uCircle, color: theme.fontColor, title: Strings.WeatherDetails.getWeatherDetailsTitle(for: .uvIndex), value: todayWeather.details.uvIndex?.localizedNumber() ?? none, theme: theme, width: 48)
                        .frame(maxWidth : .infinity, alignment: .leading)
                }
                .frame(width: width * 0.25)
                .accessibilitySortPriority(-2)
                
                
            }
            .dynamicTypeSize(...DynamicTypeSize.large)
            .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
            .widgetBackground(theme.getBackground(), isPreviewForAppWidgetTab)
            .accessibilityElement(children: .combine)
        }
    }
}

#if DEBUG
struct MediumWidgetView7_Previews: PreviewProvider {
    static var previews: some View {
        MediumWidgetView7().previewContext(WidgetPreviewContext(family: .systemMedium))
    }
}
#endif
