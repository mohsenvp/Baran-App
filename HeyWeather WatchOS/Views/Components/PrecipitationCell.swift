//
//  PrecipitationCell.swift
//  HeyWeather WatchOS
//
//  Created by Mohammad Yeganeh on 9/10/23.
//

import SwiftUI

struct PrecipitationCell: View {
    @AppStorage(Constants.precipitationUnitString, store: Constants.groupUserDefaults) var unit: String = Constants.defaultPrecipitationUnit.rawValue

    let data: SimpleChartData
    let isHourly: Bool
    @Environment(\.colorScheme) var colorScheme

    var body: some View {
        let blueColor: Color = colorScheme == .dark ? .white : .init(hex: "1D3E92")
        VStack{
            HStack(spacing: 1){
                Text("\(Int(data.value))")
                    .fonted(size: 12, weight: .bold)
                    .foregroundStyle(Constants.hexAccent)
                Text(Constants.percent)
                    .fonted(size: 10, weight: .medium)
                    .foregroundStyle(Constants.hexAccent)
            }
            
            
            Spacer(minLength: 0)
            
            VStack(spacing: 0){
                Text(data.value2?.localizedNumber(withFractionalDigits: 1) ?? "")
                    .fonted(size: 16, weight: .bold)
                    .foregroundStyle(blueColor)
                Text(PrecipitationUnit(rawValue: unit)?.amount ?? "")
                    .fonted(size: 10, weight: .medium)
                    .foregroundStyle(blueColor)
            }
            
            
            Spacer(minLength: 0)

            Text(isHourly ? data.date.localizedHour(withAmPm: false) : data.date.veryShortWeekday)
                .fonted(size: 14, weight: .bold)
                .foregroundStyle(.secondary)
        }
    }
}
