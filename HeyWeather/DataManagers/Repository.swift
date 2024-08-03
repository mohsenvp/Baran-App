//
//  Repository.swift
//  HeyWeather
//
//  Created by Kamyar on 09/20/21.

//
import SwiftUI
import SwiftyJSON
import SwiftyStoreKit
import CoreLocation

class Repository {
    private var savedLocation : City? = nil
    let locationAgent = LocationAgent()
    
    init() {
        NetworkManager.reset()
    }

    // MARK: - GET WEATHER FUNCTIONS
    func getWeather(for city: City, requestItems: [WeatherRequestItem], requestOrigin: WeatherRequestOrigin, forceUpdate: Bool = false , forceCache: Bool = false) async throws -> WeatherData {
        
        let cachedWeatherDataAndRemainingParameters = getCachedWeatherDataAndRemainingParameters(for: city, parameters: requestItems, forceCache : forceCache)

        var cachedWeatherData = cachedWeatherDataAndRemainingParameters.cachedWeatherData
        let remainingParameters = forceUpdate ? requestItems : cachedWeatherDataAndRemainingParameters.remainingParameters

        
        if (!remainingParameters.isEmpty && !forceCache) {
            
            var weatherData = try await NetworkManager.shared.getWeather(city: city, weatherData: cachedWeatherData, requestItems: remainingParameters, requestOrigin: requestOrigin)
    
            //fill in the alerts in case response was delivered earlier
            let alerts = weatherData.alerts
            weatherData.setAlerts(alerts: alerts)
            
            await self.saveWeatherData(weatherData: weatherData, for: city, parameters: remainingParameters)
            cachedWeatherData = weatherData
            cachedWeatherData.executeAdditional(requestOrigin: requestOrigin)
            return cachedWeatherData
            
     
        } else {
            cachedWeatherData.executeAdditional(requestOrigin: requestOrigin)
            return cachedWeatherData
        }
    }
    
    // MARK: - GET WEATHER FOR MULTIPLE CITIES
    func getMultipleCitiesWeather(for cities: [City], forceCache: Bool = false, forceUpdate: Bool = false) async throws -> [WeatherData] {
        if !forceUpdate, let cachedData: [WeatherData] = loadData(dataType: .mutipleCitiesWeatherData, forceCache: forceCache) {
            return cachedData.filter({ data in
                cities.contains { city in
                    city.id == data.location.id
                }
            })
        }
        let data: [WeatherData] = try await NetworkManager.shared.getMultipleCitiesWeather(cities: cities)
        
        data.forEach { weatherData in
            saveBaseWeatherData(city: weatherData.location, weatherData: weatherData)
        }
        
        cacheData(data: data, dataType: .mutipleCitiesWeatherData)
        return data
    }

    
    // MARK: - GET WEATHER HISTORY
    func getWeatherHistory(for city: City, date: Date) async throws -> Weather {
        
        
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year, .month, .day], from: date)
        let noHourAndMinuteTimestamp = String(calendar.date(from: components)!.timeIntervalSince1970)

        return try await NetworkManager.shared.getWeatherHistory(city : city, timestamp: noHourAndMinuteTimestamp)
    }
    
    
    // MARK: - CHECK PREMIUM
    func checkPremiumStatus(verifyReceipt: Bool = false) async throws -> Premium  {
  
        #if os(watchOS)
        return UserDefaults.get(for: .premium) ?? Premium(isPremium: false)
        #endif
        
        if let cachedPremium: Premium = loadData(dataType: .premiumStatus), !cachedPremium.expireAtTimestamp.isPassed(), !verifyReceipt {
            return cachedPremium
        }

        if let receiptData = SwiftyStoreKit.localReceiptData {
            let receiptString = receiptData.base64EncodedString(options: [])
            let premium = try await NetworkManager.shared.checkPremiumStatus(verifyReceipt: verifyReceipt, token: receiptString)
            self.cacheData(data: premium, dataType: .premiumStatus)
            return premium
        }
        
        #if DEBUG
        return Premium(isPremium: true)
        #else
        return Premium()
        #endif        
    }
    
    // MARK: - GET LOCATION FUNCTIONS
    func getNewLocation() async -> City? {
        locationAgent.start()
        let newlocation = try? await locationAgent.getLocation()
        locationAgent.stop()
        
        if let location = newlocation {
            if let newCity = await CityAgent.retreiveCity(location: location) {
                self.cacheData(data: newCity, dataType: .newLocation)
                return newCity
            }
        }
        return nil
    }
    
    func CheckAutoLocationAndReturnCity(city : City, isWidget: Bool = false) async -> City {

        if city.isCurrentLocation {
            if let location = await getSavedNewLocation() {
                return location
            }
            
            if CLLocationManager.locationServicesEnabled() {
                let validStatuses: [CLAuthorizationStatus] = [.authorizedAlways, .authorizedWhenInUse, .notDetermined]
                
                var hasWidgetAccess = true
                #if os(iOS)
                hasWidgetAccess = CLLocationManager().isAuthorizedForWidgetUpdates
                #endif
//                print("Current status: \(CLLocationManager().authorizationStatus.description) | is Widget: \(isWidget), Widget Access: \(hasWidgetAccess)")
                if (!isWidget && validStatuses.contains(CLLocationManager().authorizationStatus)) || (isWidget && hasWidgetAccess) {
//                    print ("Can Get New Location")
                    if let newCity = await self.getNewLocation() {
                        return newCity
                    }
                }
            }
        }
        
//        print ("Return Same Location")
        return city
    }
    
    
    // MARK: - Send Notification Token
    func sendNotificationToken(notificationToken: String) async throws -> Bool {
        return try await NetworkManager.shared.sendNotificationToken(notificationToken: notificationToken)
    }
    
    
    func sendLiveActivityToken(liveActivityToken: String, city: City, end: Bool) async throws -> Bool {
        return try await NetworkManager.shared.sendLiveActivityToken(liveActivityToken: liveActivityToken, city: city, end: end)
    }
    
    // MARK: - Send Notification Configuration JSON
    func sendUserConfig(json: JSON) async throws -> Void {
        return try await NetworkManager.shared.postUserConfig(json: json)
    }
    // MARK: - Change DataSources
    func changeWeatherDataSource() async throws -> Bool {
        return try await NetworkManager.shared.changeWeatherDataSource()
    }
    func changeAQIDataSource() async throws -> Bool {
        return try await NetworkManager.shared.changeAQIDataSource()
    }
    // MARK: - GET AQI FUNCTIONS
    
    func getAQI(for city: City, requestItems: [AQIRequestItem], requestOrigin: WeatherRequestOrigin, forceUpdate: Bool = false , forceCache: Bool = false) async throws -> AQIData {
        
        let cachedAQI = await getCachedAQIData(for: city, parameters: requestItems, forceCache : forceCache)
        
        if (forceCache) {
            return cachedAQI.cachedAQIData
        }
        
        var cachedAQIData = forceUpdate ? AQIData(isBlank: true) : cachedAQI.cachedAQIData
        let remainingParameters = forceUpdate ? requestItems : cachedAQI.remainingParameters
        
        
        if !remainingParameters.isEmpty {
            let aqiData = try await NetworkManager.shared.getAQI(city : city, aqiData: cachedAQIData, requestItems: remainingParameters, requestOrigin: requestOrigin)
            await self.saveAQIData(aqiData: aqiData, for: city, parameters: remainingParameters)
            cachedAQIData = aqiData
            await cachedAQIData.executeAdditional(requestOrigin: requestOrigin)
            return cachedAQIData
            
        } else {
            await cachedAQIData.executeAdditional(requestOrigin: requestOrigin)
            return cachedAQIData
        }
    }
    

    
    // MARK: - Get Astronomy functions
    
    func getAstronomy(city: City, count: Int = 7, timeZone: TimeZone) -> [Astronomy] {
        let astronomies = AstronomyManager.shared.getAstronomy(city: city, count: count,timeZone: timeZone)
        return astronomies
    }

    
    // MARK: - Get Cliamte functions
    
    func getClimate(city: City, forceUpdate: Bool = false, forceCache: Bool = false) async throws -> ClimateData {
        if !forceUpdate, forceCache, let cachedClimate: ClimateData = loadData(for: city, dataType: .climate, forceCache: forceCache) {
            return cachedClimate
        } else if !forceUpdate, let cachedClimate: ClimateData = loadData(for: city, dataType: .climate){
            return cachedClimate
        } else {
            let climateData = try await NetworkManager.shared.getClimate(city: city)
                cacheData(for: city, data: climateData, dataType: .climate)
           return climateData
        }
        
    }
    
    
    // MARK: - Other functions
    
    func getIAPPlans(completion: @escaping ([AppPlan]) -> Void, failResponseCompletion: @escaping (NetworkFailResponse) -> Void) {
        NetworkManager.shared.getIAPPlans() { plans in
                   completion(plans)
        } failResponseCompletion: { response in failResponseCompletion(response) }
    }
    func getDataSources() async throws -> FullDataSource {
        return try await NetworkManager.shared.getDataSources()
    }
     
    
    func authorizeDevice() async throws {
        return try await NetworkManager.shared.authorizeDevice()
    }
    
    
    //MARK: - Maps APIs
    
    func getMapData() async throws -> MapData {
        return try await NetworkManager.shared.getMapData()
    }
    
    func getMapTilesURL(style: MapStyle, layer: MapLayer, x: UInt, y: UInt, z: UInt, timestamp: Date, isPremium: Bool,completion: @escaping (URL) -> Void) {
            NetworkManager.shared.getMapTileURL(style: style, layer: layer, x: x, y: y, z: z, timestamp: timestamp, isPremium: isPremium) { tileURL in
                completion(tileURL)
            }
        }
    
    func getMapStyle(style: MapStyle) async throws -> String {
        return try await NetworkManager.shared.getMapStyle(style: style)
    }
    func getUserAgent() -> String{
        return NetworkManager.createUserAgent()
    }
    
    // MARK: - Static and Private functions
    
    
    private func getSavedNewLocation() async -> City? {
        if let location: City = loadData(dataType: .newLocation) {
            savedLocation = location
            return location
        }
        return nil
    }
    
    func getLatestCacheDate(for city: City) -> Date? {
        let cityName = city.placeMarkCityName.replacingOccurrences(of: " ", with: "")
        if let cachableData: CachableData<Weather> = UserDefaults.get(for: .current(city: cityName)) {
            return cachableData.date
        }else {
            return nil
        }
    }
    
    func isCityCacheValid(for city: City) -> Bool {
        if let _: Weather = loadData(for: city, dataType: .current, forceCache: false) {
            return true
        }
        return false
    }
    
    func getDefaultOrCachedWeatherData(for city: City = CityAgent.getMainCity()) -> WeatherData {
        let cachedWeatherDataAndRemainingParameters =  getCachedWeatherDataAndRemainingParameters(for: city, parameters: WeatherRequestItem.allCases, forceCache: true)
        var cachedWeatherData = cachedWeatherDataAndRemainingParameters.cachedWeatherData
        let remainingParameters = cachedWeatherDataAndRemainingParameters.remainingParameters
        
        cachedWeatherData.executeAdditional()
        
        let sampleArray = [Weather(), Weather(), Weather(), Weather(), Weather(), Weather(), Weather(), Weather(), Weather(), Weather(), Weather()]
        if (remainingParameters.contains(.current)) {
            cachedWeatherData.today = Weather()
        }
        if (cachedWeatherData.hourlyForecast.count < 12) {
            cachedWeatherData.hourlyForecast = sampleArray
        }
        if (cachedWeatherData.dailyForecast.count < 6) {
            cachedWeatherData.dailyForecast = sampleArray
        }
        
        cachedWeatherData.location = city
        return cachedWeatherData
    }
    
    private func getCachedWeatherDataAndRemainingParameters(for city: City, parameters: [WeatherRequestItem], forceCache: Bool = false) -> (cachedWeatherData: WeatherData, remainingParameters: [WeatherRequestItem]) {
        
        var remainingParameters = parameters
        
        var cachedWeatherData = loadData(for: city, dataType: .baseWeatherData, forceCache: true) ?? WeatherData()
        cachedWeatherData.location = city
        
        if parameters.contains(.current) {
            if let cachedWeather: Weather = loadData(for: city, dataType: .current, forceCache: forceCache) {
                cachedWeatherData.today = cachedWeather
                remainingParameters = remainingParameters.filter({$0 != .current})
            }
        }
        
        if parameters.contains(.hourly) {
            if let cachedWeather: [Weather] = loadData(for: city, dataType: .hourly, forceCache: forceCache) {
                cachedWeatherData.hourlyForecast = cachedWeather
                remainingParameters = remainingParameters.filter({$0 != .hourly})
            }
        }
        
        if parameters.contains(.daily) {
            if let cachedWeather: [Weather] = loadData(for: city, dataType: .daily, forceCache: forceCache) {
                cachedWeatherData.dailyForecast = cachedWeather
                remainingParameters = remainingParameters.filter({$0 != .daily})
            }
        }
        
        if parameters.contains(.precipitation) {
            if let cachedPrecipitation: Precipitation = loadData(for: city, dataType: .precipitation, forceCache: forceCache) {
                cachedWeatherData.precipitation = cachedPrecipitation
                remainingParameters = remainingParameters.filter({$0 != .precipitation})
            }
        }
        
        if parameters.contains(.alerts) {
            if let cachedAlerts: [WeatherAlert] = loadData(for: city, dataType: .weatherAlerts, forceCache: forceCache) {
                cachedWeatherData.alerts = cachedAlerts
                remainingParameters = remainingParameters.filter({$0 != .alerts})
            }
        }
        return (cachedWeatherData, remainingParameters)
        
    }
    
    
    private func saveWeatherData(weatherData: WeatherData, for city: City, parameters: [WeatherRequestItem]) async {
        
        saveBaseWeatherData(city: city, weatherData: weatherData)
        
        for parameter in parameters {
            switch parameter {
            case .current:
                cacheData(for: city, data: weatherData.today, dataType: .current)
            case .precipitation:
                cacheData(for: city, data: weatherData.precipitation, dataType: .precipitation)
            case .hourly:
                cacheData(for: city, data: weatherData.hourlyForecast, dataType: .hourly)
            case .daily:
                cacheData(for: city, data: weatherData.dailyForecast, dataType: .daily)
            case .alerts:
                cacheData(for: city, data: weatherData.alerts, dataType: .weatherAlerts)
            }
        }
    }
    
    private func saveBaseWeatherData(city: City, weatherData: WeatherData) {
        var baseWeatherData = WeatherData()
        baseWeatherData.timezone = weatherData.timezone
        cacheData(for: city, data: baseWeatherData, dataType: .baseWeatherData)
    }
    
    
    private func getCachedAQIData(for city: City, parameters: [AQIRequestItem], forceCache: Bool = false) async -> (cachedAQIData: AQIData, remainingParameters: [AQIRequestItem]) {
        
        var newParameters = parameters
        var aqiData = AQIData()
        aqiData.location = city
        
        if parameters.contains(.current) {
            if let cachedWeather: AQI = loadData(for: city, dataType: .aqiCurrent, forceCache: forceCache) {
                aqiData.current = cachedWeather
                newParameters = newParameters.filter({$0 != .current})
            }
        }
        
        if parameters.contains(.hourly) {
            if let cachedWeather: [AQI] = loadData(for: city, dataType: .aqiHourly, forceCache: forceCache) {
                aqiData.hourlyForecast = cachedWeather
                newParameters = newParameters.filter({$0 != .hourly})
            }
        }
        
        if parameters.contains(.daily) {
            if let cachedWeather: [AQI] = loadData(for: city, dataType: .aqiDaily, forceCache: forceCache) {
                aqiData.dailyForecast = cachedWeather
                newParameters = newParameters.filter({$0 != .daily})
            }
        }

        return (aqiData, newParameters)
        
    }
    
    
    private func saveAQIData(aqiData: AQIData, for city: City, parameters: [AQIRequestItem]) async {
        for parameter in parameters {
            switch parameter {
            case .current:
                cacheData(for: city, data: aqiData.current, dataType: .aqiCurrent)
            case .hourly:
                cacheData(for: city, data: aqiData.hourlyForecast, dataType: .aqiHourly)
            case .daily:
                cacheData(for: city, data: aqiData.dailyForecast, dataType: .aqiDaily)
            }
        }
    }
    
    
    private func cacheData<T: Codable>(for city: City = City(), data: T, dataType: CachableDataType) {
        
        let cachedData = CachableData(data: data, dataType: dataType)
        let cityName = city.placeMarkCityName.replacingOccurrences(of: " ", with: "")
        
        switch dataType {
        case .mutipleCitiesWeatherData:
            FileManager.save(value: cachedData, for: .mutipleCitiesWeatherData)
        case .baseWeatherData:
            FileManager.save(value: cachedData, for: .baseWeatherData(city: cityName))
        case .current:
            FileManager.save(value: cachedData, for: .current(city: cityName))
        case .hourly:
            FileManager.save(value: cachedData, for: .hourly(city: cityName))
        case .daily:
            FileManager.save(value: cachedData, for: .daily(city: cityName))
        case .aqiCurrent:
            FileManager.save(value: cachedData, for: .aqiCurrent(city: cityName))
        case .aqiHourly:
            FileManager.save(value: cachedData, for: .aqiHourly(city: cityName))
        case .aqiDaily:
            FileManager.save(value: cachedData, for: .aqiDaily(city: cityName))
        case .precipitation:
            FileManager.save(value: cachedData, for: .precipitation(city: cityName))
        case .climate:
            FileManager.save(value: cachedData, for: .climate(city: cityName))
        case .weatherAlerts:
            FileManager.save(value: cachedData, for: .weatherAlert(city: cityName))
        case .newLocation:
            UserDefaults.save(value: cachedData, for: .newLocation)
        case .premiumStatus:
            UserDefaults.save(value: cachedData, for: .premium)
        }
    }
    
    
    private func loadData<T: Codable>(for city: City = City(), dataType: CachableDataType, forceCache : Bool = false) -> T? {
        let cityName = city.placeMarkCityName.replacingOccurrences(of: " ", with: "")
        switch dataType {
        case .baseWeatherData:
            if let cachableData: CachableData<WeatherData> = FileManager.get(for: .baseWeatherData(city: cityName)) {
                return cachableData.data as? T
            }
        case .current:
            if let cachableData: CachableData<Weather> = FileManager.get(for: .current(city: cityName)),
               (forceCache || cachableData.isValid) {
                return cachableData.data as? T
            }
        case .hourly:
            if let cachableData: CachableData<[Weather]> = FileManager.get(for: .hourly(city: cityName)),
               (forceCache || cachableData.isValid) {
                return cachableData.data as? T
            }
        case .daily:
            if let cachableData: CachableData<[Weather]> = FileManager.get(for: .daily(city: cityName)),
               (forceCache || cachableData.isValid) {
                return cachableData.data as? T
            }
        case .aqiCurrent:
            if let cachableData: CachableData<AQI> = FileManager.get(for: .aqiCurrent(city: cityName)),
               (forceCache || cachableData.isValid) {
                return cachableData.data as? T
            }
        case .aqiHourly:
            if let cachableData: CachableData<[AQI]> = FileManager.get(for: .aqiHourly(city: cityName)),
               (forceCache || cachableData.isValid) {
                return cachableData.data as? T
            }
        case .aqiDaily:
            if let cachableData: CachableData<[AQI]> = FileManager.get(for: .aqiDaily(city: cityName)),
               (forceCache || cachableData.isValid) {
                return cachableData.data as? T
            }
        case .precipitation:
            if let cachableData: CachableData<Precipitation> = FileManager.get(for: .precipitation(city: cityName)),
               (forceCache || cachableData.isValid) {
                return cachableData.data as? T
            }
        case .climate:
            if let cachableData: CachableData<ClimateData> = FileManager.get(for: .climate(city: cityName)),
               (forceCache || cachableData.isValid) {
                return cachableData.data as? T
            }
        case .weatherAlerts:
            if let cachableData: CachableData<[WeatherAlert]> = FileManager.get(for: .weatherAlert(city: cityName)),
               (forceCache || cachableData.isValid) {
                return cachableData.data as? T
            }
        case .mutipleCitiesWeatherData:
            if let cachableData: CachableData<[WeatherData]> = FileManager.get(for: .mutipleCitiesWeatherData),
               (forceCache || cachableData.isValid) {
                return cachableData.data as? T
            }
        case .newLocation:
            if let cachableData: CachableData<City> = UserDefaults.get(for: .newLocation),
               (forceCache || cachableData.isValid) {
                return cachableData.data as? T
            }
        case .premiumStatus:
            if let cachableData: CachableData<Premium> = UserDefaults.get(for: .premium),
               (forceCache || cachableData.isValid) {
                return cachableData.data as? T
            }
        }
        return nil
    }
}
