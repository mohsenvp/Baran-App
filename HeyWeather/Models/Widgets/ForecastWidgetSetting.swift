//
//  ForecastWidgetSetting.swift
//  HeyWeather
//
//  Created by Reza Ranjbaran on 16/05/2023.
//

import SwiftUI

struct ForecastWidgetSetting : Codable {
    var widgetLook : WidgetLook = .original
    var widgetBackground : WidgetBackground = .def
    var forecastType : ForecastType = .both
    var showCityName : Bool = true
    var showAddress : Bool = false
    var showFeelsLike : Bool = false
    var showUpdateTime : Bool = false
    var hideIt : Bool = false
    
    
    init(widgetLook: WidgetLook, widgetBackground : WidgetBackground,  forcastType: ForecastType, showCityName: Bool, showAddress: Bool = false, showUpdateTime: Bool = false) {
        self.widgetLook = widgetLook
        self.widgetBackground = widgetBackground
        self.forecastType = forcastType
        self.showCityName = showCityName
        self.showAddress = showAddress
        self.showUpdateTime = showUpdateTime
    }


    var iconSet : String {
        get {
            switch self.widgetLook {
            case .original:
                return "s00"
            case .neumorph:
                return "s01"
            case .simple:
                return "s02"
            case .skeumorph:
                return "s03"
            }
        }
    }
    
    init() {
        self.widgetLook = .random()
        self.widgetBackground = .random()
        self.forecastType = .random()
        self.showCityName = .random()
        self.showAddress = .random()
        self.showFeelsLike = .random()
    }
}


enum ForecastType: String, Codable {
    case daily
    case hourly
    case both
    
    func title() -> String {
        switch self {
        case .daily:
            return "Daily"
        case .hourly:
            return "Hourly"
        case .both:
            return "Both"
        }
    }
    
    static func random() -> ForecastType {
        let value = Int.random(in: 0...2)
        switch value {
        case 0:
            return .hourly
        case 1:
            return .daily
        default:
            return .both
        }
    }
    
}



