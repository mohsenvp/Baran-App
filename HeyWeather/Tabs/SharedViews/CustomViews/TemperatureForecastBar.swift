//
//  TemperatureForecastBar.swift
//  HeyWeather
//
//  Created by Reza Ranjbaran on 16/05/2023.
//

import SwiftUI

struct TemperatureForecastBar: View {
    typealias BarPosition = (width: CGFloat, offset: CGFloat, meanOffset: CGFloat)
    let minTempValue: Int?
    let maxTempValue: Int?
    let meanTempValue: Int?
    let minTempOfAll: Int?
    let maxTempOfAll: Int?
    var width: CGFloat = 60
    var dashColor: Color = .secondary
    var body: some View {
        let position = getBarPosition()
        let colors = TemperatureColor.getColors(min: Double(minTempValue ?? 0), max: Double(maxTempValue ?? 0))
        if meanTempValue != nil { //mean temp is for climate view
            ZStack {
                Line()
                    .stroke(style: StrokeStyle(lineWidth: 1, dash: [8]))
                    .foregroundColor(.secondary)
                    .frame(height: 1)
                    .padding(.horizontal)
                
                RoundedRectangle(cornerRadius: 4)
                    .fill(LinearGradient(colors: colors, startPoint: .leading, endPoint: .trailing))
                    .offset(x: position.offset)
                    .frame(width: position.width, height: 8)
                
                Circle()
                    .frame(width: 4)
                    .foregroundColor(.white)
                    .offset(x: position.meanOffset)
            }
        }else {
            ZStack {
                LinearGradient(colors: colors, startPoint: .leading, endPoint: .trailing)
                    .clipShape(Capsule())
                    .frame(width: position.width)
                    .offset(x: position.offset)
                    .shadow(radius: 0.1)
                    .opacity(0.8)
                
                Path { path in
                    path.move(to: .init(x: 0, y: 2.5))
                    path.addLine(to: .init(x: width, y: 2.5))
                }
                .stroke(style: .init(lineWidth: 1, lineJoin: .round, dash: [2.5]))
                .fill(Color.secondary.opacity(Constants.tertiaryOpacity))
                .frame(width: width)
                
                if position.meanOffset != 0 {
                    Circle().frame(width: 4).foregroundColor(.white)
                }
            }
            .frame(height: 5)
        }
        
    }
    
    private func getBarPosition() -> BarPosition {
        guard let minTempValue = minTempValue,
              let maxTempValue = maxTempValue,
              let minTempOfAll = minTempOfAll,
              let maxTempOfAll = maxTempOfAll else { return (0,0,0) }
        
        let two: CGFloat = 2.0
        let totalAverage = CGFloat(maxTempOfAll + minTempOfAll)/two
        var average = CGFloat(minTempValue + maxTempValue)/two
        if average == CGFloat(minTempValue) {
            average += 0.5
        }
        let maxDiff = CGFloat(maxTempOfAll - minTempOfAll)
        let offset = ((average - totalAverage)/maxDiff) * width
        
        var currentDiff = CGFloat(maxTempValue - minTempValue)
        if currentDiff == 0.0 {
            currentDiff += 0.5
        }
        
        let barWidth = (currentDiff/maxDiff) * (width)
        
        var meanOffset = 0.0
        if meanTempValue != nil{
            meanOffset = ((CGFloat(meanTempValue!) - totalAverage)/maxDiff) * width
        }
        return (barWidth, offset, meanOffset)
    }
}
