//
//  ApplicationUnits.swift
//  HeyWeather
//
//  Created by Kamyar on 10/10/21.
//

import Foundation
import SwiftUI

enum TemperatureUnit: String, CaseIterable, AppUnitLogic {
    case celsius = "Celsius"
    case fahrenheit = "Fahrenheit"
    case kelvin = "Kelvin"
}

enum SpeedUnit: String, CaseIterable, AppUnitLogic {
    case mph
    case kmph = "km/h"
    case mps = "m/s"
}


enum DistanceUnit: String, CaseIterable, AppUnitLogic {
    case km, mi
}

enum PressureUnit: String, CaseIterable, AppUnitLogic {
    case hPa = "hPa"
    case mBar = "mBar"
    case inHg = "inHg"
    case mmHg = "mmHg"
}

enum PrecipitationUnit: String, CaseIterable, AppUnitLogic {
    case mm = "mm/h"
    case inch = "inph"
    
    var amount: String {
        switch self {
        case .mm:
            return "mm"
        case .inch:
            return "in"
        }
    }
}

protocol AppUnitLogic: Codable {}


enum AppUnit: Codable {
    case temperature
    case speed
    case distance
    case pressure
    case precipitation
}
