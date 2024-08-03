//
//  Connectivity.swift
//  HeyWeather
//
//  Created by Mohammad Yeganeh on 8/9/23.
//

import Foundation
import WatchConnectivity
import SwiftyJSON
import WidgetKit

final class Connectivity: NSObject, ObservableObject {

    static let shared = Connectivity()
    
    private override init() {
        super.init()
        
        #if !os(watchOS)
        guard WCSession.isSupported() else {
            return
        }
        #endif
        
        WCSession.default.delegate = self
        
        WCSession.default.activate()
    }
    
    public func send(
        premium: Premium,
        mainCity: City,
        cities: [City],
        userAgent: String,
        uniqueId: String,
        tempUnit: String,
        speedUnit: String,
        distanceUnit: String,
        pressureUnit: String,
        precipitationUnit: String,
        currentWeatherDataSource: WeatherDataSource,
        currentAQIDataSource: AQIDataSource,
        timeFormat: String,
        currentLanguage: String,
        replyHandler: (([String: Any]) -> Void)? = nil,
                     errorHandler: ((Error) -> Void)? = nil
    ) {
        guard WCSession.default.activationState == .activated else {
            return
        }
        
        #if os(watchOS)
        guard WCSession.default.isCompanionAppInstalled else { // THe Apple Watch checks if the app is on the phone.
            return
        }
        #else
        guard WCSession.default.isWatchAppInstalled else { // The iOS deveice checks if the app is on the Apple Watch.
            return
        }
        #endif
        var userInfo: [String: Any] = [:]
       
        
        do {
            userInfo.updateValue(try String(data: JSONEncoder().encode(premium), encoding: .utf8) ?? "", forKey: ConnectivityUserInfoKey.premium.rawValue)
            userInfo.updateValue(try String(data: JSONEncoder().encode(mainCity), encoding: .utf8) ?? "", forKey: ConnectivityUserInfoKey.mainCity.rawValue)
            userInfo.updateValue(try String(data: JSONEncoder().encode(cities), encoding: .utf8) ?? "", forKey: ConnectivityUserInfoKey.cities.rawValue)
            userInfo.updateValue(try String(data: JSONEncoder().encode(currentWeatherDataSource), encoding: .utf8) ?? "", forKey: ConnectivityUserInfoKey.currentWeatherDataSource.rawValue)
            userInfo.updateValue(try String(data: JSONEncoder().encode(currentAQIDataSource), encoding: .utf8) ?? "", forKey: ConnectivityUserInfoKey.currentAQIDataSource.rawValue)
            userInfo.updateValue(userAgent, forKey: ConnectivityUserInfoKey.userAgent.rawValue)
            userInfo.updateValue(uniqueId, forKey: ConnectivityUserInfoKey.uniqueId.rawValue)
            userInfo.updateValue(tempUnit, forKey: ConnectivityUserInfoKey.tempUnit.rawValue)
            userInfo.updateValue(speedUnit, forKey: ConnectivityUserInfoKey.speedUnit.rawValue)
            userInfo.updateValue(distanceUnit, forKey: ConnectivityUserInfoKey.distanceUnit.rawValue)
            userInfo.updateValue(pressureUnit, forKey: ConnectivityUserInfoKey.pressureUnit.rawValue)
            userInfo.updateValue(timeFormat, forKey: ConnectivityUserInfoKey.timeFormat.rawValue)
            userInfo.updateValue(currentLanguage, forKey: ConnectivityUserInfoKey.currentLanguage.rawValue)
        }catch {
            print("json encode error")
        }
        
        do {
            try WCSession.default.updateApplicationContext(userInfo)
        } catch {
            errorHandler?(error)
        }
    }
    
    typealias OptionalHandler<T> = ((T) -> Void)?
    
    private func optionalMainQueueDispach<T>(
        handler: OptionalHandler<T>
    ) -> OptionalHandler<T> {
        guard let handler = handler else {
            return nil
        }
        
        return { item in
            DispatchQueue.main.async {
                handler(item)
            }
        }
    }
    
}

// MARK: - WCSessionDelegate
extension Connectivity: WCSessionDelegate {
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
    }
    
    #if os(iOS)
    func sessionDidBecomeInactive(_ session: WCSession) {
    }
    
    func sessionDidDeactivate(_ session: WCSession) {
        WCSession.default.activate()
    }
    
    #endif
    
    func session(_ session: WCSession, didReceiveUserInfo userInfo: [String: Any] = [:]) {
        update(from: userInfo)
    }
    
    func session(_ session: WCSession, didReceiveApplicationContext applicationContext: [String : Any]) {
        update(from: applicationContext)
    }
    
    func session(_ session: WCSession, didReceiveMessage message: [String: Any], replyHandler: @escaping ([String: Any]) -> Void) {
        update(from: message)
        replyHandler([:])
    }
    
    func session(_ session: WCSession, didReceiveMessage message: [String: Any]) {
        update(from: message)
    }
    
    private func update(from dictionary: [String: Any]) {
        
        //todo clean up

        if let premium = dictionary[ConnectivityUserInfoKey.premium.rawValue] as? String {
            let json = JSON(parseJSON: premium)
            let p = Premium(json: json)
            UserDefaults.save(value: p, for: .premium)
        }
        if let mainCity = dictionary[ConnectivityUserInfoKey.mainCity.rawValue] as? String {
            let json = JSON(parseJSON: mainCity)
            let city = City(json: json)
            UserDefaults.save(value: city, for: .mainCity)
        }
        if let currentWeatherDataSource = dictionary[ConnectivityUserInfoKey.currentWeatherDataSource.rawValue] as? String {
            let json = JSON(parseJSON: currentWeatherDataSource)
            let dataSource = WeatherDataSource(json: json)
            UserDefaults.save(value: dataSource, for: .currentWeatherDataSource)
        }
        if let currentAQIDataSource = dictionary[ConnectivityUserInfoKey.currentAQIDataSource.rawValue] as? String {
            let json = JSON(parseJSON: currentAQIDataSource)
            let dataSource = AQIDataSource(json: json)
            UserDefaults.save(value: dataSource, for: .currentAQIDataSource)
        }
        if let cities = dictionary[ConnectivityUserInfoKey.cities.rawValue] as? String {
            let json = JSON(parseJSON: cities)
            var cityArray: [City] = []
            (0..<json.count).forEach { i in
                cityArray.append(City(json: json[i]))
            }
            UserDefaults.save(value: cityArray, for: .cities)
        }
        if let userAgent = dictionary[ConnectivityUserInfoKey.userAgent.rawValue] as? String {
            UserDefaults.save(value: userAgent, for: .userAgent)
        }
        if let uniqueId = dictionary[ConnectivityUserInfoKey.uniqueId.rawValue] as? String {
            UserDefaults.save(value: uniqueId, for: .uniqueId)
        }
        if let tempUnit = dictionary[ConnectivityUserInfoKey.tempUnit.rawValue] as? String {
            UserDefaults.save(value: tempUnit, for: .tempUnit)
        }
        if let speedUnit = dictionary[ConnectivityUserInfoKey.speedUnit.rawValue] as? String {
            UserDefaults.save(value: speedUnit, for: .speedUnit)
        }
        if let distanceUnit = dictionary[ConnectivityUserInfoKey.distanceUnit.rawValue] as? String {
            UserDefaults.save(value: distanceUnit, for: .distanceUnit)
        }
        if let pressureUnit = dictionary[ConnectivityUserInfoKey.pressureUnit.rawValue] as? String {
            UserDefaults.save(value: pressureUnit, for: .pressureUnit)
        }
        if let precipitationUnit = dictionary[ConnectivityUserInfoKey.precipitationUnit.rawValue] as? String {
            UserDefaults.save(value: precipitationUnit, for: .precipitationUnit)
        }
        if let timeFormat = dictionary[ConnectivityUserInfoKey.timeFormat.rawValue] as? String {
            UserDefaults.save(value: timeFormat, for: .timeFormat)
        }
        if let currentLanguage = dictionary[ConnectivityUserInfoKey.currentLanguage.rawValue] as? String {
            LocalizeHelper.shared.setLanguage(language: AppLanguage(rawValue: currentLanguage))
        }
        #if os(watchOS)
        DispatchQueue.main.async {
            WatchState.shared.shouldReload.toggle()
            WidgetCenter.shared.reloadAllTimelines()
        }
        #endif
      
    }
    
}


enum ConnectivityUserInfoKey: String {
    case premium
    case mainCity
    case cities
    case userAgent
    case uniqueId
    case tempUnit
    case speedUnit
    case distanceUnit
    case pressureUnit
    case precipitationUnit
    case currentWeatherDataSource
    case currentAQIDataSource
    case timeFormat
    case currentLanguage
}
