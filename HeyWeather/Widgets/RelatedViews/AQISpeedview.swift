//
//  AQISpeedview.swift
//  HeyWeather
//
//  Created by Mohammad Yeganeh on 7/19/23.
//

import SwiftUI

struct AQISpeedview: View {
    let aqi: AQI
    let lineWidth: CGFloat = 16.0
    let handleWidth: CGFloat = 45.0

    var body: some View {
        ZStack {
            let progress: Double = aqi.value.aqiValueToProgress()
            Circle()
                .trim(from: 0.51, to: 0.99)
                .stroke(style: .init(lineWidth: lineWidth, lineCap: .round))
                .fill(LinearGradient(colors: Constants.aqiColors, startPoint: .leading, endPoint: .trailing))
            Circle()
                .trim(from: 0.5, to: 1.0)
                .fill(LinearGradient(colors: [.clear, Constants.aqiColors[aqi.index].opacity(0.6)], startPoint: .center, endPoint: .top))
                .padding(15)
            
            
            
            Image("ic_gauge_handle")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: handleWidth)
                .foregroundColor(Constants.aqiColors[aqi.index])
                .shadow(color: Constants.aqiColors[aqi.index].lighter(),radius: 20)
                .offset(x: -(handleWidth / 2.5))
                .rotationEffect(.degrees(progress.interpolated(from: (0...100), to:(0...180))))
                .offset(y: -(handleWidth / 5))
            
        }
        .padding(5)
        
        
    }
}

struct AQISpeedview_Previews: PreviewProvider {
    static var previews: some View {
        AQISpeedview(aqi: .init(value: 20, index: 2, progress: 25))
    }
}
