//
//  CachableData.swift
//  HeyWeather
//
//  Created by Kamyar on 10/10/21.
//

import Foundation

struct CachableData<T: Codable>: Codable {
    var dataType: CachableDataType
    var data: T? {
        let now = Date()
        guard now.compare(expirationDate) == .orderedAscending else { return nil }
        return self.data
    }
    var date: Date = Date()
    var expirationDate: Date {
        let minute = TimeInterval(60)
        switch dataType {
        case .weather:
            return Date(timeInterval: 2*minute, since: date)
        case .moon:
            return Date(timeInterval: 30*minute, since: date)
        case .sun:
            return Date(timeInterval: 30*minute, since: date)
        case .aqi:
            return Date(timeInterval: 30*minute, since: date)
        }
    }
    
    enum CachableDataType: Codable {
        case weather
        case moon
        case sun
        case aqi
    }
}
