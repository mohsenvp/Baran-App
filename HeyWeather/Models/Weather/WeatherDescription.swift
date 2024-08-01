//
//  WeatherDescription.swift
//  HeyWeather
//
//  Created by Kamyar on 12/5/21.
//

import Foundation
import SwiftyJSON

struct WeatherDescription: Codable {
    var icon: String
    var shortDescription: String
    var longDescription: String
    
    var isAvailable: Bool {
        return !icon.isEmpty && !shortDescription.isEmpty && !longDescription.isEmpty
    }

    init(from json: JSON) {
        self.icon = json["icon"].string ?? ""
        self.shortDescription = json["short"].string?.capitalized ?? ""
        self.longDescription = json["long"].string ?? ""
    }
    
    // MARK: Test Init
    init() {
        self.icon = ""
        self.shortDescription = "High Intensity Rain"
        self.longDescription = ""
    }
}
