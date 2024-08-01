//
//  ClimateDaylightView.swift
//  HeyWeather
//
//  Created by Mohammad Yeganeh on 6/24/23.
//

import SwiftUI
import SwiftUICharts


struct ClimateDaylightView: View {
    
    @ObservedObject var viewModel: ClimateDetailViewModel
    @State var barChartData: BarChartData = .init(dataSets: .init(dataPoints: []))
    let chartStyle = BarChartStyle(
        xAxisLabelPosition  : .bottom,
        xAxisLabelColour    : .init(.secondaryLabel),
        yAxisGridStyle: .init(numberOfLines: 6),
        yAxisLabelColour: .init(.secondaryLabel),
        yAxisNumberOfLabels: 6,
        globalAnimation     : .linear(duration: 0)
    )
    
    let barStyle = BarStyle(barWidth: 0.4,
                            cornerRadius: CornerRadius(top: 50, bottom: 50),
                            colourFrom: .dataPoints,
                            colour: ColourStyle(colour: .blue))
    
    func initChart() {
        var dataPoints : [BarChartDataPoint] = []
        for item in viewModel.daylightChartData {
            dataPoints.append(BarChartDataPoint(
                value: item.value,
                xAxisLabel: item.key,
                colour: .init(colours: [.init(hex: "FA9E42").opacity(0.8), .init(hex: "FFD04D").opacity(0.8)], startPoint: .top, endPoint: .bottom)
            )
            )
        }
        let dataSet = BarDataSet(
            dataPoints: dataPoints
        )
        
        barChartData = BarChartData(dataSets: dataSet, barStyle: barStyle, chartStyle: chartStyle)
        
    }
    
    var body: some View {
        VStack {
            HStack {
                Text("Daylight", tableName: "Climate")
                    .foregroundColor(.secondary)
                    .fonted(.title3, weight: .semibold)
                Text("hours", tableName: "General")
                    .foregroundColor(.secondary)
                    .fonted(.title3, weight: .regular)
                Spacer()
            }
            Spacer(minLength: 22)
            BarChart(chartData: barChartData)
                .yAxisGrid(chartData: barChartData)
                .xAxisLabels(chartData: barChartData)
                .yAxisLabels(chartData: barChartData)
                .id(barChartData.id)
        }
        .frame(height: 200)
        .onChange(of: viewModel.isRedacted) { _ in
            DispatchQueue.main.async {
                initChart()
            }
        }
    }
}

