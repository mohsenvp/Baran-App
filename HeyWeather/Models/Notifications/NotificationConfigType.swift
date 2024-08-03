//
//  NotificationConfigType.swift
//  HeyWeather
//
//  Created by Mojtaba on 11/26/23.
//

import Foundation

enum NotificationConfigType: String, CaseIterable, Codable {
    
    case todaySummary = "today_summary"
    case tomorrowOutlook = "tomorrow_outlook"
    case rainAlert = "rain_alert"
    case highUv = "high_uv"
    case highTemperature = "high_temperature"
    case lowTemperature = "low_temperature"
    case highWind = "high_wind"
    case poorAqi = "poor_aqi"
    case snowAlert = "snow_alert"
    case sunrise = "sunrise"
    case sunset = "sunset"
    case fullMoon = "full_moon"
    case severeWeather = "severe_weather"
    
    var enabled: Bool {
        let configs: [NotificationConfigItem] = UserDefaults.get(for: .notificationConfigs) ?? []
        if let config = configs.first(where: {$0.type == self}) {
            return config.isSelected
        }
        return false
    }
    
    var name: String {
        switch self {
        case .todaySummary:
            return String(localized: "Today Summary", table: "Notifications")
        case .tomorrowOutlook:
            return String(localized: "Tomorrow Outlook", table: "Notifications")
        case .rainAlert:
            return String(localized: "Rain Alert", table: "Notifications")
        case .highUv:
            return String(localized: "High UV", table: "Notifications")
        case .highTemperature:
            return String(localized: "High Temperature", table: "Notifications")
        case .lowTemperature:
            return String(localized: "Low Temperature", table: "Notifications")
        case .highWind:
            return String(localized: "High Wind", table: "Notifications")
        case .poorAqi:
            return String(localized: "Poor AQI", table: "Notifications")
        case .snowAlert:
            return String(localized: "Snow Alert", table: "Notifications")
        case .sunrise:
            return String(localized: "Sunrise", table: "Notifications")
        case .sunset:
            return String(localized: "Sunset", table: "Notifications")
        case .fullMoon:
            return String(localized: "Full Moon", table: "Notifications")
        case .severeWeather:
            return String(localized: "Severe Weather Alert", table: "Notifications")
        }
    }
    var description: String {
        switch self {
        case .todaySummary:
            return String(localized: "A morning notification containing the forecast of the current day.", table: "Notifications")
        case .tomorrowOutlook:
            return String(localized: "An evening notification providing an overview of tomorrow's forecast.", table: "Notifications")
        case .rainAlert:
            return String(localized: "Receive a notification when there is a 60% probability of rain during the day.", table: "Notifications")
        case .highUv:
            return String(localized: "Receive a notification when the UV index is projected to rise above 8.", table: "Notifications")
        case .highTemperature:
            return String(localized: "Receive a notification when the temperature is expected to exceed 30°C in the next few hours.", table: "Notifications")
        case .lowTemperature:
            return String(localized: "Receive a notification when the temperature is forecasted to drop below 0°C in the upcoming hours.", table: "Notifications")
        case .highWind:
            return String(localized: "Receive a notification when wind speeds are anticipated to exceed 30 mph during daylight hours.", table: "Notifications")
        case .poorAqi:
            return String(localized: "Receive a notification when the Air Quality Index (AQI) is forecasted to exceed 190 during daytime.", table: "Notifications")
        case .snowAlert:
            return String(localized: "Receive a notification when a significant amount of snowfall is forecasted.", table: "Notifications")
        case .sunrise:
            return String(localized: "Receive a notification at or before sunrise.", table: "Notifications")
        case .sunset:
            return String(localized: "Receive a notification at or before sunset.", table: "Notifications")
        case .fullMoon:
            return String(localized: "Receive a notification on the day when a full moon is expected.", table: "Notifications")
        case .severeWeather:
            return String(localized: "Receive a notification when a severe weather alert has been issued for your location.", table: "Notifications")
        }
    }
    var icon: String {
        switch self {
        case .todaySummary:
            return Constants.Icons.notifTodaySummary
        case .tomorrowOutlook:
            return Constants.Icons.notifTomorrowOutlook
        case .rainAlert:
            return Constants.Icons.notifRainAlert
        case .highUv:
            return Constants.Icons.notifHighUV
        case .highTemperature:
            return Constants.Icons.notifHighTemperature
        case .lowTemperature:
            return Constants.Icons.notifLowTemperature
        case .highWind:
            return Constants.Icons.notifHighWind
        case .poorAqi:
            return Constants.Icons.notifPoorAQI
        case .snowAlert:
            return Constants.Icons.notifSnowAlert
        case .sunrise:
            return Constants.Icons.sunrise
        case .sunset:
            return Constants.Icons.sunset
        case .fullMoon:
            return Constants.Icons.notifFullMoon
        case .severeWeather:
            return Constants.Icons.notifSevereWeather
        }
    }
    var category: String {
        switch self {
        case .todaySummary, .tomorrowOutlook:
            return String(localized: "Summary", table: "Notifications")
        case .rainAlert, .highUv,.highTemperature, .lowTemperature, .highWind, .poorAqi, .snowAlert:
            return String(localized: "Extra", table: "Notifications")
        case .sunrise, .sunset, .fullMoon:
            return String(localized: "Astronomy", table: "Notifications")
        case .severeWeather:
            return String(localized: "Severe", table: "Notifications")
        }
    }
    
    var notificationGroup: String {
        switch self {
        case .todaySummary, .tomorrowOutlook:
            "notification_summary"
        case .rainAlert, .highUv, .highTemperature, .lowTemperature, .highWind, .poorAqi, .snowAlert:
            "notification_extra"
        case .sunrise,.sunset,.fullMoon:
            "notification_astronomy"
        case .severeWeather:
            "notification_severe"
        }
    }
}
