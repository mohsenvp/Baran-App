//
//  DataSource.swift
//  HeyWeather
//
//  Created by Mohammad Yeganeh on 5/8/23.
//

import Foundation
import SwiftyJSON


struct WeatherDataSource: Codable, Identifiable, Equatable {
    var id: Int
    var title: String
    var icon: String
    var premium: Bool
    var code: String
    var selected: Bool

    init(json: JSON) {
        self.id = json["id"].intValue
        self.title = json["title"].stringValue
        self.icon = Constants.imagesURL.appending(json["icon"].stringValue)
        self.premium = json["premium"].boolValue
        self.selected = json["selected"].boolValue
        self.code = json["code"].stringValue
    }
    
    
    init() {
        self.id = -1
        self.title = "OpenWeather"
        self.icon = "https://v2.heyweatherapp.com/images/".appending("logos/openweather.png")
        self.premium = false
        self.code = "openweather"
        self.selected = true
    }
}
