//
//  RelatedTimeOfAstronomyNotif.swift
//  HeyWeather
//
//  Created by Mojtaba on 11/26/23.
//

import Foundation

enum RelatedTimeOfAstronomyNotif: String, CaseIterable {
    case quarterHour = "15 Minutes"
    case halfHour = "30 Minutes"
    case oneHour = "1 Hour"
    
    var inSecond: Int {
        switch self {
        case .quarterHour:
            return 900
        case .halfHour:
            return 1800
        case .oneHour:
            return 3600
        }
    }
    
    var shortName: String {
        switch self {
        case .quarterHour:
            return "15m"
        case .halfHour:
            return "30m"
        case .oneHour:
            return "1h"
        }
    }
    
    static func getFromSeconds(second: Int) -> RelatedTimeOfAstronomyNotif {
        switch second {
        case 900:
            return .quarterHour
        case 1800:
            return .halfHour
        default:
            return .oneHour
        }
    }
}
