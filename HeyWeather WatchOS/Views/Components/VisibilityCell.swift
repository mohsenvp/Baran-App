//
//  VisibilityCell.swift
//  HeyWeather WatchOS
//
//  Created by Mohammad Yeganeh on 9/10/23.
//

import SwiftUI


struct VisibilityCell: View {
    @AppStorage(Constants.distanceUnitString, store: Constants.groupUserDefaults) var unit: String = Constants.defaultDistanceUnit.rawValue
    
    let data: SimpleChartData
    let isHourly: Bool
    @Environment(\.colorScheme) var colorScheme

    var body: some View {
        let blueColor: Color = colorScheme == .dark ? .white : .init(hex: "1D3E92")
        VStack{
            Text(data.value.localizedNumber(withFractionalDigits: 0))
                .fonted(size: 16, weight: .bold)
                .foregroundStyle(Constants.hexAccent)
            
            
            Spacer(minLength: 0)
            
            Text(unit)
                .fonted(size: 14, weight: .bold)
                .foregroundStyle(blueColor)
            
            
            Spacer(minLength: 0)
            
            Text(isHourly ? data.date.localizedHour(withAmPm: false) : data.date.veryShortWeekday)
                .fonted(size: 14, weight: .bold)
                .foregroundStyle(.secondary)
        }
    }
}
