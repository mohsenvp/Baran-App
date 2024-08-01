//
//  FeelsLikeText.swift
//  HeyWeather
//
//  Created by Kamyar on 11/28/21.
//

import SwiftUI

struct FeelsLikeText: View {
    let feelsLikeTemp: String
    var body: some View {
        Text("Feels like: \(feelsLikeTemp)", tableName: "WeatherTab")
            .fonted(.body, weight: .regular)
    }
}
