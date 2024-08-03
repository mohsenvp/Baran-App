//
//  DewPointCell.swift
//  HeyWeather WatchOS
//
//  Created by Mohammad Yeganeh on 9/11/23.
//

import SwiftUI

struct DewPointCell: View {
    @AppStorage(Constants.distanceUnitString, store: Constants.groupUserDefaults) var unit: String = Constants.defaultDistanceUnit.rawValue
    
    let data: SimpleChartData
    let isHourly: Bool
    @Environment(\.colorScheme) var colorScheme

    var body: some View {
        let blueColor: Color = colorScheme == .dark ? .white : .init(hex: "1D3E92")
        VStack{
            
            Spacer(minLength: 0)
            
            Text("\(Int(data.value))\(Constants.degree)")
                .fonted(size: 16, weight: .bold)
                .foregroundStyle(blueColor)
            
            
            
            Spacer(minLength: 0)
            
            Text(isHourly ? data.date.localizedHour(withAmPm: false) : data.date.veryShortWeekday)
                .fonted(size: 14, weight: .bold)
                .foregroundStyle(.secondary)
        }
    }
}
