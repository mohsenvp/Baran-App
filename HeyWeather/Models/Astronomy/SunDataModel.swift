//
//  SunDataModel.swift
//  HeyWeather
//
//  Created by Mohsen on 28/11/2023.
//

import Foundation
import SwiftyJSON

struct SunDataModel: Codable {
    var sunrise: Date?
    var sunset: Date?
    var dayProgress: Double = 1.0
    var secondsFromGMT: Double = 0
    var distance: Double = 0
    var altitude: Double = 0
    var direction: Double = 0
    var alwaysUp: Bool = false
    var alwaysDown: Bool = false
    
    var isAppear: Bool {
        let now = Date().addingTimeInterval(secondsFromGMT)
        guard let sunriseUnwrapped = sunrise, let sunsetUnwrapped = sunset else {
            return false
        }
        if now > sunriseUnwrapped && now < sunsetUnwrapped {
            return true
        } else { return false }
    }
    
    init(){
        
    }
    
    init(sunrise: Date, sunset:Date) {
        self.sunrise = sunrise
        self.sunset = sunset
    }

    func getDayDurationHours() -> String {
        guard let sunriseUnwrapped = sunrise, let sunsetUnwrapped = sunset else {
            return 12.localizedNumber
        }
        let components = Calendar.current.dateComponents([.hour, .minute], from: sunriseUnwrapped, to: sunsetUnwrapped)
        let hours = components.hour ?? 0
        return "\(hours.localizedNumber)"
    }
    
    func getNightDurationHours() -> String {
        guard let sunriseUnwrapped = sunrise, let sunsetUnwrapped = sunset else {
            return 12.localizedNumber
        }
        let components = Calendar.current.dateComponents([.hour, .minute], from: sunriseUnwrapped, to: sunsetUnwrapped)
        let hours = 24 - (components.hour ?? 0)
        return "\(hours.localizedNumber)"
    }
    
    func getNightDurationMinutes() -> String {
        guard let sunriseUnwrapped = sunrise, let sunsetUnwrapped = sunset else {
            return "720"
        }
        let components = Calendar.current.dateComponents([.hour, .minute], from: sunriseUnwrapped, to: sunsetUnwrapped)
        let minutes = 60 - (components.minute ?? 0)
        return "\(minutes.localizedNumber)"
    }
    
    func getDayDurationMinutes() -> String {
        guard let sunriseUnwrapped = sunrise, let sunsetUnwrapped = sunset else {
            return "720"
        }
        let components = Calendar.current.dateComponents([.hour, .minute], from: sunriseUnwrapped, to: sunsetUnwrapped)
        let minutes = components.minute ?? 0
        return "\(minutes.localizedNumber)"
    }
    func getDayDurationInSecond() -> Int {
        guard let sunriseUnwrapped = sunrise, let sunsetUnwrapped = sunset else {
            return 86400
        }
        let components = Calendar.current.dateComponents([.second], from: sunriseUnwrapped, to: sunsetUnwrapped)
        let seconds = components.second ?? 0
        return seconds
    }
    func getDayTimePercentage() -> Double {
        let dayTime: Double = Double(self.getDayDurationInSecond()) / 86400
        
        return dayTime
    }
}
