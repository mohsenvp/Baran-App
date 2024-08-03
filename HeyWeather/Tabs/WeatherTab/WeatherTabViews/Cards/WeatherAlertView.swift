//
//  WeatherAlertView.swift
//  HeyWeather
//
//  Created by Mohammad Yeganeh on 10/11/23.
//

import Foundation
import SwiftUI

struct WeatherAlertView: View {
    let alerts: [WeatherAlert]
    
    var title: Text {
        if alerts.count > 1 {
            return Text("\(alerts[0].event ?? "") and \((alerts.count - 1).spelledOut) more", tableName: "WeatherAlerts")
        }else {
            return Text(alerts[0].event ?? "")
        }
    }
    var body: some View {
        
        HStack {
            title
                .fonted(.callout, weight: .semibold)
                .lineLimit(1)
                .padding(.leading, 8)
            Spacer()
            PulseView(pulseColor: Color(hex: alerts[0].color ?? Constants.defaultAlertColorCode))
                .frame(width: 34, height: 34)
                .accessibilityHidden(true)
        }
        .padding(8)
        .weatherTabShape(horizontalPadding: false, verticalPadding: false)
    }
}

