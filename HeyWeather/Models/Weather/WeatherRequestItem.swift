//
//  WeatherRequestParams.swift
//  HeyWeather
//
//  Created by Kamyar on 11/9/21.
//

import Foundation

enum WeatherRequestItem: String, CaseIterable {
    case current
    case precipitation
    case daily
    case hourly
    case alerts
}
