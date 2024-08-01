//
//  Premium.swift
//  WeatherApp
//
//  Created by GCo iMac on 9/13/20.
//

import SwiftyJSON
import Foundation

class Premium: ObservableObject, Codable, Equatable {
    @Published var isPremium : Bool = false
    @Published var expireAt : String = "Jan 1, 1970"
    @Published var autoRenew : Bool = false
    @Published var expireAtTimestamp : Int64 = 1
    
    var isLifetime : Bool {
        get {
            if self.expireAt == "never" {
                return true
            }else {
                return false
            }
        }
    }
 
    init(json: JSON) {
        expireAt = json["expire_at_date"].string ?? ""
        autoRenew = json["auto_renew_status"].boolValue
        expireAtTimestamp = json["expire_at_timestamp"].int64 ?? 0
        if json["isPremium"].exists() {///this is used for encoding the same class as json (watchos)
            self.isPremium = json["isPremium"].boolValue
        }else {
            self.isPremium = json["is_premium"].boolValue
        }
    }
    init(isPremium : Bool = false) {
        self.isPremium = isPremium
    }
    
    func printPremium() {
        let a = """
            isPremium = \(isPremium.description)
            expireAt = \(expireAt.description)
            autoRenew = \(autoRenew.description)
            isLifetime = \(isLifetime)
            expireAtTimestamp = \(expireAtTimestamp.description)
            """
        print(a)
    }
    
    static func == (lhs: Premium, rhs: Premium) -> Bool {
        return lhs.expireAtTimestamp == rhs.expireAtTimestamp
    }
}
