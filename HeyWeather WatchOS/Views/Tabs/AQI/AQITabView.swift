//
//  AQITabView.swift
//  HeyWeather WatchOS
//
//  Created by Mohammad Yeganeh on 8/7/23.
//

import SwiftUI

struct AQITabView: View {
    @ObservedObject var viewModel: WatchViewModel
    var body: some View {
        VStack(alignment: .leading, spacing: -4){
            Group {
                
                Spacer(minLength: 0)
                
                Text("Air Quality", tableName: "AQI")
                    .fonted(.callout, weight: .medium)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                Spacer(minLength: 0)
                
                Text("US AQI:", tableName: "AQI")
                    .fonted(.caption2, weight: .regular)
                
                Text("\(viewModel.aqiData.current.value)")
                    .fonted(.largeTitle, weight: .bold)
                
                Text(viewModel.aqiData.current.status)
                    .fonted(.body, weight: .regular)
                    .padding(.top, 2)
                
                Spacer(minLength: 0)
                
            }
        }
        .padding(.horizontal, 20)
        .foregroundColor(.white)
        .background(Constants.aqiColors[viewModel.aqiData.current.index])

    }
}
