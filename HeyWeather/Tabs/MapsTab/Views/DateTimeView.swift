//
//  DateTimeView.swift
//  HeyWeather
//
//  Created by mohamd yeganeh on 5/7/23.
//

import SwiftUI

struct DateTimeView: View {
    @ObservedObject var viewModel: MapViewModel

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 14)
                .strokeBorder(Color.init(.label).opacity(0.2), lineWidth: 1)
                .background(RoundedRectangle(cornerRadius: 14).fill(Color.init(.systemBackground).opacity(Constants.primaryOpacity)))

            VStack(spacing: 2){
                Text(viewModel.date.shortLocalizedString)
                    .fonted(.caption2, weight: .semibold)
                Text(viewModel.date.getTimeInFormat(format: "H:mm"))
                    .fonted(.footnote, weight: .light)
            }
        }
        .frame(width: 60, height: 50)
        .dynamicTypeSize(...DynamicTypeSize.xLarge)
        
        
    }
}

