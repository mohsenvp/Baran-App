//
//  CachableData.swift
//  HeyWeather
//
//  Created by Kamyar on 10/10/21.
//

import Foundation

struct CachableData<T: Codable>: Codable {
    var dataType: CachableDataType
    var data: T
    var isValid: Bool {
        let now = Date()
        guard now.compare(expirationDate) == .orderedAscending else { return false }
        return true
    }
    var date: Date = Date()
    var expirationDate: Date {
        
        #if DEBUG
//        return Date(timeInterval: 0, since: date)
        #endif
        
        let minute = 60.0
        switch dataType {
        case .mutipleCitiesWeatherData:
            return Date(timeInterval: 30 * minute, since: date)
        case .baseWeatherData:
            return Date(timeInterval: 1140 * minute, since: date)
        case .current:
            return Date(timeInterval: 15 * minute, since: date)
        case .hourly:
            return Date(timeInterval: 30 * minute, since: date)
        case .daily:
            return Date(timeInterval: 120 * minute, since: date)
        case .aqiCurrent:
            return Date(timeInterval: 30 * minute, since: date)
        case .aqiHourly:
            return Date(timeInterval: 30 * minute, since: date)
        case .aqiDaily:
            return Date(timeInterval: 30 * minute, since: date)
        case .precipitation:
            return Date(timeInterval: 2 * minute, since: date)
        case .newLocation:
            return Date(timeInterval: 10 * minute, since: date)
        case .climate:
            return Date(timeInterval: 30 * minute, since: date)
        case .premiumStatus:
            return Date(timeInterval: 1140 * minute, since: date)
        case .weatherAlerts:
            return Date(timeInterval: 30 * minute, since: date)
        }
    }
    
    init(data: T, dataType: CachableDataType) {
        self.dataType = dataType
        self.data = data
    }
}

enum CachableDataType: Codable {
    case baseWeatherData
    case mutipleCitiesWeatherData
    case weatherAlerts
    case current
    case hourly
    case daily
    case precipitation
    case aqiCurrent
    case aqiHourly
    case aqiDaily
    case newLocation
    case climate
    case premiumStatus
}
