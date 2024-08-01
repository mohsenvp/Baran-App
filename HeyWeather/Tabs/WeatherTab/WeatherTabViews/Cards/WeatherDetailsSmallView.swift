//
//  WeatherDetailsSmallView.swift
//  HeyWeather
//
//  Created by Kamyar on 1/12/22.
//

import Foundation
import SwiftUI

struct WeatherDetailsSmallView: View {
    let type: WeatherDetailsViewType
    let value: String
    var windDirection: Int? = nil

    var body: some View {
        let isWind = type == .wind
        HStack(spacing:0) {
            if isWind {
                AnimatedWindView(height: 50)
                Spacer()
            }
            
            VStack(alignment: isWind ? .center : .leading, spacing: 4) {
                Strings.WeatherDetails.getWeatherDetailsTitle(for: type)
                    .fonted(.footnote, weight: .regular)
                    .opacity(Constants.primaryOpacity)
                    .lineLimit(1)
                    .minimumScaleFactor(0.8)
                
                Text(value)
                    .fonted(.headline, weight: .bold)
                    .lineLimit(1)
                    .minimumScaleFactor(0.8)
                  
            }.accessibilityElement(children: .ignore)

            
            Spacer()
            if isWind {
                WindDirectionCompassDetail(windDegree: windDirection)
                    .accessibilityElement(children: .ignore)
            } else {
                Image(Constants.Icons.getIconName(for: type))
                    .renderingMode(.template)
                    .resizable()
                    .frame(width: 32, height: 32)
                    .accessibilityHidden(true)
                    .foregroundColor(Constants.accentColor)
            }
        }
        .padding(5)
        .weatherTabShape()
        .accessibilityElement(children: .ignore)
        .accessibilityLabel(Text("\(Strings.WeatherDetails.getWeatherDetailsTitle(for: type)) is \(value)", tableName: "Accessibility"))
    }
}

fileprivate struct WindDirectionCompassDetail: View {
    let windDegree: Int?
    var body: some View {
        ZStack {
            Image(systemName: Constants.SystemIcons.arrowUp)
                .fonted(.body, weight: .semibold)
                .foregroundColor(Constants.accentColor)
                .rotationEffect(.degrees(Double((windDegree ?? 180) - 180))) // TODO: Handle This
                .cornerRadius(Constants.weatherTabRadius)
            Image(Constants.Icons.compass)
                .resizable()
        }.frame(width: 45, height: 45)
    }
}



func converWindSpeed(windSpeed : Double) -> Double {
    
    var speed : Double = 0
    if windSpeed == 0 {
        speed = 0
    } else if windSpeed < 1 {
        speed = 144
    } else if windSpeed < 2 {
        speed = 72
    } else if windSpeed < 3 {
        speed = 50
    } else if windSpeed < 5 {
        speed = 40
    } else if windSpeed < 8 {
        speed = 25
    } else if windSpeed < 10 {
        speed = 18
    } else if windSpeed < 14 {
        speed = 12
    } else if windSpeed < 17 {
        speed = 8
    } else if windSpeed < 20 {
        speed = 6
    } else if windSpeed < 24 {
        speed = 4
    } else if windSpeed < 28 {
        speed = 2.5
    } else if windSpeed < 32 {
        speed = 1.5
    } else {
        speed = 1
    }
    
    return speed
}

#if DEBUG
struct WeatherDetailsSmallView_Previews: PreviewProvider {
    static var previews: some View {
        
//            SunView(sun: Sun()).frame(height: 150)
        WindDirectionCompassDetail(windDegree: 50).previewLayout(.sizeThatFits)
    }
}
#endif


