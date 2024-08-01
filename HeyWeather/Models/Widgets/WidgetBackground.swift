//
//  WidgetBackground.swift
//  HeyWeather
//
//  Created by Mohammad Yeganeh on 8/12/23.
//

import Foundation

enum WidgetBackground: String, Codable {
    case def
    case auto
    case light
    case dark
    case blue
    case teal
    case orange
    case red
    

    func title() -> String {
        switch self {
        case .def:
            return "Default"
        case .auto:
            return "Light | Dark (iOS Setting)"
        case .light:
            return "Light"
        case .dark:
            return "Dark"
        case .blue:
            return "Blue"
        case .teal:
            return "Teal"
        case .orange:
            return "Orange"
        case .red:
            return "Red"
        }
    }
    
    static func random() -> WidgetBackground {
        let value = Int.random(in: 0...7)
        switch value {
        case 0:
            return .def
        case 1:
            return .blue
        case 2:
            return .light
        case 3:
            return .teal
        case 4:
            return .orange
        case 5:
            return .red
        default:
            return .blue
        }
    }
}

