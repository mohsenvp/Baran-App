//
//  DataSourceAgent.swift
//  HeyWeather
//
//  Created by Mohammad Yeganeh on 5/8/23.
//

import Foundation

struct DataSourceAgent {
    
    static func getCurrentWeatherDataSource() -> WeatherDataSource {
        return UserDefaults.get(for: .currentWeatherDataSource) ?? WeatherDataSource()
    }
    
    static func setCurrentWeatherDataSource(dataSource: WeatherDataSource) {
        UserDefaults.save(value: dataSource, for: .currentWeatherDataSource)
        Task {
            try! await Repository().changeWeatherDataSource()
        }
    }
    
    static func setSelectedWeatherDataSource(dataSource: WeatherDataSource) {
        UserDefaults.save(value: dataSource, for: .currentWeatherDataSource)
    }
 
    
    static func getCurrentAQIDataSource() -> AQIDataSource {
        return UserDefaults.get(for: .currentAQIDataSource) ?? AQIDataSource()
    }
 
    static func setCurrentAQIDataSource(dataSource: AQIDataSource) {
        UserDefaults.save(value: dataSource, for: .currentAQIDataSource)
        Task {
            try! await Repository().changeAQIDataSource()
        }
    }
    
    static func setSelectedAQIDataSource(dataSource: AQIDataSource) {
        UserDefaults.save(value: dataSource, for: .currentAQIDataSource)
    }
}
