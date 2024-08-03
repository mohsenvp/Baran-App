//
//  NetworkManager.swift
//  NeonWeather
//
//  Created by RezaRg on 7/13/20.
//

import Alamofire
import SwiftyJSON
import Foundation
#if os(iOS) || os(macOS)
import UIKit.UIDevice
#elseif os(watchOS)
import WatchKit
#endif

class NetworkManager: ObservableObject {
    
    static private(set) var shared: NetworkManager = NetworkManager()
    
    static func reset() {
        shared = NetworkManager()
    }
    
    
    private let key = "dde717bc4fd78bbbd98ccc7d8516ba79"
    private let iv = "1234567890123456"
    
    private var server : String = "https://v2.heyweatherapp.com/"
    private var baseAPI : String = "https://v2.heyweatherapp.com/api/"
    
    private var headers : HTTPHeaders = [
        "User-Agent" : NetworkManager.createUserAgent()
    ]
    
    
    func getWeather(city: City, weatherData newWeatherData: WeatherData, requestItems: [WeatherRequestItem], requestOrigin: WeatherRequestOrigin) async throws -> WeatherData {
        
        if requestItems.isEmpty {
            return newWeatherData
        }
        
        let url = baseAPI + "weather"
        let parameters = [
            "lat" : city.location.lat,
            "lng" : city.location.long,
            "request_origin" : requestOrigin.rawValue,
            "timezone" : TimeZone.current.identifier,
            "include" : requestItems.map({$0.rawValue}).joined(separator: ","),
        ] as [String : Any]
        
        let responseData = try await postByAlamofire(url, parameters: parameters)
        let encStr = JSON(responseData)["data"].string
        let decStr = encStr!.aesDecrypt(key: self.key, iv: self.iv)
        let json = try JSON(data : decStr.data(using: String.Encoding.utf8, allowLossyConversion: false)!)
        var weatherData = newWeatherData
        
        for requestItem in requestItems {
            switch requestItem {
            case .current:
                weatherData.setItem(json: json, for: city, item: .current)
            case .precipitation:
                weatherData.setItem(json: json, for: city, item: .precipitation)
            case .hourly:
                weatherData.setItem(json: json, for: city, item: .hourly)
            case .daily:
                weatherData.setItem(json: json, for: city, item: .daily)
            case .alerts:
                weatherData.setItem(json: json, for: city, item: .alerts)
            }
        }
        return weatherData
    }
    
    
    func getMultipleCitiesWeather(cities: [City]) async throws -> [WeatherData] {
        
        let url = baseAPI + "current/multiple"
        let ids: [String] = cities.filter({!$0.isCurrentLocation}).map({String($0.id)})

        var parameters = [
            "city_ids" : ids.joined(separator: ",")
        ] as [String : Any]
        
        if let locationCityItem: City = cities.first(where: {$0.isCurrentLocation}) {
            parameters.updateValue("\(locationCityItem.location.lat),\(locationCityItem.location.long)", forKey: "current_location")
        }
        
        let responseData = try await postByAlamofire(url, parameters: parameters)
        let encStr = JSON(responseData)["data"].string
        let decStr = encStr!.aesDecrypt(key: self.key, iv: self.iv)
        let json = try JSON(data : decStr.data(using: String.Encoding.utf8, allowLossyConversion: false)!)
        var weatherDatas: [WeatherData] = []
        
        for i in 0..<cities.count {
            for j in 0..<json.count {
                if json[j]["city_id"].intValue == cities[i].id {
                    var weatherData = Repository().getDefaultOrCachedWeatherData(for: cities[i])
                    weatherData.setItem(json: json[j], for: cities[i], item: .current)
                    weatherDatas.append(weatherData)
                }
            }
        }
        return weatherDatas
    }
    
    func getWeatherHistory(city: City, timestamp: String) async throws -> Weather {
        
        let url = baseAPI + "weather/history"
        let parameters = [
            "lat" : city.location.lat,
            "lng" : city.location.long,
            "timestamp" : timestamp,
        ] as [String : Any]
        
        let responseData = try await postByAlamofire(url, parameters: parameters)
        let encStr = JSON(responseData)["data"].string
        let decStr = encStr!.aesDecrypt(key: self.key, iv: self.iv)
        let json = try JSON(data : decStr.data(using: String.Encoding.utf8, allowLossyConversion: false)!)
        
        return Weather(from: json, timezone: .current)
        
    }
    
    
    
    func getAQI(city: City, aqiData newAQIData: AQIData, requestItems: [AQIRequestItem], requestOrigin: WeatherRequestOrigin) async throws -> AQIData {
        
        let url = baseAPI + "new-aqi"
        let parameters = [
            "lat" : city.location.lat,
            "lng" : city.location.long,
            "request_origin" : requestOrigin.rawValue,
            "timezone" : TimeZone.current.identifier,
            "include" : requestItems.map({$0.rawValue}).joined(separator: ","),
        ] as [String : Any]
        
        let responseData = try await postByAlamofire(url, parameters: parameters)
        let encStr = JSON(responseData)["data"].string
        let decStr = encStr!.aesDecrypt(key: self.key, iv: self.iv)
        let json = try JSON(data : decStr.data(using: String.Encoding.utf8, allowLossyConversion: false)!)
        var aqiData = newAQIData
        for requestItem in requestItems {
            switch requestItem {
            case .current:
                aqiData.setItem(json: json, for: city, item: .current)
            case .hourly:
                aqiData.setItem(json: json, for: city, item: .hourly)
            case .daily:
                aqiData.setItem(json: json, for: city, item: .daily)
            }
        }
        return aqiData
    }
    
    
    func getCities(q: String) async throws -> [City] {
        let url = baseAPI + "cities"
        
        let responseData = try await postByAlamofire(url, parameters: ["query": q])
        
        let json = JSON(responseData)["data"]
        var cities = [City]()
        
        (0..<json.count).forEach { i in
            cities.append(City(json: json[i]))
        }
        
        return cities
        
    }
    
    func sendNotificationToken(notificationToken: String) async throws -> Bool {
        var parameters: [String : Any] = .init()
        parameters["notification_token"] = notificationToken
        
        let url = baseAPI + "devices/save-notification-token"
        _ = try await postByAlamofire(url, parameters: parameters)
        return true
    }
    
    func sendLiveActivityToken(liveActivityToken: String, city: City, end: Bool) async throws -> Bool {
        var parameters: [String : Any] = .init()
        parameters["token"] = liveActivityToken
        parameters["lat"] = city.location.lat
        parameters["lng"] = city.location.long
        
        let url = baseAPI + "live-precip" + (end ? "/end" : "")
        _ = try await postByAlamofire(url, parameters: parameters)
        return true
    }
    
    func changeWeatherDataSource() async throws -> Bool {
        var parameters: [String : Any] = .init()
        
        parameters = [
            "source_id" : DataSourceAgent.getCurrentWeatherDataSource().id,
            "type" : "weather"
        ]
        
        let url = baseAPI + "devices/set-source"
        _ = try await postByAlamofire(url, parameters: parameters)
        return true
    }
    
    func changeAQIDataSource() async throws -> Bool {
        var parameters: [String : Any] = .init()
        
        parameters = [
            "source_id" : DataSourceAgent.getCurrentAQIDataSource().id,
            "type" : "aqi"
        ]
        let url = baseAPI + "devices/set-source"
        _ = try await postByAlamofire(url, parameters: parameters)
        return true
    }
    
    func getClimate(city: City) async throws -> ClimateData {
        
        let parameters = [
            "lat" : city.location.lat,
            "lng" : city.location.long
        ]
        let url = baseAPI + "climate"
        
        let responseData = try await postByAlamofire(url, parameters: parameters)
        let encStr = JSON(responseData)["data"].string
        let decStr = encStr!.aesDecrypt(key: self.key, iv: self.iv)
        let json = try JSON(data : decStr.data(using: String.Encoding.utf8, allowLossyConversion: false)!)
        return ClimateData(json: json, city: city)
    }
    
    func getIAPPlans(completion: @escaping ([AppPlan]) -> Void, failResponseCompletion: @escaping (NetworkFailResponse) -> ()) {
        let url = baseAPI + "products"
        var plans = [AppPlan]()
        oldGetByAlamofire(url) { responseData in
            let json = JSON(responseData)["data"]
            (0..<json.count).forEach { i in
                plans.append(AppPlan(json: json[i]))
            }
            completion(plans)
        } failResponseCompletion: { response in failResponseCompletion(response) }
    }
    
    func getDataSources() async throws -> FullDataSource {
        let url = baseAPI + "sources/full"
        var weatherDataSources = [WeatherDataSource]()
        var aqiDataSources = [AQIDataSource]()
        let responseData = try await getByAlamofire(url)
        let encStr = JSON(responseData)["data"].string
        let decStr = encStr!.aesDecrypt(key: self.key, iv: self.iv)
        let json = try JSON(data : decStr.data(using: String.Encoding.utf8, allowLossyConversion: false)!)
        (0..<json.count).forEach { i in
            let sources = json[i]["sources"]
            if json[i]["type"] == "weather" {
                (0..<sources.count).forEach { j in
                    weatherDataSources.append(WeatherDataSource(json: sources[j]))
                }
            }
            if json[i]["type"] == "aqi" {
                (0..<sources.count).forEach { j in
                    aqiDataSources.append(AQIDataSource(json: sources[j]))
                }
            }
        }
        let fullDataSource = FullDataSource(aqiDataSource: aqiDataSources, weatherDataSource: weatherDataSources)
        return fullDataSource
    }
    
    
    func checkPremiumStatus(verifyReceipt : Bool, token: String) async throws -> Premium {
        
        let parameters = [
            "type" : verifyReceipt ? "verify" : "status",
            "token" : token,
            "market" : "appstore",
            "debug" : Bundle.main.appStoreReceiptURL?.lastPathComponent == "sandboxReceipt" ? 1 : 0,
            "timezone": TimeZone.current.identifier
        ] as [String : Any]
        
        let url = baseAPI + "verify-purchase"
        
        let responseData = try await postByAlamofire(url, parameters: parameters)
        let json = JSON(responseData)["data"]
        return Premium(json: json)
        
    }
    
    func getMapData() async throws -> MapData {
        let url = baseAPI + "map/layers"
        let responseData = try await getByAlamofire(url)
        let json = JSON(responseData)["data"]
        let mapData = MapData(json: json)
        return mapData
    }
    
    func getMapTileURL(style: MapStyle, layer: MapLayer, x: UInt, y: UInt, z: UInt, timestamp: Date?, isPremium: Bool, completion: @escaping (URL) -> Void) {
        
        let currentTimestamp = Date().timeIntervalSince1970
        let token = NetworkManager.getServerToken() ?? ""
        let opacity = style == .dark ? layer.opacityDark : layer.opacityLight
        var raw = "\(token);\(currentTimestamp);\(x);\(y);\(z);\(layer.key);\(opacity)"
        
        if !layer.isPlayLocked || (layer.isPlayLocked && isPremium) {
            if let ts = timestamp{
                raw += ";\(ts.timeIntervalSince1970)"
            }
        }
        do {
            let data = try raw.aesEncrypt(key: key, iv: iv)
            let urlString = server + "map/tile?data=" + data.addingPercentEncoding(withAllowedCharacters: .afURLQueryAllowed)!
            
            if let url = URL.init(string: urlString) {
                completion(url)
            }
        }catch {
        }
        
    }
    
    func getMapStyle(style: MapStyle) async throws -> String {
        
        let url = style == .dark ? Constants.darkMapStyleURL : Constants.lightMapStyleURL
        let style = try await getFileContentByAlamofire(url)
        return style
    }
    
    
    func authorizeDevice() async throws {
        let url = baseAPI + "get-auth"
        let parameters = [
            "device_id" : NetworkManager.getDeviceId(),
            "user_uid" : NetworkManager.getDeviceId()
        ] as [String : Any]
        _ = try await postByAlamofire(url, parameters: parameters)
    }
    
    func postUserConfig(json: JSON) async throws {
        let url = baseAPI + "devices/configs"
        _ = try await postJsonByAlamofire(url, json: json)
    }
    
    init() {
        if let token = NetworkManager.getServerToken() {
            self.headers["Authorization"] = "Bearer \(token)"
        }
    }
    
}

// MARK: Static & Private Functions
extension NetworkManager {
    static func getDeviceModel() -> String {
        if let simulatorModelIdentifier = ProcessInfo().environment["SIMULATOR_MODEL_IDENTIFIER"] { return simulatorModelIdentifier }
        var sysinfo = utsname()
        uname(&sysinfo) // ignore return value
        return String(bytes: Data(bytes: &sysinfo.machine, count: Int(_SYS_NAMELEN)), encoding: .ascii)!.trimmingCharacters(in: .controlCharacters)
    }
    
    static func createUserAgent() -> String {
        var systemVersion = ""
        var deviceModel = ""
        
#if os(watchOS)
        guard let savedUserAgent: String = UserDefaults.get(for: .userAgent) else {
            return ""
        }
        return savedUserAgent
#else
        systemVersion = UIDevice.current.systemVersion
        deviceModel = UIDevice.current.model
#endif
        let langStr = LocalizeHelper().currentLanguage.toServerName
        let regionCode = Locale.current.region?.identifier ?? "n/a"
        let versionCode = Bundle.main.infoDictionary!["CFBundleVersion"] as! String
        let userAgent = "HeyWeather \(versionCode) (iOS; \(systemVersion); \(deviceModel); \(getDeviceModel()); \(regionCode); \(getDeviceId()); \(langStr))"
        UserDefaults.save(value: userAgent, for: .userAgent)
        return userAgent
    }
    
    static func getDeviceId() -> String {
        return getUniqDeviceId()
    }
    
    static func getServerToken() -> String? {
        return "\(getDeviceId())7f8a36d4181260ae1c38980bc00eb7fd".md5()
    }
    
    private func getFailResponse(for statusCode: Int) -> NetworkFailResponse {
        switch statusCode {
        case 304:
            return .notModified
        case 400, 422:
            return .badRequest
        case 401:
            return .unauthorized
        case 403:
            return .forbidden
        case 404:
            return .notFound
        case 409:
            return .conflict
        case 500:
            return .internalServer
        default:
            return .unknown
        }
    }
    
    private func getFileContentByAlamofire(_ url: String) async throws -> String {
        return await AF.request(url, headers: headers).serializingString().response.value ?? ""
    }
    
    
    
    private func oldGetByAlamofire(_ url: String, completion: @escaping (([String: Any]) -> Void), failResponseCompletion: @escaping (NetworkFailResponse) -> Void) {
        AF.request(url, headers: headers)
            .responseJSON{ response in
                DispatchQueue.main.async {
                    guard let rawResponse = response.value as? [[String: Any]] else {
                        guard let rawResponse = response.value as? [String: Any] else {
                            guard let statusCode = response.response?.statusCode else {
                                failResponseCompletion(.noInternet)
                                return
                            }
                            let failResponse = self.getFailResponse(for: statusCode)
                            failResponseCompletion(failResponse)
                            EventLogger.logFailResponse(failResponse: failResponse)
                            return
                        }
                        completion(rawResponse)
                        return
                    }
                    completion(["data": rawResponse])
                }
            }
    }
    
    
    private func getByAlamofire(_ url: String) async throws -> [String: Any] {
        let response = await AF.request(url, headers: headers).serializingString().response
        switch response.result {
        case .success:
            
            if let rawResponse = response.value  {
                if let data = rawResponse.data(using: .utf8) {
                    do {
                        return try JSONSerialization.jsonObject(with: data, options: []) as! [String: Any]
                    } catch {
                        fatalError(error.localizedDescription)
                    }
                }
            }
        case .failure:
            guard let statusCode = response.response?.statusCode else {
                throw NetworkFailResponse.noInternet
            }
            let failResponse = self.getFailResponse(for: statusCode)
            EventLogger.logFailResponse(failResponse: failResponse)
            throw failResponse
        }
        return [:]
    }
    
    private func postByAlamofire(_ url: String, parameters: Parameters) async throws -> [String: Any] {
        let response = await AF.request(url, method: .post, parameters: parameters, headers: headers).serializingString().response
        
        guard let statusCode = response.response?.statusCode else {
            throw NetworkFailResponse.noInternet
        }
        
        if statusCode != 200 {
            let failResponse = self.getFailResponse(for: statusCode)
            EventLogger.logFailResponse(failResponse: failResponse)
            throw failResponse
        }
        
        if let rawResponse = response.value  {
            if let data = rawResponse.data(using: .utf8) {
                do {
                    return try JSONSerialization.jsonObject(with: data, options: []) as! [String: Any]
                } catch {
                    throw NetworkFailResponse.internalServer
                }
            }
        }
        
        return [:]
    }
    
    private func postJsonByAlamofire(_ url: String ,json: JSON) async throws -> [String: Any] {
        
        var header = self.headers
        var request = URLRequest(url: URL(string: url)!)
        
        header["Content-Type"] = "application/json"
        
        request.httpMethod = HTTPMethod.post.rawValue
        request.headers = header
        do {
            request.httpBody = try json.rawData()
        } catch {
            print(error)
        }
        
        let response = await AF.request(request).serializingString().response
        guard let statusCode = response.response?.statusCode else {
            throw NetworkFailResponse.noInternet
        }
        
        if statusCode != 200 {
            let failResponse = self.getFailResponse(for: statusCode)
            EventLogger.logFailResponse(failResponse: failResponse)
            throw failResponse
        }
        if let rawResponse = response.value  {
            if let data = rawResponse.data(using: .utf8) {
                do {
                    return try JSONSerialization.jsonObject(with: data, options: []) as! [String: Any]
                } catch {
                    throw NetworkFailResponse.internalServer
                }
            }
        }
        return [:]
    }
    
}
