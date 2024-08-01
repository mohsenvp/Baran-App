//
//  LargeWidgetView1.swift
//  NeonWeather
//
//  Created by RezaRg on 7/18/20.
//

import SwiftUI
import WidgetKit

struct LargeWidgetView1: View {
    var weather : WeatherData = WeatherData()
    var theme : WidgetTheme = WidgetTheme()
    var id = 0
    var isPreviewForAppWidgetTab: Bool = false

    var body: some View {
        let todayWeather = weather.today
        let hourlyWeather = weather.hourlyForecast
        let dailyWeather = weather.dailyForecast
        
        GeometryReader { geometry in
            let width = geometry.size.width - (isPreviewForAppWidgetTab || Constants.systemVersionIn4Digit < 17.0 ? 32 : 0)
            
            let height = geometry.size.height - (isPreviewForAppWidgetTab || Constants.systemVersionIn4Digit < 17.0 ? 32 : 0)
            
            HStack(spacing: 0) {
                
                VStack(spacing : 0) {
                    
                    HStack(spacing : 12) {
                        VStack(spacing: 4) {
                            ConditionIcon(iconSet: theme.iconSet, condition: todayWeather.condition)
                                .frame(width: 88, height: 88, alignment: .leading)
                                .accessibilityHidden(true)
                            
                            LocationView(theme: theme, weather: weather, id: id, isVertical: true)
                                .accessibilitySortPriority(-5)
                        }
                        
                        VStack(spacing: 0) {
                            Text(todayWeather.condition.description)
                                .foregroundColor(theme.fontColor)
                                .fonted(size: 16, weight: .bold, custom: theme.font)
                                .lineLimit(1)
                            Text(todayWeather.temperature.now.localizedTemp)
                                .fonted(size: 34, weight: .regular, custom: theme.font)
                                .foregroundColor(theme.fontColor)
                                .contentTransition(.numericText())
                                .lineLimit(1)
                            
                            MaxMinView(maxTemp: todayWeather.temperature.max.localizedTemp,minTemp: todayWeather.temperature.min.localizedTemp, fontColor: theme.fontColor, font: theme.font)
                            
                            
                        }
                        .accessibilityElement(children: .combine)
                        
                    }
                    .frame(maxWidth: .infinity)
                    
                    Spacer(minLength: 0)

                    
                    HStack(spacing: 0) {
                        
                        ForEach(hourlyWeather[0...4]) { hourly in
                            Spacer()
                            NextHourVertical(weather: hourly, theme: theme)
                        }
                        Spacer()
                        
                    }
                    .frame(height: (height * 0.25) - 12)
                    .frame(maxWidth: .infinity)
                    .background(Color.white.opacity(0.3))
                    .cornerRadius(15)
                    .accessibilitySortPriority(-3)
                    
                    Spacer(minLength: 12)
                    
                    let weatherDetailsStrings = Strings.WeatherDetails.self
                    let none = Constants.none
                    
                    
                    VStack {
                      
                        HStack {
                            ConditionView3(icon: Constants.SystemIcons.wind, color: Color.white, title: Strings.WeatherDetails.getWeatherDetailsTitle(for: .wind), value: todayWeather.details.windSpeed?.localizedWindSpeed ?? none, theme: theme, width: 48)
                                .frame(width: width * 0.6 / 2)
                            Spacer(minLength: 0)
                            ConditionView3(icon: Constants.SystemIcons.sparkles, color: Color.white, title: Strings.WeatherDetails.getWeatherDetailsTitle(for: .humidity), value: todayWeather.details.humidity?.description ?? none, valueUnit: "%",theme: theme, width: 48)
                                .frame(width: width * 0.6 / 2)
                        }
                        HStack {
                            ConditionView3(icon: Constants.SystemIcons.uCircle, color: Color.white, title: Strings.WeatherDetails.getWeatherDetailsTitle(for: .uvIndex), value: todayWeather.details.uvIndex?.localizedNumber() ?? none, theme: theme, width: 48)
                                .frame(width: width * 0.6 / 2)
                            Spacer(minLength: 0)
                            ConditionView3(icon: Constants.SystemIcons.compressVertical, color: Color.white, title: Strings.WeatherDetails.getWeatherDetailsTitle(for: .pressure), value: todayWeather.details.pressure?.localizedPressure ?? none, theme: theme, width: 48)
                                .frame(width: width * 0.6 / 2)
                        }
                    }
                    .frame(height: (height * 0.35) - 20)
                    .frame(maxWidth: .infinity)
                    .cornerRadius(15)
                    .accessibilitySortPriority(-2)
                    
                    
                }
                
                Spacer(minLength: 12)
                
                VStack(alignment: .leading) {
                    ForEach(dailyWeather[0...3]) { daily in
                        Spacer(minLength: 0)
                        NextDayHorizontal(weather: daily, theme: theme, isVertical: true)
                    }
                    Spacer(minLength: 0)
                }
                .frame(width: width / 4)
                .frame(maxHeight: .infinity, alignment: .trailing)
                .padding(.horizontal, 5)
                .background(Color.black.opacity(0.3))
                .cornerRadius(15)
                .accessibilitySortPriority(-4)
                
            }
            .widgetBackground(theme.getBackground(), isPreviewForAppWidgetTab)
            .accessibilityElement(children: .combine)

        }

    }
    
    struct NextHourVertical: View { 
        var weather: Weather
        var theme : WidgetTheme = WidgetTheme()
        
        var body: some View {
            let fontColor : Color = theme.fontColor
            
            VStack(spacing:0){
                Text(weather.date.atHour)
                    .fonted(size: 13, weight: .regular, custom: theme.font)
                    .foregroundColor(fontColor)
                    .contentTransition(.numericText())
                
                ConditionIcon(iconSet: theme.iconSet, condition: weather.condition)
                    .frame(width: 18, height: 18, alignment: .leading)
                    .scaledToFit()
                    .padding([.top, .bottom], 4)
                    .accessibilityHidden(true)
                
                Text(weather.temperature.now.localizedTemp)
                    .fonted(size: 13, weight: .regular, custom: theme.font)
                    .foregroundColor(fontColor)
                    .contentTransition(.numericText())
            }
            .dynamicTypeSize(...DynamicTypeSize.large)
            .accessibilityElement(children: .ignore)
            .accessibilityLabel(Text(weather.temperature.now.localizedTemp + "," + weather.description.shortDescription) + Text("at") + Text(weather.date.atHour))
        }
    }
}

#if DEBUG
struct LargeWidgetView1_Previews: PreviewProvider {
    static var previews: some View {
        LargeWidgetView1()
            .previewContext(WidgetPreviewContext(family: .systemLarge))
    }
}
#endif
