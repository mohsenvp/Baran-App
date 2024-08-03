//
//  TimeFormat.swift
//  HeyWeather
//
//  Created by Kamyar on 10/10/21.
//

import Foundation


struct TimeFormat {
    static func getUserTimeFormat() -> TimeFormatType {
        if let userTimeFormat: TimeFormatType = UserDefaults.get(for: .timeFormat) {
            return userTimeFormat
        } else {
            let dateFormat = DateFormatter.dateFormat(fromTemplate: "j", options: 0, locale: Locale.current)!
            if dateFormat.firstIndex(of: "a") == nil {
                return .twentyFourHour
            }else {
                return .twelveHour
            }
        }
    }
}

enum TimeFormatType: String, CaseIterable, Codable {
    case twentyFourHour = "24h"
    case twelveHour = "12h"
    
    var index: Int {
        switch self {
        case .twentyFourHour:
            return 0
        default:
            return 1
        }
    }
    
    static func getFromIndex(index: Int) -> TimeFormatType {
        switch index {
        case 0:
            return .twentyFourHour           
        default:
            return .twelveHour
        }
    }
}
