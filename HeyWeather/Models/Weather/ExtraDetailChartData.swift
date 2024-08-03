//
//  ExtraDetailChartData.swift
//  HeyWeather
//
//  Created by MYeganeh on 4/10/23.
//


import Foundation

class ExtraDetailChartData: Codable {
    var value: Double
    var xAxisLabel : String
    
    init(value: Double, xAxisLabel: String) {
        self.value = value
        self.xAxisLabel = xAxisLabel
    }
   
}
