//
//  ColoredMaxMinTempView.swift
//  HeyWeather
//
//  Created by Kamyar on 11/28/21.
//

import SwiftUI

struct AppMaxMinTempView: View {

    let maxTemp: String
    let minTemp: String
    let isAdaptive: Bool
    var body: some View {
        AdaptiveStack(horizontalSpacing: 2, verticalSpacing: 2) { sizeClass, typeSize in
            isAdaptive && sizeClass == .compact && typeSize > .large
        } content: {
            
            HStack(spacing: 2){
                Text(maxTemp)
                    .fonted(.body, weight: .regular)
                    .accessibilityLabel(Text("at max", tableName: "Accessibility"))
                    .accessibilityValue(maxTemp)
                
                Image(systemName: Constants.SystemIcons.arrowUp)
                    .fonted(.callout, weight: .bold)
                    .padding(.trailing, 1)
                    .unredacted()
                    .accessibilityHidden(true)
            }
            
            
            HStack(spacing: 2){
                Image(systemName: Constants.SystemIcons.arrowDown)
                    .fonted(.callout, weight: .bold)
                    .padding(.trailing, 1)
                    .padding(.leading, 5)
                    .unredacted()
                    .accessibilityHidden(true)
                    .opacity(0.7)

                Text(minTemp)
                    .fonted(.body, weight: .regular)
                    .accessibilityLabel(Text("at min", tableName: "Accessibility"))
                    .accessibilityValue(minTemp)
                    .opacity(0.7)
            }
            
        }
    }
}
