//
//  LargeWidgetView5.swift
//  WeatherApp
//
//  Created by RezaRg on 9/5/20.
//

import SwiftUI
import WidgetKit

struct LargeWidgetView5: View {
    var weather : WeatherData = WeatherData()
    var theme : WidgetTheme = WidgetTheme()
    var id = 0
    var isPreviewForAppWidgetTab: Bool = false

    func getChartData(daily : [Weather]) -> [ChartData] {
        var chartData = [ChartData]()
        (0..<daily[0...5].count).forEach { i in
            let day = daily[i]
            chartData.append(ChartData(key: day.date.weekday.prefix(3).lowercased().localized, value: Double(day.temperature.now.localizedTempValue), accessibleKey: day.date.weekday.lowercased().localized))
        }
        return chartData
        
    }
    
    var body :some View {
        let todayWeather = weather.today
        let daily = weather.dailyForecast
        
        let chartSettings = ChartSettings(showXValues: true, showYValues: true, lineWidth: 3, lineColor: theme.fontColor, chartBackground: Color.clear, lineBackground: LinearGradient(gradient: Gradient(colors: [.clear]), startPoint: .top, endPoint: .bottom))
        
        
        let  chartData = getChartData(daily: daily)
        
        
        GeometryReader { geometry in
            let width = geometry.size.width - (isPreviewForAppWidgetTab || Constants.systemVersionIn4Digit < 17.0 ? 32 : 0)
            
            let height = geometry.size.height - (isPreviewForAppWidgetTab || Constants.systemVersionIn4Digit < 17.0 ? 32 : 0)
            
            VStack(spacing: 0) {
                
                HStack{
                    
                    
                    VStack(alignment : .center, spacing : 0) {
                        
                        
                        ConditionIcon(iconSet: theme.iconSet, condition: todayWeather.condition)
                            .frame(width: 150, height: 70)
                            .padding(0)
                            .accessibilityHidden(true)
                        
                        Spacer()
                        
                        Group {
                            Text(todayWeather.temperature.now.localizedTemp)
                                .fonted(size: 22, weight: .bold, custom: theme.font)
                                .contentTransition(.numericText())

                            Text(todayWeather.description.shortDescription)
                                .fonted(size: 16, weight: .regular, custom: theme.font)
                                .transition(.push(from: .leading))
                        }.fonted(size: 17, weight: .regular, custom: theme.font)
                        .lineLimit(1)
                        .foregroundColor(theme.fontColor)
                        
                        
                        Spacer()
                        
                        LocationView(theme: theme, weather: weather, id: id)
                            .accessibilitySortPriority(-3)
                        
                        
                    }
                    .frame(width: width / 3)
                    .frame(maxHeight : (height / 2) - 20)
                    
                    Spacer()
                    
                    VStack{
                        ForEach(weather.hourlyForecast[0...3]) { daily in
                            Spacer()
                            HStack(spacing : 20) {
                                Text(daily.date.atHour)
                                    .fonted(size: 12, weight: .regular, custom: theme.font)
                                    .foregroundColor(theme.fontColor)
                                    .contentTransition(.numericText())
                                ConditionIcon(iconSet: theme.iconSet, condition: daily.condition)
                                    .frame(width: 20, height: 20)
                                Text(daily.temperature.now.localizedTemp)
                                    .fonted(size: 16, weight: .regular, custom: theme.font)
                                    .foregroundColor(theme.fontColor)
                                    .contentTransition(.numericText())
                            }.padding(.horizontal)
                            .accessibilityElement(children: .ignore)
                            .accessibilityLabel(Text("\(daily.temperature.now.localizedTemp), ") + Text(daily.description.shortDescription) + Text(", at".localized + daily.date.atHour))
                        }
                        Spacer()
                    }
                    .frame(width: width / 2.1)
                    .frame(maxHeight : (height / 2) - 20)
                    .background(Color.white.opacity(0.3))
                    .cornerRadius(15)
                    .accessibilitySortPriority(-1)
                    
                    
                }
                .padding(10)
                .frame(height: height / 2)
                .frame(maxWidth : .infinity)
                
                HStack{
                    SmoothChart(chartData: chartData, chartSettings: chartSettings)
                }
                .frame(height: height / 2)
                .frame(maxWidth : .infinity)
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
struct LargeWidgetView5_Previews: PreviewProvider {
    static var previews: some View {
        LargeWidgetView5().previewContext(WidgetPreviewContext(family: .systemLarge))
    }
}
#endif
