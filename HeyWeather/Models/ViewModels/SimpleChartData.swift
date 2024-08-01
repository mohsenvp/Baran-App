//
//  SimpleChartData.swift
//  HeyWeather
//
//  Created by Mohammad Yeganeh on 9/10/23.
//

import Foundation
struct SimpleChartData: Hashable, Identifiable, Codable {
    var id: UUID = .init()
    var date: Date
    var value: Double
    var value2: Double?
    
    static func getMax(data: [SimpleChartData]) -> Double {
        return data.map({$0.value}).max() ?? 0
    }
}
