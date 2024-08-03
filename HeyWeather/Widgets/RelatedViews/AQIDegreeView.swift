//
//  AqiDegreeView.swift
//  HeyWeather
//
//  Created by Mohammad Yeganeh on 7/22/23.
//

import SwiftUI

struct AQIDegreeView: View {
    let aqi: AQI
    let lineWidth = 16.0
    var body: some View {
        ZStack {
           let progress: Double = aqi.value.aqiValueToProgress().interpolated(from: 0...100, to: 0.46...1.0)

            Circle()
                .trim(from: 0.46, to: 1.0)
                .stroke(style: .init(lineWidth: 16, dash: [2, 10]))
                .fill(Color.gray.opacity(0.3))
                .rotationEffect(.degrees(8.5))
                .padding(lineWidth / 2)
            
            Circle()
                .trim(from: 0.46, to: progress)
                .stroke(style: .init(lineWidth: 16, dash: [2, 10]))
                .fill(AngularGradient(colors: Constants.aqiColors, center: .center, startAngle: .degrees(120), endAngle: .degrees(340)))
                .rotationEffect(.degrees(8.5))
                .padding(lineWidth / 2)


            VStack {
                Text("US AQI:", tableName: "AQI")
                    .fonted(size: 10, weight: .regular)
                    .opacity(0.6)
                
                Text("\(aqi.value)")
                    .fonted(size: 36, weight: .bold)
                    .foregroundColor(Constants.aqiColors[aqi.index])
                    .contentTransition(.numericText())
                
                Text(aqi.status.uppercased())
                    .fonted(size: 20, weight: .bold)
                    .lineLimit(1)
                    .minimumScaleFactor(0.8)
                    .foregroundColor(Constants.aqiColors[aqi.index])
            }
        }
    }
}

struct AQIDegreeView_Previews: PreviewProvider {
    static var previews: some View {
        AQIDegreeView(aqi: .init(value: 34, index: 2, progress: 100))
    }
}
