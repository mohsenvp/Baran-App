//
//  OtherWidgetsData.swift
//  HeyWeather
//
//  Created by Kamyar on 5/8/21.
//

import Foundation
import SwiftyJSON

struct OtherWidgetsData: Decodable {
    var currentWeather: Weather
    var hourlyWeatherForecast: [Weather]
    var currentAQI: AQI
    var astronomy: Astronomy
    var updatedAt: String
    
    init(currentWeather: Weather, hourlyWeatherForecast: [Weather], currentAQI: AQI, astronomy: Astronomy, updatedAt: String = Date().toUserTimeFormatWithMinuets(forceCurrentTimezone: true)) {
        self.currentWeather = currentWeather
        self.hourlyWeatherForecast = hourlyWeatherForecast
        self.currentAQI = currentAQI
        self.astronomy = astronomy
        self.updatedAt = updatedAt
    }
    
    init() {
        self.currentWeather = Weather()
        self.hourlyWeatherForecast = Array.init(repeating: Weather(), count: 6)
        self.currentAQI = AQI()
        self.astronomy = Astronomy()
        self.updatedAt = "11:29"
    }
    
}

enum DataRequestItem: String {
    case aqi
    case current
    case astronomy
}
