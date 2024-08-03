//
//  Precipitation.swift
//  HeyWeather
//
//  Created by Kamyar on 9/18/21.
//

import Foundation
import SwiftyJSON

struct Precipitation: Codable, Hashable {
    var id = UUID()
    var description: String
    var chartData: [PrecipitationChartData]
    
    init(json: JSON) {
        self.description = json["description"].stringValue
        
        let forecastsJson = json["forecast"].arrayValue
        self.chartData = [PrecipitationChartData]()
        (forecastsJson).forEach { chartDataJson in
            self.chartData.append(
                PrecipitationChartData(json: chartDataJson)
            )
        }
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
        hasher.combine(description)
    }
    
    
    // Test init
    init() {
        self.description = "Rainy weather till ..."
        self.chartData = []
    }
    
}

