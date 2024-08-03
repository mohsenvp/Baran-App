//
//  HourlyTabView.swift
//  HeyWeather
//
//  Created by Mohammad Yeganeh on 8/7/23.
//

import SwiftUI
import Charts


struct HourlyTabView: View {
    
    @ObservedObject var viewModel: WatchViewModel
    @Namespace var animation
    
    
    var body: some View {
        VStack(spacing: 0){
            if viewModel.dataMode == .weather {
                
                
                CurrentCompactView(viewModel: viewModel)
                
                Spacer(minLength: 0)
                
                HStack {
                    ForEach(viewModel.weatherData.hourlyForecast.prefix(4)) { weather in
                        HourlyCell(weather: weather, viewModel: viewModel)
                    }
                }
                .padding()
                .background(.thinMaterial)
                .cornerRadius(Constants.weatherTabRadius)
                .padding(.horizontal)
                .colorScheme(viewModel.textColor == .black ? .light : .dark)
                .matchedGeometryEffect(id: "bg", in: animation)
                
            } else {
                
                
                CurrentCompactView(viewModel: viewModel)
                
                Rectangle()
                    .fill(viewModel.textColor.opacity(0.1))
                    .frame(height: 0.5)
                    .frame(maxWidth: .infinity)
                    .padding(.horizontal, 20)
                    .padding(.vertical, 4)
                
                
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
                
                Spacer(minLength: 4)
                
                
                let chartData = viewModel.getChartData(hourly: true)
                Group {
                    if viewModel.dataMode == .windSpeed {
                        HStack {
                            ForEach(0..<chartData.count, id: \.self) { i in
                                WindCell(data: chartData[i], isHourly: true)
                                if i != chartData.count - 1 {
                                    VerticalDivider(color: viewModel.textColor)
                                }
                            }
                        }
                    }else if viewModel.dataMode == .visibility {
                        HStack {
                            ForEach(0..<chartData.count, id: \.self) { i in
                                VisibilityCell(data: chartData[i], isHourly: true)
                                if i != chartData.count - 1 {
                                    VerticalDivider(color: viewModel.textColor)
                                }
                            }
                        }
                    }else if viewModel.dataMode == .dewPoint {
                        HStack {
                            ForEach(0..<chartData.count, id: \.self) { i in
                                DewPointCell(data: chartData[i], isHourly: true)
                                if i != chartData.count - 1 {
                                    VerticalDivider(color: viewModel.textColor)
                                }
                            }
                        }
                    }else if viewModel.dataMode == .precipitation {
                        HStack {
                            ForEach(0..<chartData.count, id: \.self) { i in
                                PrecipitationCell(data: chartData[i], isHourly: true)
                                if i != chartData.count - 1 {
                                    VerticalDivider(color: viewModel.textColor)
                                }
                            }
                        }
                    }else {
                        WatchChartView(
                            selectedMode: viewModel.dataMode,
                            chartData: viewModel.getChartData(hourly: true),
                            isHourly: true,
                            textColor: viewModel.textColor
                        )
                        
                    }
                    
                }
                .padding(10)
                .background(.thinMaterial)
                .cornerRadius(Constants.weatherTabRadius)
                .colorScheme(viewModel.textColor == .black ? .light : .dark)
                .padding(.horizontal)
                .frame(height: 100)
                .ignoresSafeArea()
                
            }
            
            
            
            
        }
    }
    
    private struct HourlyCell: View {
        var weather: Weather
        @ObservedObject var viewModel: WatchViewModel
        
        var body: some View {
            VStack {
                Group {
                    if weather.localDate.isRealNow(timezone: weather.timezone) {
                        Text("Now", tableName: "General")
                    }else{
                        Text(weather.localDate.atHour)
                    }
                }
                .foregroundColor(viewModel.textColor)
                .fonted(.body, weight: .light)
                
                ConditionIcon(iconSet: Constants.defaultIconSet, condition: weather.condition)
                    .frame(width: 22, height: 22)
                    .fixedSize()
                    .padding()
                
                Text(weather.temperature.now?.localizedTemp ?? "")
                    .foregroundColor(viewModel.textColor)
                    .fonted(.subheadline, weight: .medium)
                    .lineLimit(1)
            }
        }
    }
}

#Preview {
    HourlyTabView(viewModel: .init())
}
