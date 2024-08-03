//
//  AQIGuageView.swift
//  HeyWeather
//
//  Created by Mohammad Yeganeh on 7/19/23.
//

import SwiftUI
import WidgetKit

struct AQIGuageView: View {
    
    let aqi: AQI
    let lineWidth: CGFloat = 12.0
    
    var circleColor: Color {
        #if os(watchOS)
            return Color.black
        #else
            return Color.init(.systemBackground)
        #endif
    }
    var body: some View {

        let progress: Double = aqi.value.aqiValueToProgress()
        
        ZStack {
            
            Circle()
                .trim(from: 0.46, to: 1.0)
                .stroke(style: .init(lineWidth: lineWidth, lineCap: .round))
                .fill(AngularGradient(colors: Constants.aqiColors, center: .center, startAngle: .degrees(170), endAngle: .degrees(340)))
                .rotationEffect(.degrees(8.5))
            
            HStack {
                Spacer(minLength: 0)
                Circle()
                    .fill(circleColor)
                    .frame(width: lineWidth * 0.8, height: lineWidth * 0.8)
                    .padding(lineWidth / 10)
            }
            .rotationEffect(.degrees(-186))
            .rotationEffect(.degrees(progress.interpolated(from: (0...100), to:(0...194))))
            
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

// THIS IS THE CODE FOR SECTIONED AQI GUAGE VIEW - DONT DELETE
//            ZStack {
//
//                ZStack {
//                    ForEach(0..<Constants.aqiColors.count, id: \.self) {index in
//                        let floatIndex: CGFloat = CGFloat(index)
//                        Circle()
//                            .trim(
//                                from: (floatIndex * multiplier),
//                                to: ((floatIndex + 1) * multiplier)
//                            )
//                            .stroke(style: .init(lineWidth: lineWidth, lineCap: .round))
//                            .fill( Constants.aqiColors[index])
//                            .zIndex(Double(5 - index))
//                    }
//                }
//                .padding(lineWidth * 0.75)
//
//                HStack {
//                    Spacer()
//                    ZStack {
//                        Circle()
//                            .fill(Constants.aqiColors[aqi.index])
//
//                        Circle()
//                            .strokeBorder(.white, lineWidth: 2)
//                    }
//                    .frame(width: lineWidth * 1.5, height: lineWidth * 1.5)
//
//                }
//                .rotationEffect(.degrees(progress.interpolated(from: (0...100), to:(0...maxDegree))))
//
//
//            }
//            .rotationEffect(.degrees(multiplier * 1000))
