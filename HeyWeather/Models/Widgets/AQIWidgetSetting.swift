//
//  AQIWidgetSetting.swift
//  HeyWeather
//
//  Created by Mohammad Yeganeh on 7/22/23.
//

import Foundation

import SwiftUI

struct AQIWidgetSetting : Codable {
    var widgetStyle : AQIWidgetStyle = .random()
    var showCityName : Bool = true
    var showAddress : Bool = false
    var hideIt : Bool = false
    
    
    init(widgetStyle: AQIWidgetStyle, showCityName : Bool) {
        self.widgetStyle = widgetStyle
        self.showCityName = showCityName
    }

    
    init() {
    }
}



enum AQIWidgetStyle: String, Codable, CaseIterable {
    case simple
    case guage
    case detailed
    
    func title() -> String {
        switch self {
        case .simple:
            return String(localized: "Simple Style", table: "Widgets")
        case .guage:
            return String(localized: "Guage Style", table: "Widgets")
        case .detailed:
            return String(localized: "Detailed Style", table: "Widgets")
        }
    }
    
    func description() -> String {
        switch self {
        case .simple:
            return String(localized: "Simple AQI widget", table: "Widgets")
        case .guage:
            return String(localized: "AQI Widget with Guage Indicator", table: "Widgets")
        case .detailed:
            return String(localized: "AQI Widget with Gas Details", table: "Widgets")
        }
    }
    
    static func random() -> AQIWidgetStyle {
        let value = Int.random(in: 0...2)
        switch value {
        case 0:
            return .simple
        case 1:
            return .guage
        default:
            return .detailed
        }
    }
}
