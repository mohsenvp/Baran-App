//
//  AppAppearance.swift
//  HeyWeather
//
//  Created by Kamyar on 11/10/21.
//

import Foundation

enum AppAppearance: String, CaseIterable, Codable {
    case auto
    case light
    case dark
    
    
    var index: Int {
        switch self {
        case .auto:
            return 1
        case .light:
            return 0
        case .dark:
            return 2
        }
    }
    
    
    static func getFromIndex(index: Int) -> AppAppearance {
        switch index {
        case 0:
            return .light
        case 1:
            return .auto
        default:
            return .dark
        }
    }
}
