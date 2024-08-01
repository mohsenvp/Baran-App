//
//  WeatherDetailsViewType.swift
//  HeyWeather
//
//  Created by Kamyar on 1/12/22.
//

import Foundation

enum WeatherDetailsViewType: String, CaseIterable {
    case pressure
    case humidity
    case dewPoint
    case wind
    case visibility
    case uvIndex
    case clouds
    case precipitation
}

enum AstroType: String, CaseIterable {
    case sun
    case moon
}
