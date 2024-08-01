//
//  AppSettings.swift
//  HeyWeather
//
//  Created by Mohammad Yeganeh on 12/2/23.
//

import Foundation
import SwiftyJSON

struct AppSettings : Codable {
    
    var cities : [City]
    
    var temperature: TemperatureUnit
    var speed: SpeedUnit
    var distance: DistanceUnit
    var pressure: PressureUnit
    var precipitation: PrecipitationUnit
    
    var timeFormat: TimeFormatType
    var appearance: AppAppearance
    var appIcon: Int
    
    var premium: Premium = AppState.shared.premium
    var notificationConfigs: [NotificationConfigItem]
    var weatherDataSource: String
    var aqiDataSource: String
    
    var deviceId: String
    var notificationToken: String
    var timezone: TimeZone
    var language: AppLanguage
    
    
    var general = ""
    var sources = ""
    var settings = ""
    var units = ""
    
    enum CodingKeys: String, CodingKey {
        case cities
        case temperature
        case speed
        case distance
        case pressure
        case precipitation
        case timeFormat = "time_format"
        case appearance
        case appIcon = "app_icon"
        case premium
        case notificationConfigs = "notifications_config"
        case weatherDataSource = "weather"
        case aqiDataSource = "aqi"
        case deviceId = "device_id"
        case notificationToken = "notification_token"
        case timezone = "time_zone"
        case language
        case general
        case sources
        case settings
        case units
    }
    

    enum CityCodingKey: String, CodingKey {
        case id
        case city_name
        case lat
        case long
        case main_city
    }
    
    enum NotificationCodingKey: String, CodingKey {
        case at_hour
        case at_min
        case relative_seconds
        case days
        case details
    }
    
    struct AnyKey: CodingKey {
        var stringValue: String
        var intValue: Int?

        init?(stringValue: String) {
            self.stringValue = stringValue
        }

        init?(intValue: Int) {
            self.stringValue = String(intValue)
            self.intValue = intValue
        }
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)

        var citiesContainer = container.nestedUnkeyedContainer(forKey: .cities)
        try self.cities.forEach { city in
            var cityItem = citiesContainer.nestedContainer(keyedBy: CityCodingKey.self)
            try cityItem.encode(city.id == 0 ? nil : city.id, forKey: .id)
            try cityItem.encode(city.placeMarkCityName, forKey: .city_name)
            try cityItem.encode(city.location.lat, forKey: .lat)
            try cityItem.encode(city.location.long, forKey: .long)
            try cityItem.encode(city.id == CityAgent.getMainCity().id, forKey: .main_city)
        }
        
        var unitsContainer = container.nestedContainer(keyedBy: CodingKeys.self, forKey: .units)
        try unitsContainer.encode(self.temperature, forKey: .temperature)
        try unitsContainer.encode(self.speed, forKey: .speed)
        try unitsContainer.encode(self.distance, forKey: .distance)
        try unitsContainer.encode(self.pressure, forKey: .pressure)
        try unitsContainer.encode(self.precipitation, forKey: .precipitation)
        
        var settingContainer = container.nestedContainer(keyedBy: CodingKeys.self, forKey: .settings)
        try settingContainer.encode(self.timeFormat, forKey: .timeFormat)
        try settingContainer.encode(self.appearance, forKey: .appearance)
        try settingContainer.encode(self.appIcon, forKey: .appIcon)
        
        var notificationsContainer = container.nestedContainer(keyedBy: AnyKey.self, forKey: .notificationConfigs)
        try self.notificationConfigs.forEach { config in
            if config.isSelected {
                if let titleKey = AnyKey(stringValue: config.type.rawValue) {
                    var configItem = notificationsContainer.nestedContainer(keyedBy: NotificationCodingKey.self, forKey: titleKey)
                    try configItem.encode(config.at_hour, forKey: .at_hour)
                    try configItem.encode(config.at_min, forKey: .at_min)
                    try configItem.encode(config.relative_seconds == nil ? 0 : config.relative_seconds, forKey: .relative_seconds)
                    try configItem.encode(config.days, forKey: .days)
                    try configItem.encode(config.details, forKey: .details)
                }
            }
        }
        
        try container.encode(self.premium.isPremium, forKey: .premium)

        var datasourceContainer = container.nestedContainer(keyedBy: CodingKeys.self, forKey: .sources)
        try datasourceContainer.encode(self.weatherDataSource, forKey: .weatherDataSource)
        try datasourceContainer.encode(self.aqiDataSource, forKey: .aqiDataSource)
        
        var generalContainer = container.nestedContainer(keyedBy: CodingKeys.self, forKey: .general)
        try generalContainer.encode(self.deviceId, forKey: .deviceId)
        try generalContainer.encode(self.notificationToken, forKey: .notificationToken)
        try generalContainer.encode(self.timezone.identifier, forKey: .timezone)
        try generalContainer.encode(self.language, forKey: .language)
        
    }
    init(){
        cities = CityAgent.getAllCities()
        
        let tempUnitString = UserDefaults.get(for: .tempUnit) ?? ""
        let speedUnitString = UserDefaults.get(for: .speedUnit) ?? ""
        let distanceUnitString = UserDefaults.get(for: .distanceUnit) ?? ""
        let pressureUnitString = UserDefaults.get(for: .pressureUnit) ?? ""
        let precipitationUnitString = UserDefaults.get(for: .precipitationUnit) ?? ""
        temperature = .init(rawValue: tempUnitString) ?? Constants.defaultTempUnit
        speed = .init(rawValue: speedUnitString) ?? Constants.defaultSpeedUnit
        distance = .init(rawValue: distanceUnitString) ?? Constants.defaultDistanceUnit
        pressure = .init(rawValue: pressureUnitString) ?? Constants.defaultPressureUnit
        precipitation = .init(rawValue: precipitationUnitString) ?? Constants.defaultPrecipitationUnit
        
        timeFormat = TimeFormatType(rawValue: (UserDefaults.get(for: .timeFormat) ?? "")) ?? .twelveHour
        appearance = AppAppearance(rawValue: (UserDefaults.get(for: .appAppearance) ?? "")) ?? .auto
        appIcon = UserDefaults.get(for: .appIcon) ?? 0
        
        premium = UserDefaults.get(for: .premium) ?? .init(isPremium: false)
        notificationConfigs = UserDefaults.get(for: .notificationConfigs) ?? []
        weatherDataSource = DataSourceAgent.getCurrentWeatherDataSource().code
        aqiDataSource = DataSourceAgent.getCurrentAQIDataSource().code
        
        deviceId = UserDefaults.get(for: .uniqueId) ?? ""
        notificationToken = UserDefaults.get(for: .notificationToken) ?? ""

        timezone = .current
        language = LocalizeHelper.shared.currentLanguage
    }
    
    init(json: JSON) {
        
        //======= Units ========
        let unitsJson = json["units"]
        temperature = TemperatureUnit(rawValue: unitsJson["temperature"].stringValue) ?? Constants.defaultTempUnit
        speed = SpeedUnit(rawValue: unitsJson["speed"].stringValue) ?? Constants.defaultSpeedUnit
        distance = DistanceUnit(rawValue: unitsJson["distance"].stringValue) ?? Constants.defaultDistanceUnit
        pressure = PressureUnit(rawValue: unitsJson["pressure"].stringValue) ?? Constants.defaultPressureUnit
        precipitation = PrecipitationUnit(rawValue: unitsJson["precipitation"].stringValue) ?? Constants.defaultPrecipitationUnit
        
        
        //======= Settings ========
        let settingsJson = json["settings"]
        timeFormat = TimeFormatType(rawValue: settingsJson["time_format"].stringValue)  ?? .twelveHour
        appearance = AppAppearance(rawValue: settingsJson["appearance"].stringValue)  ?? .auto
        appIcon = settingsJson["app_icon"].intValue
        
        
        //======= Notification Config ========
        let notifsJson = json["notification_config"]
        notificationConfigs = []
        NotificationConfigType.allCases.forEach { configType in
            let notifConfigJson = notifsJson[configType.rawValue]
            var days: [Int] = []
            var details: [String] = []
            let daysJson = notifConfigJson["days"]
            let detailsJson = notifConfigJson["details"]
            (0..<daysJson.count).forEach { i in
                days.append(daysJson[i].intValue)
            }
            (0..<detailsJson.count).forEach { i in
                details.append(detailsJson[i].stringValue)
            }
            
            let config = NotificationConfigItem(
                type: configType,
                isSelected: true,
                at_hour: notifConfigJson["at_hour"].int,
                at_min: notifConfigJson["at_min"].int,
                relative_seconds: notifConfigJson["relative_seconds"].int,
                days: days,
                details: details
            )
        }
        
        
        //======= Sources ========
        let sourcesJson = json["sources"]
        weatherDataSource = sourcesJson["weather"].stringValue
        aqiDataSource = sourcesJson["aqi"].stringValue
        
        
        
        //======= Other ========
        premium = .init(isPremium: json["premium"].boolValue)
        deviceId = json["device_id"].stringValue
        notificationToken = json["notification_token"].stringValue
        timezone = TimeZone(identifier: json["time_zone"].stringValue) ?? TimeZone.current
        language = AppLanguage(rawValue: json["language"].stringValue)
        
        
        
        //======= Cities ========
        let citiesJson = json["cities"]
        cities = []
        (0..<citiesJson.count).forEach { i in
            let city = citiesJson[i]
            let cityItem = City(
                id: city["id"].intValue,
                name: city["city_name"].stringValue,
                state: "",
                country: "",
                location: .init(
                    lat: city["lat"].doubleValue,
                    long: city["long"].doubleValue
                )
            )
            self.cities.append(cityItem)
        }
    }
    
    
    
    func toServerJson() -> JSON {
        do {
            let encoder: JSONEncoder = JSONEncoder()
            let data = try encoder.encode(self)
            return try JSON(data: data, options: .topLevelDictionaryAssumed)
        }catch {
            return JSON()
        }
    }
    
}
