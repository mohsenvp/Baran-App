//
//  SmallWidgetView5.swift
//  HeyWeather
//
//  Created by RezaRg on 9/18/20.
//

import SwiftUI
import WidgetKit

struct SmallWidgetView5: View {

    var weather : WeatherData = WeatherData()
    var theme : WidgetTheme = WidgetTheme()
    var id = 0
    var isPreviewForAppWidgetTab: Bool = false

    var body: some View {
        let todayWeather = weather.today
        let hourly = weather.hourlyForecast
        
        let chartSettings = ChartSettings(showXValues: true, showYValues: true, lineWidth: 3, lineColor: theme.fontColor, chartBackground: Color.clear, lineBackground: LinearGradient(gradient: Gradient(colors: [Color(#colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 0)), Color(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 0))]), startPoint: .top, endPoint: .bottom))
        
        let  chartData = getChartData(hourly: hourly)
        
        GeometryReader { geometry in
            let height = geometry.size.height - (isPreviewForAppWidgetTab || Constants.systemVersionIn4Digit < 17.0 ? 32 : 0)
            VStack(spacing: 0) {
                VStack (alignment : .leading, spacing : 2) {
                    
                    HStack {
                        ConditionIcon(iconSet: theme.iconSet, condition:todayWeather.condition)
                            .frame(width: 18, height: 18)
                            .accessibilityHidden(true)
                        
                        Text(todayWeather.temperature.now.localizedTemp)
                            .foregroundColor(theme.fontColor)
                            .fonted(size: 22, weight: .semibold, custom: theme.font)
                            .contentTransition(.numericText())

                        Spacer()
                    }
                    
                    Text(todayWeather.description.shortDescription)
                        .foregroundColor(theme.fontColor)
                        .fonted(size: 12, weight: .regular, custom: theme.font)
                        .transition(.push(from: .leading))

                    
                }
                .frame(height: height * 0.3)
                .frame(maxWidth : .infinity)
                
                
                HStack{
                    SmoothChart(chartData: chartData, chartSettings: chartSettings)
                }
                .frame(height: height * 0.5)
                .frame(maxWidth : .infinity)
                .padding(.vertical, 10)
                
                
                LocationView(theme: theme, weather: weather, id: id)
                    .frame(maxWidth : .infinity, alignment : .leading)
                
            }
            .dynamicTypeSize(...DynamicTypeSize.large)
            .widgetBackground(theme.getBackground(), isPreviewForAppWidgetTab)
            .accessibilityElement(children: .combine)
        }
    }
    
    func getChartData(hourly : [Weather]) -> [ChartData] {
        var chartData = [ChartData]()
        
        (0..<hourly[1...4].count).forEach { i in
            let hour = hourly[i]
            chartData.append(ChartData(key: String(hour.date.atHour), value: Double(hour.temperature.now.localizedTempValue)))
        }
        return chartData
        
    }
}

#if DEBUG
struct SmallWidgetView5_Previews: PreviewProvider {
    static var previews: some View {
        
        SmallWidgetView5().previewContext(WidgetPreviewContext(family: .systemSmall))
        
    }
}
#endif
