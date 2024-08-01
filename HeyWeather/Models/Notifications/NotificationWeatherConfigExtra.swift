//
//  NotificationWeatherConfigExtra.swift
//  HeyWeather
//
//  Created by Mojtaba on 11/26/23.
//

import Foundation

enum NotificationWeatherConfigExtra: String, CaseIterable, Codable {
    case temp = "temp"
    case condition = "condition"
    case wind = "wind"
    case uv = "uv"
    case rh = "rh"
    case pop = "pop"
    case precp = "precp"
    case aqi = "aqi"
    case pressure = "pressure"
    case dew = "dew"
    case vis = "vis"
    case cloud = "cloud"
    case sunset = "sunset"
    case sunrise = "sunrise"
    case daytime = "daytime"
    case moon = "moon"
    case nighttime = "nighttime"
    
    var name: String {
        
        switch self {
            
        case .temp:
            return "Temprature"
        case .condition:
            return "Weather Condition"
        case .wind:
            return "Wind Speed"
        case .uv:
            return "UV index"
        case .rh:
            return "Humidity"
        case .pop:
            return "Chance of Precipitation"
        case .precp:
            return "Precipitation Amount"
        case .aqi:
            return "AQI"
        case .pressure:
            return "Pressure"
        case .dew:
            return "Dew Point"
        case .vis:
            return "Visibility"
        case .cloud:
            return "Cloudiness"
        case .sunset:
            return "Sunset"
        case .sunrise:
            return "Sunrise"
        case .daytime:
            return "Daylight Duration"
        case .moon:
            return "Moon Phase"
        case .nighttime:
            return "Nighttime Duration"
        }
        
    }
    var icon: String {

        switch self {
            
        case .temp:
            return "ic_dew"
        case .condition:
            return "Weather Condition"
        case .wind:
            return "ic_wind"
        case .uv:
            return "ic_uv"
        case .rh:
            return "ic_humidity"
        case .pop:
            return "ic_precipitation"
        case .precp:
            return "ic_precipitation"
        case .aqi:
            return "ic_notif_aqi"
        case .pressure:
            return "ic_pressure"
        case .dew:
            return "ic_dew"
        case .vis:
            return "ic_visibility"
        case .cloud:
            return "ic_clouds"
        case .sunset:
            return "sunset"
        case .sunrise:
            return "sunrise"
        case .daytime:
            return "Daylight Duration"
        case .moon:
            return "ic_moon"
        case .nighttime:
            return "Nighttime Duration"
        }
        
    }
    
}
