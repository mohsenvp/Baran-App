//
//  AQIData.swift
//  HeyWeather
//
//  Created by Mohammad Yeganeh on 7/24/23.
//

import Foundation
import SwiftyJSON

struct AQIData: Codable, Identifiable, Equatable {
    var id = UUID()
    var current : AQI = AQI()
    var hourlyForecast: [AQI] = []
    var dailyForecast: [AQI] = []
    var location : City = CityAgent.getMainCity()
    var timezone: TimeZone
    var updateTime = Date()
    var source: String = ""
    
    mutating func setItem(json: JSON, for city: City, item: AQIRequestItem) {
        let exactJson = json[item.rawValue]
        let timezone: TimeZone = .init(identifier: json["timezone"].stringValue) ?? .current
        
        switch item {
        case .current:
            self.current = AQI(json: exactJson, timezone: timezone)
        case .hourly:
            var hourlyData = [AQI]()
            (0..<exactJson.count).forEach { i in
                let weather = AQI(json: exactJson[i], timezone: timezone)
                hourlyData.append(weather)
            }
            self.hourlyForecast = hourlyData
        case .daily:
            var dailyData = [AQI]()
            (0..<exactJson.count).forEach { i in
                let weather = AQI(json: exactJson[i], timezone: timezone)
                dailyData.append(weather)
            }
            self.dailyForecast = dailyData
        }
        
        self.timezone = timezone
        self.location = city
        self.source = json["source"].stringValue

    }
    
    init(isBlank: Bool = false) {
        if !isBlank {
            let sampleArray = [AQI(),AQI(),AQI(),AQI()]
            self.dailyForecast = sampleArray
            self.hourlyForecast = sampleArray
        }
        self.timezone = .current
    }
    
    mutating func executeAdditional(requestOrigin: WeatherRequestOrigin) async {
        
        switch requestOrigin {
        case .weatherTab:
            hourlyForecast = Array(hourlyForecast.prefix(24))
            dailyForecast = Array(dailyForecast.prefix(7))
        case .homescreenWidget, .widgetTab:
            hourlyForecast = Array(hourlyForecast.prefix(7))
            dailyForecast = Array(dailyForecast.prefix(7))
            
        case .lockscreenWidget:
            hourlyForecast = Array(hourlyForecast.prefix(17))
            dailyForecast = Array(dailyForecast.prefix(6))
            
        case .citylistView:
            hourlyForecast = Array(hourlyForecast.prefix(2))
            dailyForecast = Array(dailyForecast.prefix(2))
        default:
            break
        }
        
        let currentDate = Date()
        var calendar = Calendar.current
        calendar.timeZone = timezone
        
        let localSecondsFromGMT: TimeInterval = .init(timezone.secondsFromGMT())
        let localDate = Date().addingTimeInterval(localSecondsFromGMT)
        
        // MARK: Remove older object that current hour from hourly forecast
        hourlyForecast.removeAll{ $0.localDate < calendar.date(bySettingHour: calendar.component(.hour, from: localDate), minute: 0, second: 0, of: localDate)! }
        
        // MARK: Remove older object that current day from daily forecast
        dailyForecast.removeAll{ $0.localDate < calendar.startOfDay(for: currentDate)}
        
        
    }
    
    
    
    func getHourly(for date: Date? = nil) -> [AQI] {
        return hourlyForecast.filter({
            date == nil ? true : $0.localDate.isOnSameDay(with: date!)
        })
    }
    
    func getDaily() -> [AQI] {
        return dailyForecast
    }
    
    
    static func == (lhs: AQIData, rhs: AQIData) -> Bool {
        return lhs.id == rhs.id
    }
}
