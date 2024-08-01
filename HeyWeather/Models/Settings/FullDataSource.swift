//
//  FullDataSource.swift
//  HeyWeather
//
//  Created by Mojtaba on 10/16/23.
//

import Foundation
import SwiftyJSON

struct FullDataSource: Decodable, Equatable {
    var aqiDataSource: [AQIDataSource]
    var weatherDataSource: [WeatherDataSource]
    
    init(aqiDataSource: [AQIDataSource], weatherDataSource: [WeatherDataSource]) {
        self.aqiDataSource = aqiDataSource
        self.weatherDataSource = weatherDataSource
    }
}
