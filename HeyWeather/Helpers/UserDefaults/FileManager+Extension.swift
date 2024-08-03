//
//  FileManager+Extension.swift
//  HeyWeather
//
//  Created by Reza Ranjbaran on 19/06/2023.
//

import Foundation

extension FileManager {
    

    static func save<T: Encodable>(value: T,for key: UserDefaultsKey) {
        let fileManager  = self.default.containerURL(forSecurityApplicationGroupIdentifier: Constants.appGroupBundleId)!
        let url = fileManager.appendingPathComponent(key.rawValue)
        do {
            let data = try JSONEncoder().encode(value)
            try data.write(to: url)
        } catch {
            print("FileManager Error the type could not convert to json.")
        }
    }

    static func get<T: Decodable>(for key: UserDefaultsKey) -> T? {
        if let encodedData: Data = FileManager.get(for: key.rawValue) {
            return try? JSONDecoder().decode(T.self, from: encodedData)
        }
        return nil
    }
    
    
    
    static func save(value: Data, for key: String) {
        let fileManager  = self.default.containerURL(forSecurityApplicationGroupIdentifier: Constants.appGroupBundleId)!
        let url = fileManager.appendingPathComponent(key)
        try! value.write(to: url)
    }
    
    
   
    static func get<T: Decodable>(for key: String) -> T? {
        let fileManager  = self.default.containerURL(forSecurityApplicationGroupIdentifier: Constants.appGroupBundleId)!
        let url = fileManager.appendingPathComponent(key)

        do {
            if T.self == String.self {
                let data = try Data(contentsOf: url)
                return String(data: data, encoding: .utf8)! as? T
            } else if T.self == Data.self {
                return try Data(contentsOf: url)  as? T
            }
        }catch {
        }
        return nil
    }
}
