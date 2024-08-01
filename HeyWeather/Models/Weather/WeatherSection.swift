//
//  HourlyWeatherWrapper.swift
//  HeyWeather
//
//  Created by Mohammad Yeganeh on 5/20/23.
//

import Foundation

struct WeatherSection: Codable, Identifiable {
    var id: Int
    var sectionTitle: String
    var items: [Weather]
}
