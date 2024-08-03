//
//  KeyChainAccess.swift
//  WeatherApp
//
//  Created by RezaRg on 9/12/20.
//

import Foundation
import SwiftUI

class KeychainAccess {
    
    func addKeychainData(itemKey: String, itemValue: String) throws {
        guard let valueData = itemValue.data(using: .utf8) else {
            print("Keychain: Unable to store data, invalid input - key: \(itemKey), value: \(itemValue)")
            return
        }
        
        //delete old value if stored first
        do {
            try deleteKeychainData(itemKey: itemKey)
        } catch {
            print("Keychain: nothing to delete...")
        }
        
        let queryAdd: [String: AnyObject] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: itemKey as AnyObject,
            kSecValueData as String: valueData as AnyObject,
            kSecAttrAccessible as String: kSecAttrAccessibleWhenUnlocked
        ]
        let resultCode: OSStatus = SecItemAdd(queryAdd as CFDictionary, nil)
        
        if resultCode != 0 {
            print("Keychain: value not added - Error: \(resultCode)")
        } else {
            print("Keychain: value added successfully")
        }
    }
    
    func deleteKeychainData(itemKey: String) throws {
        let queryDelete: [String: AnyObject] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: itemKey as AnyObject
        ]
        
        let resultCodeDelete = SecItemDelete(queryDelete as CFDictionary)
        
        if resultCodeDelete != 0 {
            print("Keychain: unable to delete from keychain: \(resultCodeDelete)")
        } else {
            print("Keychain: successfully deleted item")
        }
    }
    
    func queryKeychainData (itemKey: String) throws -> String? {
        let queryLoad: [String: AnyObject] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: itemKey as AnyObject,
            kSecReturnData as String: kCFBooleanTrue,
            kSecMatchLimit as String: kSecMatchLimitOne
        ]
        var result: AnyObject?
        let resultCodeLoad = withUnsafeMutablePointer(to: &result) {
            SecItemCopyMatching(queryLoad as CFDictionary, UnsafeMutablePointer($0))
        }
        
        if resultCodeLoad != 0 {
            print("Keychain: unable to load data - \(resultCodeLoad)")
            return nil
        }
        
        guard let resultVal = result as? NSData, let keyValue = NSString(data: resultVal as Data, encoding: String.Encoding.utf8.rawValue) as String? else {
            print("Keychain: error parsing keychain result - \(resultCodeLoad)")
            return nil
        }
        return keyValue
    }
}

func getUniqDeviceId() -> String {
    #if os(watchOS)
    guard let uniqeId : String = UserDefaults.get(for: .uniqueId) else {
        return ""
    }
    return uniqeId
    #endif
    if let uniqeId : String = UserDefaults.get(for: .uniqueId) {
        return uniqeId
    }else {
        let uniqId = generateUniqDeviceId()
        UserDefaults.save(value: uniqId, for: .uniqueId)
        return uniqId
    }
}

func generateUniqDeviceId() -> String {
    
    let keychain = KeychainAccess()
    let uuidKey = "app.gco.WeatherApp.unique_uuid"
    
    if let uuid = try? keychain.queryKeychainData(itemKey: uuidKey) {
        return uuid
    }
    
    let newId = UUID().uuidString
    
    try? keychain.addKeychainData(itemKey: uuidKey, itemValue: newId)
    return newId
}
