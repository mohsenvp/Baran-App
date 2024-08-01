//
//  Weather.swift
//  NeonWeather
//
//  Created by RezaRg on 7/13/20.
//

import Foundation
import SwiftyJSON
import UIKit
import SwiftUI

struct Weather: Codable, Identifiable, Equatable {
    var id: UUID = .init()
    var date: Date
    var temperature: WeatherTemperature
    var condition: WeatherCondition
    var description: WeatherDescription
    var details: WeatherDetails
    var updatedAt: String
    var localDate: Date
    var utcDate: Date
    var isAvailable : Bool = false
    var timezone : TimeZone = .current
    
    init(from json: JSON, timezone: TimeZone) {
        self.timezone = timezone
        let currentTimezone: TimeZone = .current
        let secondsFromGMT: TimeInterval = TimeInterval(currentTimezone.secondsFromGMT())
        let dt = json["dt"].doubleValue
        date = Date(timeIntervalSince1970: dt).addingTimeInterval(secondsFromGMT)
        temperature = .init(from: json["temp"])
        condition = .init(from: json["condition"])
        description = .init(from: json["description"])
        details = .init(from: json["details"])
        updatedAt = date.toUserTimeFormatWithMinuets()
        
        let localSecondsFromGMT: TimeInterval = .init(timezone.secondsFromGMT())
        localDate = Date(timeIntervalSince1970: dt).addingTimeInterval(localSecondsFromGMT)
        
        let zero: TimeInterval = .init(0)
        utcDate = Date(timeIntervalSince1970: dt).addingTimeInterval(zero)
        isAvailable = true
    }
    
    init() {
        date = .init()
        temperature = .init()
        condition = .init()
        description = .init()
        details = .init()
        updatedAt = date.toUserTimeFormatWithMinuets()
        localDate = .init()
        utcDate = .init()
    }
    
    
    static func == (lhs: Weather, rhs: Weather) -> Bool {
        return rhs.id == lhs.id
    }
}

struct WeatherDetails: Codable {
    var windSpeed : Double?
    var windDegree: Int?
    var humidity : Int?
    var pressure : Int?
    var uvIndex : Double?
    var dewPoint : Double?
    var visibility : Int?
    var pop : Int?
    var clouds : Int?
    var precipitation: Double?
    
    var rainPossibility: String? {
        guard let pop = pop, pop >= 1 else { return nil }
        return pop.localizedNumber + Constants.percent
    }
    
    var humidityDescription: String? {
        guard let humidity = humidity else { return nil }
        return humidity.localizedNumber + Constants.percent
    }
    
    var cloudsDescription: String? {
        guard let clouds = clouds else { return nil }
        return clouds.localizedNumber + Constants.percent
    }
    
    init(from json: JSON) {
        humidity = json["humidity"].int
        windSpeed = json["wind_speed"].double
        windDegree = json["wind_deg"].int
        pressure = json["pressure"].int
        uvIndex = json["uvi"].double
        dewPoint = json["dew_point"].double
        visibility = json["visibility"].int
        pop = json["pop"].int
        clouds = json["clouds"].int
        precipitation = json["precipitation"].double
    }
    
    init() {
        humidity = Int.random(in: 10..<100)
        
        windSpeed = Double(Int.random(in: 1..<20))
        windDegree = Int.random(in: 1..<180)
        pressure = Int.random(in: 800..<1200)
        uvIndex = Double(Int.random(in: 0..<10))
        dewPoint = Double(Int.random(in: 0..<10))
        visibility = Int.random(in: 8000..<12000)
        pop = Int.random(in: 0..<100)
        clouds = Int.random(in: 0..<100)
        precipitation = Double(Int.random(in: 0..<90)) + 0.65
    }

}

struct WeatherTemperature: Codable {
    var max: Int?
    var min: Int?
    var now: Int?
    var feels: Int?
    
    init(from json: JSON) {
        max = json["max"].int
        min = json["min"].int
        
        if let now = json["now"].int {
            self.now = now
        } else if let max = max, let min = min {
            now = (max + min)/2
        }
        
        feels = json["feels"].int ?? now
    }
    
    init() {
        let rand = Int.random(in: 10..<15)
        max = rand + 6
        min = rand - 6
        now = rand
        feels = rand + 1
    }
}
