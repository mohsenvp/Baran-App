//
//  DailyTabView.swift
//  HeyWeather WatchOS
//
//  Created by Mohammad Yeganeh on 8/7/23.
//

import SwiftUI
import Charts

struct DailyTabView: View {
    
    @ObservedObject var viewModel: WatchViewModel
    
    var body: some View {
        VStack {
            if viewModel.dataMode == .weather {
                let minTempOfAll: Int = viewModel.weatherData.dailyForecast.compactMap({$0.temperature.min}).min() ?? 0
                let maxTempOfAll: Int = viewModel.weatherData.dailyForecast.compactMap({$0.temperature.max}).max() ?? 0
                let data = viewModel.weatherData.dailyForecast.prefix(4)
                ForEach(0..<data.count, id: \.self) { i in
                    DailyCell(viewModel: viewModel, weather: data[i], minTempOfAll: minTempOfAll, maxTempOfAll: maxTempOfAll)
                    if i != data.count - 1 {
                        Divider()
                            .foregroundColor(viewModel.textColor)
                            .padding(.horizontal).opacity(0.5)
                    }
                }
                
                
            } else {
               
                HStack {
                    
                
                    viewModel.dataMode.title
                        .fonted(size: 14, weight: .medium)
                        .foregroundColor(viewModel.textColor)
                        .lineLimit(1)
                        
                        
                    
                    Spacer(minLength: 2)
                    
                    
                    Text(viewModel.activeDetailValue)
                        .foregroundColor(viewModel.textColor)
                        .fonted(.title3, weight: .semibold)
                        .lineLimit(1)
                        .minimumScaleFactor(0.8)
                        .contentTransition(.numericText())
                        .animation(.spring(duration: 0.2), value: viewModel.activeDetailValue)
                }
                .padding(.horizontal, 20)
                
                Spacer()

                
                let chartData = viewModel.getChartData(hourly: false)
                Group {
                    if viewModel.dataMode == .windSpeed {
                        HStack {
                            ForEach(0..<chartData.count, id: \.self) { i in
                                WindCell(data: chartData[i], isHourly: false)
                                if i != chartData.count - 1 {
                                    VerticalDivider(color: viewModel.textColor)
                                }
                            }
                        }
                    }else if viewModel.dataMode == .visibility {
                        HStack {
                            ForEach(0..<chartData.count, id: \.self) { i in
                                VisibilityCell(data: chartData[i], isHourly: false)
                                if i != chartData.count - 1 {
                                    VerticalDivider(color: viewModel.textColor)
                                }
                            }
                        }
                    }else if viewModel.dataMode == .dewPoint {
                        HStack {
                            ForEach(0..<chartData.count, id: \.self) { i in
                                DewPointCell(data: chartData[i], isHourly: false)
                                if i != chartData.count - 1 {
                                    VerticalDivider(color: viewModel.textColor)
                                }
                            }
                        }
                    }else if viewModel.dataMode == .precipitation {
                        HStack {
                            ForEach(0..<chartData.count, id: \.self) { i in
                                PrecipitationCell(data: chartData[i], isHourly: false)
                                if i != chartData.count - 1 {
                                    VerticalDivider(color: viewModel.textColor)
                                }
                            }
                        }
                    }else {
                        WatchChartView(
                            selectedMode: viewModel.dataMode,
                            chartData: viewModel.getChartData(hourly: false),
                            isHourly: false,
                            textColor: viewModel.textColor
                        )
                            
                    }
                       
                }
                .padding(12)
                .padding(.top, 8)
                .background(.thinMaterial)
                .cornerRadius(Constants.weatherTabRadius)
                .colorScheme(viewModel.textColor == .black ? .light : .dark)
                .padding(.horizontal)
                
            }
        }
    }
    
    
    
    
    private struct DailyCell: View {
        @ObservedObject var viewModel: WatchViewModel
        var weather: Weather
        var minTempOfAll: Int
        var maxTempOfAll: Int
        var body: some View {
            ZStack {
                
                HStack {
                    Text(weather.date.shortWeekday)
                        .foregroundColor(viewModel.textColor)
                        .fonted(.caption2, weight: .medium)
                    
                    Spacer()
                    
                    ConditionIcon(iconSet: Constants.defaultIconSet, condition: weather.condition)
                        .foregroundColor(viewModel.textColor)
                        .frame(width: 20, height: 20)
                    
                }
                
                HStack(spacing: 4){
                    
                    Text(weather.temperature.min?.localizedTemp ?? "")
                        .fonted(size: 14, weight: .regular)
                        .foregroundColor(viewModel.textColor.opacity(0.8))
                    
                    TemperatureForecastBar(
                        minTempValue: weather.temperature.min,
                        maxTempValue: weather.temperature.max,
                        meanTempValue: nil,
                        minTempOfAll: minTempOfAll,
                        maxTempOfAll: maxTempOfAll,
                        width: 40,
                        dashColor: viewModel.textColor.opacity(0.6)
                    )
                    .frame(height: 30)
                    
                    Text(weather.temperature.max?.localizedTemp ?? "")
                        .fonted(size: 14, weight: .regular)
                        .foregroundColor(viewModel.textColor)
                    
                }
                
                
                //                Text("\(weather.temperature.max?.localizedTemp ?? "")↑  ↓\(weather.temperature.min?.localizedTemp ?? "")")
                //                    .foregroundColor(viewModel.textColor)
                //                    .fonted(size: 12, weight: .medium)
                
            }
            
            .padding(.horizontal, 16)
        }
    }
}


