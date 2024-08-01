//
//  UserDefaultsKeys.swift
//  HeyWeather
//
//  Created by Kamyar on 10/10/21.
//

import Foundation

enum UserDefaultsKey: Codable {
    case uniqueId
    case allCustomizableThems
    case notificationToken
    case notificationConfigs
    case timeFormat
    case premium
    case mainCity
    case selectedCity
    case liveActivityTrackingCity
    case cities
    case newLocation
    case tempUnit
    case speedUnit
    case distanceUnit
    case pressureUnit
    case precipitationUnit
    case currentWeatherDataSource
    case currentAQIDataSource
    case currentLanguage
    case lastLocale
    case isFirstLaunch
    case appLaunches
    case appAppearance
    case appIcon
    case userAgent
    case mutipleCitiesWeatherData
    case selectedMapLayerKey
    case baseWeatherData(city: String)
    case current(city: String)
    case hourly(city: String)
    case daily(city: String)
    case aqiCurrent(city: String)
    case aqiHourly(city: String)
    case aqiDaily(city: String)
    case precipitation(city: String)
    case climate(city: String)
    case weatherAlert(city: String)

}

extension UserDefaultsKey: RawRepresentable {

    public typealias RawValue = String

    /// Failable Initalizer
    public init?(rawValue: RawValue) {
        return nil
    }

    /// Backing raw value
    public var rawValue: RawValue {
        switch self {
        case .uniqueId:
            return "uniqueId"
        case .allCustomizableThems:
            return "allCustomizableThems"
        case .notificationToken:
            return "notificationToken"
        case .timeFormat:
            return "timeFormat"
        case .premium:
            return "premium"
        case .mainCity:
            return "mainCity"
        case .selectedCity:
            return "selectedCity"
        case .liveActivityTrackingCity:
            return "liveActivityTrackingCity"
        case .newLocation:
            return "new_location"
        case .speedUnit:
            return "speedType"
        case .distanceUnit:
            return "distanceType"
        case .pressureUnit:
            return "pressureType"
        case .precipitationUnit:
            return "precipitationType"
        case .currentLanguage:
            return "current_lang"
        case .currentWeatherDataSource:
            return "current_weather_data_source"
        case .currentAQIDataSource:
            return "current_aqi_data_source"
        case .lastLocale:
            return "last_locale"
        case .isFirstLaunch:
            return "isFirstRun"
        case .cities:
            return "cityListItems"
        case .tempUnit:
            return "tempType"
        case .appAppearance:
            return "appearance"
        case .appIcon:
            return "selectedIcon"
        case .userAgent:
            return "user_agent"
        case .appLaunches:
            return "launchCount"
        case .selectedMapLayerKey:
            return "selected_map_layer_key"
        case .mutipleCitiesWeatherData:
            return "mutipleCitiesWeatherData"
        case .baseWeatherData(city: let city):
            return "Base_Weather_Data_\(city)"
        case .current(city: let city):
            return "Current_\(city)"
        case .hourly(city: let city):
            return "Hourly_\(city)"
        case .daily(city: let city):
            return "Daily_\(city)"
        case .aqiCurrent(city: let city):
            return "AQI_Current_\(city)"
        case .aqiHourly(city: let city):
            return "AQI_Hourly_\(city)"
        case .aqiDaily(city: let city):
            return "AQI_Daily_\(city)"
        case .precipitation(city: let city):
            return "Precipitation_\(city)"
        case .climate(city: let city):
            return "Climate_\(city)"
        case .weatherAlert(city: let city):
            return "WeatherAlert_\(city)"
        case .notificationConfigs:
            return "notificationConfigs"
            
        }
    }
}
