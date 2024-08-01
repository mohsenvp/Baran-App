//
//  Location.swift
//  WeatherApp
//
//  Created by RezaRg on 7/28/20.
//

import Foundation
import SwiftyJSON

struct Location : Codable, Hashable {
    var lat : Double
    var long : Double
    
    init () {
        lat = 48.85
        long = 2.35
    }
    
    init (lat : Double, long: Double) {
        self.lat = lat.maxFractionDigit(to: 3)
        self.long = long.maxFractionDigit(to: 3)
    }
    
    init (json : JSON) {
        self.lat = json["lat"].doubleValue.maxFractionDigit(to: 3)
        
        ///this is used for encoding the same class as json (watchos)
        self.long = json["long"].exists() ? json["long"].doubleValue.maxFractionDigit(to: 3) : json["lon"].doubleValue.maxFractionDigit(to: 3)
    }
}
