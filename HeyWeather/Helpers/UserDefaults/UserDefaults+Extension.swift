//
//  UserDefaults+Extension.swift
//  HeyWeather
//
//  Created by Kamyar on 10/10/21.
//

import Foundation

extension UserDefaults {
    
    static func save<T: Encodable>(value: T,for key: UserDefaultsKey) {
        let stringKey = key.rawValue
        let userDefaults = self.init(suiteName: Constants.appGroupBundleId)!
        if T.self == String.self {
            userDefaults.set(value as? String, forKey: stringKey)
        } else if T.self == Int.self {
            userDefaults.set(value as? Int, forKey: stringKey)
        } else if T.self == Double.self {
            userDefaults.set(value as? Double, forKey: stringKey)
        } else if T.self == Dictionary<String, Any>.self {
            userDefaults.set(value as? Dictionary<String, Any>, forKey: stringKey)
        }else {
            do {
                let data = try JSONEncoder().encode(value)
                userDefaults.set(data, forKey: stringKey)
            } catch {
                print("UserDefault Error the type could not convert to json.")
            }
        }
        userDefaults.synchronize()
    }
    
    static func get<T: Decodable>(for key: UserDefaultsKey) -> T? {
        let userDefaults = self.init(suiteName: Constants.appGroupBundleId)!
        let stringKey = key.rawValue
        if T.self == String.self {
            return userDefaults.string(forKey: stringKey) as? T
        } else if  T.self == Int.self {
            return userDefaults.integer(forKey: stringKey) as? T
        } else if T.self == Double.self {
            return userDefaults.double(forKey: stringKey) as? T
        } else if  T.self == Bool.self {
            return userDefaults.bool(forKey: stringKey) as? T
        } else if T.self == Dictionary<String, Any>.self {
            return userDefaults.dictionary(forKey: stringKey) as? T
        } else {
            if let encodedData = userDefaults.data(forKey: stringKey) {
                return try? JSONDecoder().decode(T.self, from: encodedData)
            }
        }
        return nil
    }
    
    static func getStandard<T: Decodable>(for key: UserDefaultsKey) -> T? {
        let userDefaults = UserDefaults.standard
        let stringKey = key.rawValue
        if T.self == String.self {
            return userDefaults.string(forKey: stringKey) as? T
        } else if  T.self == Int.self {
            return userDefaults.integer(forKey: stringKey) as? T
        } else if T.self == Double.self {
            return userDefaults.double(forKey: stringKey) as? T
        } else if  T.self == Bool.self {
            return userDefaults.bool(forKey: stringKey) as? T
        } else if T.self == Dictionary<String, Any>.self {
            return userDefaults.dictionary(forKey: stringKey) as? T
        } else {
            if let encodedData = userDefaults.data(forKey: stringKey) {
                return try? JSONDecoder().decode(T.self, from: encodedData)
            }
        }
        return nil
    }
    
    static func allKeys() -> [String] {
        let userDefaults = UserDefaults.init(suiteName: Constants.appGroupBundleId)!
        return Array(userDefaults.dictionaryRepresentation().keys)
    }
    
    static func keyExists(for key: UserDefaultsKey) -> Bool {
        let userDefaults = self.init(suiteName: Constants.appGroupBundleId)!
        let stringKey = key.rawValue
        
        return userDefaults.object(forKey: stringKey) != nil
    }
    
    static func removeData(for key: UserDefaultsKey) {
        let stringKey = key.rawValue
        let userDefaults = self.init(suiteName: Constants.appGroupBundleId)!
        userDefaults.removeObject(forKey: stringKey)
    }
    
    static func removeData(for key: String) {
        let userDefaults = self.init(suiteName: Constants.appGroupBundleId)!
        userDefaults.removeObject(forKey: key)
    }
    
}
