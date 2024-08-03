//
//  RainFallChart.swift
//  HeyWeather
//
//  Created by Mohammad Yeganeh on 6/24/23.
//

import SwiftUI
import SwiftUICharts


struct ClimateRainFallView: View {
    @AppStorage(Constants.precipitationUnitString, store: Constants.groupUserDefaults) var unit: String = Constants.defaultPrecipitationUnit.rawValue

    @ObservedObject var viewModel: ClimateDetailViewModel

    @State var barChartData: BarChartData = .init(dataSets: .init(dataPoints: []))
    
    var numberFormatter: NumberFormatter
    
    init(viewModel: ClimateDetailViewModel){
        self.viewModel = viewModel
        numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        numberFormatter.maximumFractionDigits = 2
        numberFormatter.locale = Locale(identifier: LocalizeHelper.shared.currentLanguage.rawValue)
        numberFormatter.locale = .init(identifier: LocalizeHelper.shared.currentLanguage.rawValue)
        numberFormatter.roundingMode = .halfEven
    }
    
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
        for item in viewModel.rainFallChartData {
            dataPoints.append(BarChartDataPoint(
                value: item.value,
                xAxisLabel: item.key,
                colour: .init(colours: [.init(hex: "3D74E0").opacity(0.8), .init(hex: "1EAECE").opacity(0.8)], startPoint: .top, endPoint: .bottom)
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
                Text("Rain Fall", tableName: "Climate")
                    .foregroundColor(.secondary)
                    .fonted(.title3, weight: .semibold)
                Text("(\(PrecipitationUnit(rawValue: unit)?.amount ?? ""))")
                    .foregroundColor(.secondary)
                    .fonted(.title3, weight: .regular)
                Spacer()
            }
            Spacer(minLength: 22)
            BarChart(chartData: barChartData)
                .yAxisGrid(chartData: barChartData)
                .xAxisLabels(chartData: barChartData)
                .yAxisLabels(chartData: barChartData, specifier: "%.0f", formatter: numberFormatter)
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

