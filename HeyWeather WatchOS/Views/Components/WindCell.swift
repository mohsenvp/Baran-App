//
//  WindCell.swift
//  HeyWeather
//
//  Created by Mohammad Yeganeh on 9/10/23.
//

import SwiftUI

struct WindCell: View {
    let data: SimpleChartData
    let isHourly: Bool
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        let blueColor: Color = colorScheme == .dark ? .white : .init(hex: "1D3E92")
        VStack(spacing: 0){
            Image(systemName: Constants.SystemIcons.arrowUp)
                .fonted(size: 14, weight: .semibold)
                .foregroundStyle(blueColor)
                .rotationEffect(.degrees(Double((data.value2 ?? 180) - 180)))
                
            
            Spacer(minLength: 0)
            
            Text(data.value.localizedNumber(withFractionalDigits: 1))
                .fonted(size: 14, weight: .bold)
                .foregroundStyle(blueColor)
            
            Spacer(minLength: 0)

            Text(isHourly ? data.date.localizedHour(withAmPm: false) : data.date.veryShortWeekday)
                .fonted(size: 14, weight: .bold)
                .foregroundStyle(.secondary)

        }
    }
}
