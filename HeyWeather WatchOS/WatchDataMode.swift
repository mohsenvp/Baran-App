//
//  WatchDataMode.swift
//  HeyWeather WatchOS
//
//  Created by Mohammad Yeganeh on 8/8/23.
//

import Foundation
import SwiftUI

enum WatchDataMode: String, CaseIterable {
    case weather
    case windSpeed
    case humidity
    case pressure
    case uvIndex
    case dewPoint
    case clouds
    case visibility
    case precipitation
    
    var next: WatchDataMode {
        switch self {
        case .weather:
            return .windSpeed
        case .windSpeed:
            return .humidity
        case .humidity:
            return .pressure
        case .pressure:
            return .uvIndex
        case .uvIndex:
            return .clouds
        case .clouds:
            return .visibility
        case .visibility:
            return .precipitation
        case .precipitation:
            return .dewPoint
        case .dewPoint:
            return .weather
        }
    }
    var icon: String {
        switch self {
        case .weather:
            return "ic_watch_weather"
        case .windSpeed:
            return "ic_wind"
        case .humidity:
            return "ic_humidity"
        case .pressure:
            return "ic_pressure"
        case .uvIndex:
            return "ic_uv"
        case .dewPoint:
            return "ic_dew"
        case .visibility:
            return "ic_visibility"
        case .clouds:
            return "ic_clouds"
        case .precipitation:
            return "ic_precipitation"
        }
    }
    
    var title: Text {
        switch self {
        case .weather:
            return Text("Weather", tableName: "TabItems")
        case .windSpeed:
            return Text("Wind", tableName: "WeatherDetails")
        case .humidity:
            return Text("Humidity", tableName: "WeatherDetails")
        case .pressure:
            return Text("Pressure", tableName: "WeatherDetails")
        case .uvIndex:
            return Text("UV Index", tableName: "WeatherDetails")
        case .dewPoint:
            return Text("Dew Point", tableName: "WeatherDetails")
        case .visibility:
            return Text("Visibility", tableName: "WeatherDetails")
        case .clouds:
            return Text("Clouds", tableName: "WeatherDetails")
        case .precipitation:
            return Text("Precipitation", tableName: "WeatherDetails")
        }
    }
 
}
