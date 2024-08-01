//
//  WeatherData.swift
//  NeonWeather
//
//  Created by RezaRg on 7/21/20.
//

import Foundation
import SwiftyJSON

struct WeatherData: Codable, Identifiable, Equatable {

    var id = UUID()
    var today : Weather = Weather()
    var precipitation: Precipitation = Precipitation()
    var hourlyForecast: [Weather] = []
    var dailyForecast: [Weather] = []
    var location : City = CityAgent.getMainCity()
    var timezone: TimeZone = .current
    var updateTime = Date()
    var alerts: [WeatherAlert] = []
    

    mutating func setItem(json: JSON, for city: City, item: WeatherRequestItem) {
        let exactJson = json[item.rawValue]
        let timezone: TimeZone = .init(identifier: json["timezone"].stringValue) ?? .current
        
        switch item {
        case .current:
            self.today = Weather(from: exactJson, timezone: timezone)
        case .precipitation:
            self.precipitation = Precipitation(json: exactJson)
        case .hourly:
            var hourlyData = [Weather]()
            (0..<exactJson.count).forEach { i in
                let weather = Weather(from: exactJson[i], timezone: timezone)
                hourlyData.append(weather)
            }
            self.hourlyForecast = hourlyData
        case .daily:
            var dailyData = [Weather]()
            (0..<exactJson.count).forEach { i in
                let weather = Weather(from: exactJson[i], timezone: timezone)
                dailyData.append(weather)
            }
            self.dailyForecast = dailyData
        case .alerts:
            var alertsData = [WeatherAlert]()
            (0..<exactJson.count).forEach { i in
                let weather = WeatherAlert(json: exactJson[i], timezone: timezone)
                alertsData.append(weather)
            }
            self.alerts = alertsData
        }
        
        self.timezone = timezone
        self.location = city
    }
    

    mutating func setAlerts(alerts: [WeatherAlert]) {
        self.alerts = alerts
    }
    
    init() {

    }
    
    mutating func executeAdditional(requestOrigin: WeatherRequestOrigin = .weatherTab) {
        
        switch requestOrigin {
        case .homescreenWidget, .widgetTab:
            hourlyForecast = Array(hourlyForecast.prefix(21))
            dailyForecast = Array(dailyForecast.prefix(7))
            
        case .lockscreenWidget, .appleWatchWidget:
            hourlyForecast = Array(hourlyForecast.prefix(17))
            dailyForecast = Array(dailyForecast.prefix(6))
            
        case .appleWatch:
            hourlyForecast = Array(hourlyForecast.prefix(7))
            dailyForecast = Array(dailyForecast.prefix(7))
            
        case .citylistView:
            hourlyForecast = Array(hourlyForecast.prefix(2))
            dailyForecast = Array(dailyForecast.prefix(2))
        default:
            break
        }
        
        var calendar = Calendar.current
        calendar.timeZone = timezone
        
        let localSecondsFromGMT: TimeInterval = .init(timezone.secondsFromGMT())
        let localDate = Date().addingTimeInterval(localSecondsFromGMT)
        
        let startOfHourLocal = calendar.date(bySettingHour: calendar.component(.hour, from: localDate), minute: 0, second: 0, of: localDate)!
        let startOfDayLocal = calendar.startOfDay(for: Date()).addingTimeInterval(localSecondsFromGMT)
        
        hourlyForecast.removeAll{ $0.localDate < startOfHourLocal }
        dailyForecast.removeAll{ $0.localDate < startOfDayLocal}

        // MARK: adding daily max and min to each hour
        (0..<hourlyForecast.count).forEach { i in
            
            let nextHourWeather = hourlyForecast[i]
            
            if (nextHourWeather.temperature.max == nil) {
                if today.date.isOnSameDay(with: nextHourWeather.date) {
                    hourlyForecast[i].temperature.min = today.temperature.min
                    hourlyForecast[i].temperature.max = today.temperature.max
                }else {
                    
                    if let dailyWeatherForSameDayAsCurrent = dailyForecast.filter({$0.date.isOnSameDay(with: nextHourWeather.date)}).first {
                        hourlyForecast[i].temperature.min = dailyWeatherForSameDayAsCurrent.temperature.min
                        hourlyForecast[i].temperature.max = dailyWeatherForSameDayAsCurrent.temperature.max
                    }else {
                        let allHoursWeatherForSameDayAsCurrent = hourlyForecast.filter({$0.date.isOnSameDay(with: nextHourWeather.date)})
                        let allHourlyTemps = allHoursWeatherForSameDayAsCurrent.compactMap { $0.temperature.now}
                        
                        hourlyForecast[i].temperature.min = allHourlyTemps.min()
                        hourlyForecast[i].temperature.max = allHourlyTemps.max()
                    }
                }
            }
        }
    }

    
    
    func getHourly(for date: Date? = nil, isPremium: Bool, isDetail: Bool) -> [Weather] {
        return Array(hourlyForecast.filter({
            date == nil ? true : $0.localDate.isOnSameDay(with: date!)
        }).prefix(isPremium ? (isDetail ? hourlyForecast.count : Constants.maxPremiumHourly) : Constants.maxNotPremiumHourly))
    }
    
    func getDaily(isPremium: Bool, isDetail: Bool) -> [Weather] {
        return Array(dailyForecast.prefix(isPremium ? (isDetail ? dailyForecast.count : Constants.maxPremiumDaily) : Constants.maxNotPremiumDaily))
    }
    
    
    static func sectionilizeHourlyData(items weathers: [Weather]) -> [WeatherSection] {

        let calendar = Calendar.current.utc
        
        var hourlySections: [WeatherSection] = []
        var currentIndex = 0
        var weathersInDay: [Weather] = []

        for weather in weathers {
            
            if let lastWeather = weathersInDay.last {
                let currentDay = calendar.component(.day, from: weather.localDate)
                let lastDay = calendar.component(.day, from: lastWeather.localDate)
                
                if currentDay != lastDay {
                    let firstWeather = weathersInDay.first!
                    let section = WeatherSection(
                        id: currentIndex,
                        sectionTitle: firstWeather.localDate.shortWeekday + Constants.space +  firstWeather.localDate.shortLocalizedString,
                        items: weathersInDay
                    )
                    hourlySections.append(section)
                    
                    currentIndex += 1
                    weathersInDay = []
                }
            }
            
            weathersInDay.append(weather)
        }
        
        if !weathersInDay.isEmpty {
            let firstWeather = weathersInDay.first!
            let section = WeatherSection(id: currentIndex,
                                               sectionTitle: firstWeather.localDate.shortWeekday + Constants.space +  firstWeather.localDate.shortLocalizedString,
                                               items: weathersInDay)
            hourlySections.append(section)
        }
        return hourlySections
    }
    
    static func == (lhs: WeatherData, rhs: WeatherData) -> Bool {
        return lhs.id == rhs.id && lhs.today.isAvailable == rhs.today.isAvailable && lhs.updateTime == rhs.updateTime
    }
}
