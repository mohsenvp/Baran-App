//
//  MediumWidgetView8.swift
//  HeyWeather
//
//  Created by RezaRg on 9/23/20.
//

import SwiftUI
import  WidgetKit

struct MediumWidgetView8: View {
    var weather : WeatherData = WeatherData()
    var theme : WidgetTheme = WidgetTheme()
//    let lang = Locale.current.language.languageCode?.identifier ?? "en"
    var id = 0
    var isPreviewForAppWidgetTab: Bool = false

    var body: some View {
        let daily = weather.dailyForecast
        
        let chartSettings = ChartSettings(showXValues: true, showYValues: true, lineWidth: 3, lineColor: theme.fontColor, chartBackground: Color.clear, lineBackground: LinearGradient(gradient: Gradient(colors: [.clear]), startPoint: .top, endPoint: .bottom))
        
        
        let  chartData = getChartData(daily: daily)
        
        GeometryReader { geometry in
            let height = geometry.size.height - (isPreviewForAppWidgetTab || Constants.systemVersionIn4Digit < 17.0 ? 32 : 0)
            VStack(spacing: 0) {
                
                TopPartOfMediumWidgetView8(weather: weather, theme: theme, id : id)
                    .frame(height: height * 0.5)
                    .frame(maxWidth : .infinity)
                
                Spacer(minLength: 0)
                
                SmoothChart(chartData: chartData, chartSettings: chartSettings)
                    .frame(height: height * 0.5)
                    .frame(maxWidth : .infinity)
                    .accessibilitySortPriority(-1)
                
            }
            .dynamicTypeSize(...DynamicTypeSize.large)
            .accessibilityElement(children: .combine)
            .widgetBackground(theme.getBackground(), isPreviewForAppWidgetTab)
        }
    }
    
    
    func getChartData(daily : [Weather]) -> [ChartData] {
        var chartData = [ChartData]()
        
        (0..<daily[0...5].count).forEach { i in
            let day = daily[i]
            let dayString = day.date.weekday
            chartData.append(ChartData(key: daily[i].date.veryShortWeekday, value: Double(day.temperature.now.localizedTempValue), accessibleKey: dayString))
        }
        return chartData
        
    }
}

struct TopPartOfMediumWidgetView8 : View {
    var weather : WeatherData = WeatherData()
    var theme : WidgetTheme = WidgetTheme()
    var id = 0
    
    var body: some View {
        let todayWeather = weather.today
        
        HStack{
            VStack(spacing : 0) {
                Text(todayWeather.temperature.now.localizedTemp)
                    .fonted(size: 34, weight: .regular, custom: theme.font)
                    .contentTransition(.numericText())
                
                Color.white
                    .frame(width: 60, height: 1)
                
                Text(todayWeather.condition.description)
                    .fonted(size: 17, weight: .regular, custom: theme.font)
                    .transition(.push(from: .leading))
                    .padding(.top, 2)
                
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
                LocationView(theme: theme, weather: weather, id: id)
                    .accessibilitySortPriority(-2)
            }
            
        }
    }
}

#if DEBUG
struct MediumWidgetView8_Previews: PreviewProvider {
    static var previews: some View {
        MediumWidgetView8().previewContext(WidgetPreviewContext(family: .systemMedium))
    }
}
#endif
