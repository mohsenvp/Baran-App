//
//  AQIView.swift
//  HeyWeather
//
//  Created by Mohammad Yeganeh on 7/23/23.
//

import SwiftUI

struct AQIView: View {
    var aqi: AQI
    var body: some View {
        VStack(spacing: 6){
            HStack(alignment: .bottom, spacing: 6){
            
                    Image(Constants.Icons.getIconName(for: aqi.index))
                        .resizable()
                        .scaledToFit()
                        .frame(width: 30, height: 30)
                        .accessibilityHidden(true)
                        .padding(.bottom, 7)
               
                VStack(alignment: .leading, spacing: -2) {
                    
                    Text("Air Quality", tableName: "AQI")
                        .fonted(.footnote, weight: .regular)
                        .opacity(Constants.primaryOpacity)
                    
                    Text(aqi.status)
                        .fonted(.headline, weight: .bold)
                        .lineLimit(1)
                        .padding(.leading, -1)
                }
                
                Spacer()

                Text("US AQI: \(aqi.value.localizedNumber)", tableName:
                        "AQI")
                    .fonted(.footnote, weight: .regular)
                    .opacity(Constants.primaryOpacity)
                    .padding(.trailing, 8)
            }
            
            
            ZStack {
                GeometryReader { geo in
                    Capsule().fill(LinearGradient(colors: Constants.aqiColors, startPoint: .leading, endPoint: .trailing))
                    
                    HStack {
                        Circle().fill(Color.init(.systemBackground))
                            .frame(width: 10, height: 10)
                            .padding(.leading, (geo.size.width) * min(max(0.6, aqi.value.aqiValueToProgress()), 96.7) / 100)
                    }
                    .frame(height: 15)
                }
            }
            .frame(height: 15)
            .environment(\.layoutDirection, .leftToRight)
            
        }
        .accessibilityLabel(Text("air quality is \(aqi.status)", tableName: "Accessibility"))

    }
}

struct AQIView_Previews: PreviewProvider {
    static var previews: some View {
        AQIView(aqi: .init())
    }
}
