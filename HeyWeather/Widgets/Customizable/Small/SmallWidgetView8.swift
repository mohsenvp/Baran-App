//
//  SmallWidgetView8.swift
//  HeyWeather
//
//  Created by RezaRg on 9/21/20.
//

import SwiftUI
import WidgetKit

struct SmallWidgetView8: View {

    var weather : WeatherData = WeatherData()
    var theme : WidgetTheme = WidgetTheme()
    var id = 0
    var isPreviewForAppWidgetTab: Bool = false

    var body: some View {
        let todayWeather = weather.today
        let daily = weather.dailyForecast
        
        
        let chartSettings = ChartSettings(showXValues: true, showYValues: true, lineWidth: 3, lineColor: theme.fontColor, chartBackground: Color.clear, lineBackground: LinearGradient(gradient: Gradient(colors: [Color(#colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 0)), Color(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 0))]), startPoint: .top, endPoint: .bottom))
        
        let  chartData = getChartData(daily: daily)
        
        GeometryReader { geometry in
            let height = geometry.size.height - (isPreviewForAppWidgetTab || Constants.systemVersionIn4Digit < 17.0 ? 32 : 0)
            VStack(spacing: 0) {
                VStack (alignment : .leading, spacing : 0) {
                    
                    HStack {
                        ConditionIcon(iconSet: theme.iconSet, condition:todayWeather.condition)
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 18, height: 18)
                            .accessibilityHidden(true)
                        
                        Text(todayWeather.temperature.now.localizedTemp)
                            .foregroundColor(theme.fontColor)
                            .fonted(size: 20, weight: .regular, custom: theme.font)
                            .contentTransition(.numericText())

                        Spacer()
                    }
                    
                    Text(todayWeather.description.shortDescription)
                        .foregroundColor(theme.fontColor)
                        .fonted(size: 16, weight: .regular, custom: theme.font)
                        .transition(.push(from: .leading))
                    Spacer()
                    
                }
                .frame(maxWidth : .infinity, maxHeight: height * 0.3)
                
                
                HStack{
                    SmoothChart(chartData: chartData, chartSettings: chartSettings)
                }
                .frame(height: height * 0.55)
                .frame(maxWidth : .infinity)
                
                Spacer(minLength: 0)
                
                LocationView(theme: theme, weather: weather, id: id)
                    .frame(height: height * 0.1)
                    .frame(maxWidth : .infinity, alignment : .leading)
                
                
            }
            .dynamicTypeSize(...DynamicTypeSize.large)
            .widgetBackground(theme.getBackground(), isPreviewForAppWidgetTab)
            .accessibilityElement(children: .combine)
        }
    }
    
    func getChartData(daily : [Weather]) -> [ChartData] {
        var chartData = [ChartData]()
        
        (0..<daily[1...4].count).forEach { i in
            let day = daily[i]
            let dayString = day.date.weekday.lowercased().localized
            chartData.append(ChartData(key: daily[i].date.weekday.prefix(3).lowercased().localized, value: Double(day.temperature.now.localizedTempValue), accessibleKey: dayString))
        }
        return chartData
        
    }
}

#if DEBUG
struct SmallWidgetView8_Previews: PreviewProvider {
    static var previews: some View {
        ForEach(["iPhone SE", "iPhone 11 Pro Max"], id: \.self) { deviceName in
            SmallWidgetView8()
                .previewContext(WidgetPreviewContext(family: .systemSmall))
                .previewDisplayName(deviceName)
        }
    }
}
#endif
