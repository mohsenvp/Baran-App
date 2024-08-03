//
//  WeatherCondition.swift
//  HeyWeather
//
//  Created by Kamyar on 12/6/21.
//

import Foundation
import SwiftyJSON

struct WeatherCondition : Codable {
    var type: WeatherType
    var intensity: Intensity
    var isDay = false
    
    enum WeatherType: String, CaseIterable, Codable, Equatable {
        case atmosphere
        case clear
        case clouds
        case storm
        case rain
        case snow
        case drizzle
        case nothing
    }
    
    enum Intensity: String, CaseIterable, Codable, Equatable {
        case light
        case normal
        case heavy
    }
    
    init() {
        self.type = .clear
        self.intensity = .normal
    }
    
    init(type: WeatherType, intensity: Intensity, isDay : Bool = true) {
        self.type = type
        self.intensity = intensity
        self.isDay = isDay
    }
    
    init(from json: JSON) {
        self.type = WeatherType(rawValue: json["status"].stringValue) ?? .clear
        self.intensity = Intensity(rawValue: json["level"].stringValue) ?? .normal
        self.isDay = json["isDay"].boolValue
    }
    
    init(from dictionary: Dictionary<String, Any>) {
        self.type = WeatherType(rawValue: dictionary["status"] as! String) ?? .clear
        self.intensity = Intensity(rawValue: dictionary["level"] as! String) ?? .normal
        self.isDay = (dictionary["isDay"] as! Int) == 1
    }
    
    var description: String {
        return type.rawValue
    }
}
