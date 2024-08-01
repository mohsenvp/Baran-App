//
//  AQIDashView.swift
//  HeyWeather
//
//  Created by Mohammad Yeganeh on 7/22/23.
//

import SwiftUI

struct AQIDashView: View {

    var name: Text
    var value: CGFloat = 3.2
    var aqiIndex: Int = 1
    var lineWidth: CGFloat = 2.0
    var lineSpacing: CGFloat = 12.0
    var textToBarSpacing: CGFloat = 1
    let max: Int = 6
    var colored: Bool = false
    var foregroundColor: Color = Color.primary
    var titleFontSize: CGFloat
    var valueFontSize: CGFloat
    
    var body: some View {
        
        VStack(spacing: textToBarSpacing){
            HStack(alignment: .bottom){
                name
                    .fonted(size: titleFontSize, weight: .semibold)
                Spacer()
                Text("\(value, specifier: "%g")")
                    .fonted(size: valueFontSize, weight: .semibold)
                    .contentTransition(.numericText())
                
            }
            
            HStack(spacing: lineSpacing){
                ForEach(0..<max, id: \.self) { index in
                    Capsule().fill(colored && index <= aqiIndex ? Constants.aqiColors[aqiIndex] : foregroundColor).opacity(index <= aqiIndex ? 1.0 : 0.2)
                }
            }
            .frame(height: lineWidth)
        }
    }
}


