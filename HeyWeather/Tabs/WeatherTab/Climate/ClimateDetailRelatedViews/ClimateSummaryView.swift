//
//  ClimateSummaryView.swift
//  HeyWeather
//
//  Created by Mohammad Yeganeh on 6/24/23.
//

import SwiftUI

struct ClimateSummaryView: View {
    
    var climateData: ClimateData
    
    @State var barStartPadding: CGFloat = 0
    @State var meanStartPadding: CGFloat = 0
    @State var barWidth: CGFloat = 0
    @State var selectedMonth: Int = 0
    
    @State var climate: Climate = .init()
    @State var minTempOfYear: Double = 0
    @State var maxTempOfYear: Double = 0

    @AppStorage(Constants.precipitationUnitString, store: Constants.groupUserDefaults) var precipitationUnit: String = Constants.defaultPrecipitationUnit.rawValue

    var monthSymbols: [String] {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: LocalizeHelper.shared.currentLanguage.rawValue)
        return formatter.shortMonthSymbols
    }
    var body: some View {
        VStack(alignment: .leading, spacing: 14){
            
            HStack {
                Text("Climate Summary", tableName: "Climate")
                    .foregroundColor(.secondary)
                    .fonted(.title3, weight: .semibold)
                
                Spacer()
                
                Picker(monthSymbols[selectedMonth], selection: $selectedMonth) {
                    ForEach(0..<12, id: \.self) { index in
                        Text(monthSymbols[index])
                    }
                }
                .pickerStyle(.menu)
                .accentColor(.init(.label))
                
            }
            
            HStack(spacing: 0){
                Text(climate.minTemp.localizedTemp)
                    .fonted(.title3, weight: .regular)
                
                Image(systemName: Constants.SystemIcons.arrowDown)
                    .fonted(.headline, weight: .heavy)
                    .foregroundColor(Constants.minTempColor)
                    .accessibilityHidden(true)
                
                GeometryReader { geo in
                   
                    ZStack{
                        TemperatureForecastBar(
                            minTempValue: Int(climate.minTemp),
                            maxTempValue: Int(climate.maxTemp),
                            meanTempValue: Int(climate.meanTemp),
                            minTempOfAll: Int(minTempOfYear),
                            maxTempOfAll: Int(maxTempOfYear),
                            width: geo.size.width
                        )
                    }
                    .onAppear {
                        if let monthInt = Calendar.current.dateComponents([.month], from: Date()).month {
                            selectedMonth = monthInt - 1
                        }
                        
                    }
                    .onChange(of: geo.size) { size in
                        calculateBarValues(width: size.width)
                    }
                    .onChange(of: selectedMonth) { monthIndex in
                        climate = climateData.climateForIndex(index: monthIndex + 1)
                        calculateBarValues(width: geo.size.width)
                    }
                    .onChange(of: climateData.monthlyClimates) { newValue in
                        climate = newValue[selectedMonth]
                        calculateBarValues(width: geo.size.width)
                    }
                }
                .frame(height: 8)
                
                

                Image(systemName: Constants.SystemIcons.arrowUp)
                    .fonted(.headline, weight: .heavy)
                    .foregroundColor(Constants.maxTempColor)
                    .accessibilityHidden(true)
                
                Text(climate.maxTemp.localizedTemp)
                    .fonted(.title3, weight: .regular)
            }
            
            let unit = PrecipitationUnit(rawValue: precipitationUnit)?.amount ?? ""
            DetailRow(title: Text("Accumulated precipitation",  tableName: "Climate"), value: climate.sumPrecipitation.localizedPrecipitation, unit: Text(unit))
            DetailRow(title: Text("Rain Fall",  tableName: "Climate"), value: climate.sumRainfall.convertedPrecipitation(), unit: Text(unit))
            DetailRow(title: Text("Snow Fall",  tableName: "Climate"), value: climate.sumSnowfall, unit: Text(unit))
            DetailRow(title: Text("Daylight Duration",  tableName: "Climate"), value: climate.daytime, unit: Text("hours", tableName: "General"))
            DetailRow(title: Text("Cloudy Days",  tableName: "Climate"), value: Double(climate.cloudyDays), unit: Text("days", tableName: "General"), isInt: true)

            
        }
    }
    
    func calculateBarValues(width: CGFloat){
        DispatchQueue.main.async {
            
            minTempOfYear = ClimateData.getMinTempOfYear(climates: climateData.monthlyClimates)
            maxTempOfYear = ClimateData.getMaxTempOfYear(climates: climateData.monthlyClimates)
            
            let two: Double = 2.0
            let totalAverage = maxTempOfYear + minTempOfYear / two
            let average = climate.minTemp + climate.maxTemp / two
            let maxDiff = maxTempOfYear - minTempOfYear
            barStartPadding = ((average - totalAverage) / maxDiff) * width
            let currentDiff = climate.maxTemp - climate.minTemp

            barWidth = (currentDiff/maxDiff) * width

            meanStartPadding = (climate.meanTemp / maxDiff) * width
        }
    }
}

private struct DetailRow: View {
    let title: Text
    let value: Double
    let unit: Text
    var isInt: Bool = false
    var body: some View {
        HStack(spacing: 2){
            title
                .fonted(.body, weight: .semibold)
                .foregroundColor(.secondary)
            Spacer()
            Text(isInt ? "\(Int(value).localizedNumber)" : value.localizedNumber(withFractionalDigits: 1))
                .fonted(.title3, weight: .semibold)
            unit.fonted(.body, weight: .regular)
        }
    }
}

