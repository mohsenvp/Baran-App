//
//  WidgetKind.swift
//  HeyWeather
//
//  Created by Kamyar on 1/26/22.
//

import Foundation

enum WidgetKind: String {
    case customizable   = "WeatherWidget1"
    case forecast       = "WeatherWidget2"
//    case other          = "WeatherWidget3"
    case aqi            = "WeatherWidget4"
}

enum LockScreenWidgetKind: String, Codable, CaseIterable {
    case currentOne     = "LockScreenCurrentOne"
    case currentTwo     = "LockScreenCurrentTwo"
    case hourlyOne      = "LockScreenHourlyOne"
    case hourlyTwo      = "LockScreenHourlyTwo"
    case dailyOne       = "LockScreenDailyOne"
    case dailyTwo       = "LockScreenDailyTwo"
    case precipitation  = "LockScreenPrecipitation"
    case cloudiness     = "LockScreenCloudiness"
    case uv             = "LockScreenUV"
    case humidity       = "LockScreenHumidity"
    case aqi            = "LockScreenAQI"
}
