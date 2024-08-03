//
//  WidgetLook.swift
//  HeyWeather
//
//  Created by Mohammad Yeganeh on 8/12/23.
//

import Foundation
enum WidgetLook: String, Codable {
    case original
    case skeumorph
    case simple
    case neumorph
    
    func title() -> String {
        switch self {
        case .original:
            return "Original Look (PREMIUM)"
        case .neumorph:
            return "Neumorphic Look (PREMIUM)"
        case .simple:
            return "Simple Look (PREMIUM)"
        case .skeumorph:
            return "Skeumorphic Look (PREMIUM)"
        }
    }
    
    func description() -> String {
        switch self {
        case .original:
            return "Same colors and icons in coherence with the app."
        case .neumorph:
            return "Inspired by the neumorphism of macOS."
        case .simple:
            return "Simplified icons and colors for a seamless experience"
        case .skeumorph:
            return "Inspired by the skeumorphic design of iOS 6."
        
        }
    }
    
    static func random() -> WidgetLook {
        let value = Int.random(in: 0...3)
        switch value {
        case 0:
            return .original
        case 1:
            return .neumorph
        case 2:
            return .simple
        case 3:
            return .skeumorph
        default:
            return .original
        }
    }
}
