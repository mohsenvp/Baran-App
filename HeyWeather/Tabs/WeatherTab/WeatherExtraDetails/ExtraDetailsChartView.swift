//
//  ExtraDetailsChartView.swift
//  HeyWeather
//
//  Created by MYeganeh on 4/10/23.
//

import SwiftUI
import SwiftUICharts



struct ExtraDetailsChartView: View {
    
    var lineChartData: LineChartData
    var dataType: WeatherTabNavigationLink
    var unit: TouchUnit
    let chartStyle = LineChartStyle(
        infoBoxPlacement    : .floating,
        infoBoxContentAlignment: .horizontal,
        infoBoxBackgroundColour: .init(.systemBackground).opacity(0.8),
        infoBoxBorderColour: .init(.label),
        infoBoxBorderStyle: StrokeStyle(lineWidth: 1),
        xAxisLabelPosition  : .bottom,
        xAxisLabelColour    : .init(.secondaryLabel),
        yAxisLabelColour: .init(.secondaryLabel),
        yAxisNumberOfLabels: 4,
        globalAnimation     : .easeOut(duration: 1)
    )
    
    var numberFormatter: NumberFormatter
    
    init(chartData: [ExtraDetailChartData], dataType: WeatherTabNavigationLink, unit: TouchUnit) {
        self.dataType = dataType
        self.unit = unit
        var dataPoints : [LineChartDataPoint] = []
        for item in chartData {
            dataPoints.append(LineChartDataPoint(
                value: item.value,
                xAxisLabel: item.xAxisLabel,
                pointColour: PointColour(
                    border: Constants.accentColor,
                    fill: Constants.accentColor
                )
            )
            )
        }
        let dataset = LineDataSet(
            dataPoints: dataPoints,
            pointStyle: PointStyle(
                pointSize: 12, pointType: .filled
            ),
            style: LineStyle(
                lineColour: ColourStyle(
                    colour: Constants.accentColor.opacity(0.5)
                ),
                lineType: .line
            )
        )
        lineChartData = LineChartData(dataSets: dataset, chartStyle: chartStyle)
        
        numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        numberFormatter.maximumFractionDigits = 2
        numberFormatter.locale = Locale(identifier: LocalizeHelper.shared.currentLanguage.rawValue)
        numberFormatter.locale = .init(identifier: LocalizeHelper.shared.currentLanguage.rawValue)
    }
    
    var body: some View {
        LineChart(chartData: lineChartData)
            .pointMarkers(chartData: lineChartData)
            .touchOverlay(chartData: lineChartData, unit: unit)
            .floatingInfoBox(chartData: lineChartData)
            .xAxisLabels(chartData: lineChartData)
            .yAxisLabels(chartData: lineChartData, formatter: numberFormatter)
            .id(lineChartData.id)
            .frame(height: 140)
            .padding(EdgeInsets(top: 14, leading: 16, bottom: 10, trailing: 30))
            .dynamicTypeSize(...DynamicTypeSize.large)
            .environment(\.layoutDirection, .leftToRight)

        
    }
}
