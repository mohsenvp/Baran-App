//
//  Climate.swift
//  HeyWeather
//
//  Created by RezaRg on 9/27/20.
//

import Foundation
import SwiftyJSON

struct Climate : Codable, Equatable {
    
    var id: UUID = .init()
    var index: Int
    var minTemp : Double
    var meanTemp : Double
    var maxTemp: Double
    var sumSnowfall: Double
    var sumRainfall: Double
    var sumPrecipitation: Double
    var cloudyDays: Int
    var daytime: Double

    init (json : JSON) {
        self.index = json["index"].intValue
        self.minTemp = json["min_temp"].doubleValue
        self.meanTemp = json["mean_temp"].doubleValue
        self.maxTemp = json["max_temp"].doubleValue
        self.sumSnowfall = json["sum_snowfall"].doubleValue
        self.sumRainfall = json["sum_rainfall"].doubleValue
        self.sumPrecipitation = json["sum_precipitation"].doubleValue
        self.cloudyDays = json["cloudy_days"].intValue
        self.daytime = json["daytime"].doubleValue
    }
    
    init() {
        self.index = 1
        self.minTemp = 5
        self.maxTemp = 18
        self.meanTemp = 12
        self.sumSnowfall = 0
        self.sumRainfall = 0
        self.sumPrecipitation = 0
        self.cloudyDays = 0
        self.daytime = 0
    }
}
