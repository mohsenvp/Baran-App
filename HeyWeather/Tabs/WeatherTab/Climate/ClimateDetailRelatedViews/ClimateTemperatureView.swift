//
//  TemperatureChart.swift
//  HeyWeather
//
//  Created by Mohammad Yeganeh on 6/24/23.
//

import SwiftUI
import SwiftUICharts


struct ClimateTemperatureView: View {
    
    @AppStorage(Constants.tempUnitString, store: Constants.groupUserDefaults) var unit: String = Constants.tempUnitString
    @ObservedObject var viewModel: ClimateDetailViewModel
    @State var lineChartData: MultiLineChartData = .init(dataSets: .init(dataSets: []))
    let chartStyle = LineChartStyle(
        xAxisLabelPosition  : .bottom,
        xAxisLabelColour    : .init(.secondaryLabel),
        xAxisBorderColour: .init(.clear),
        yAxisGridStyle: .init(numberOfLines: 6),
        yAxisLabelColour: .init(.secondaryLabel),
        yAxisNumberOfLabels: 6,
        globalAnimation     : .linear(duration: 0)
    )
  
    func initChart(){
        var minDataPoints : [LineChartDataPoint] = []
        for item in viewModel.minTempChartData {
            minDataPoints.append(LineChartDataPoint(
                value: item.value,
                xAxisLabel: item.key,
                pointColour: PointColour(
                    border: .init(.systemBackground),
                    fill: Constants.minTempColor
                )
            )
            )
        }
        let minDataSet = LineDataSet(
            dataPoints: minDataPoints,
            legendTitle: String(localized: "Minimum", table: "Climate"),
            pointStyle: PointStyle(
                pointSize: 10, pointType: .filledOutLine, pointShape: .circle
            ),
            style: LineStyle(
                lineColour: ColourStyle(
                    colour: Constants.minTempColor
                ),
                lineType: .line
            )
        )
        
        
        var maxDataPoints : [LineChartDataPoint] = []
        for item in viewModel.maxTempChartData {
            maxDataPoints.append(LineChartDataPoint(
                value: item.value,
                xAxisLabel: item.key,
                pointColour: PointColour(
                    border: .init(.systemBackground),
                    fill: Constants.maxTempColor
                )
            )
            )
        }
        let maxDataSet = LineDataSet(
            dataPoints: maxDataPoints,
            legendTitle: String(localized: "Maximum", table: "Climate"),
            pointStyle: PointStyle(
                pointSize: 10, pointType: .filledOutLine, pointShape: .circle
            ),
            style: LineStyle(
                lineColour: ColourStyle(
                    colour: Constants.maxTempColor
                ),
                lineType: .line
            )
        )
        
        
        
        
        var midDataPoints : [LineChartDataPoint] = []
        for item in viewModel.meanTempChartData {
            midDataPoints.append(LineChartDataPoint(
                value: item.value,
                xAxisLabel: item.key,
                pointColour: PointColour(
                    border: .init(.systemBackground),
                    fill: Constants.midTempColor
                )
            )
            )
        }
        let midDataSet = LineDataSet(
            dataPoints: midDataPoints,
            legendTitle: String(localized: "Median", table: "Climate"),
            pointStyle: PointStyle(
                pointSize: 10, pointType: .filledOutLine, pointShape: .circle
            ),
            style: LineStyle(
                lineColour: ColourStyle(
                    colour: Constants.midTempColor
                ),
                lineType: .line
            )
        )
        lineChartData = MultiLineChartData(dataSets: MultiLineDataSet(dataSets: [minDataSet, midDataSet, maxDataSet]), chartStyle: chartStyle)
        
    }
    

    
    var body: some View {
        VStack {
            HStack {
                Text("Temperature", tableName: "SettingsTab")
                    .foregroundColor(.secondary)
                    .fonted(.title3, weight: .semibold)
                Text("(\(unit))")
                    .foregroundColor(.secondary)
                    .fonted(.title3, weight: .regular)
                Spacer()
            }
            Spacer(minLength: 22)
            MultiLineChart(chartData: lineChartData)
                .yAxisGrid(chartData: lineChartData)
                .pointMarkers(chartData: lineChartData)
                .xAxisLabels(chartData: lineChartData)
                .yAxisLabels(chartData: lineChartData)
                .legends(chartData: lineChartData, columns: [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())], iconWidth: 20, topPadding: 12)
                .id(lineChartData.id)
        }
        .frame(height: 200)
        .onChange(of: viewModel.isRedacted) { _ in
            DispatchQueue.main.async {
                initChart()
            }
        }
    }
}


