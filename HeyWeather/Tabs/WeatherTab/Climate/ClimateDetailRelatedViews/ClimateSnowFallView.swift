//
//  ClimateSnowFallView.swift
//  HeyWeather
//
//  Created by Mohammad Yeganeh on 6/24/23.
//

import SwiftUI
import SwiftUICharts


struct ClimateSnowFallView: View {
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
        numberFormatter.roundingMode = .ceiling

    }
    
    let chartStyle = BarChartStyle(
        xAxisLabelPosition  : .bottom,
        xAxisLabelColour    : .init(.secondaryLabel),
        yAxisGridStyle: .init(numberOfLines: 6),
        yAxisLabelColour: .init(.secondaryLabel),
        yAxisNumberOfLabels: 6,
        globalAnimation: .linear(duration: 0)
    )
    
    let barStyle = BarStyle(barWidth: 0.4,
                            cornerRadius: CornerRadius(top: 50, bottom: 50),
                            colourFrom: .dataPoints,
                            colour: ColourStyle(colour: .blue))
    
    func initChart() {
        var dataPoints : [BarChartDataPoint] = []
        for item in viewModel.snowFallChartData {
            dataPoints.append(BarChartDataPoint(
                value: item.value,
                xAxisLabel: item.key,
                colour: .init(colours: [.init(hex: "6B38FC").opacity(0.8), .init(hex: "B9A0FF").opacity(0.8)], startPoint: .top, endPoint: .bottom)
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
                Text("Snow Fall", tableName: "Climate")
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
                .yAxisLabels(chartData: barChartData, formatter: numberFormatter)
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



