//
//  TemperatureColor.swift
//  HeyWeather
//
//  Created by Mohammad Yeganeh on 9/12/23.
//

import SwiftUI

struct TemperatureColor: Hashable, Codable {
    
    var colorHex: String
    var value: Double
    
    static func getColors(temp: Double) -> [Color] {
        
        let values: [Double] = colors.map{$0.value}
        let colors: [String] = colors.map{$0.colorHex}

        let closest = values.enumerated().min( by: { abs($0.1 - temp) < abs($1.1 - temp) } )!
        let index = closest.offset
        var result: [Color] = []
        if index - 2 >= 0 {
            result.append(Color(hex: colors[index - 2]))
        }
        result.append(Color(hex: colors[index]))
        if index + 2 < colors.count {
            result.append(Color(hex: colors[index + 2]))
        }
        return result
    }
    
    
    static func getColors(min: Double, max: Double) -> [Color] {
        
        let values: [Double] = colors.map{$0.value}
        let colors: [String] = colors.map{$0.colorHex}
        let closestMin = values.enumerated().min( by: { abs($0.1 - min) < abs($1.1 - min) } )!
        let closestMax = values.enumerated().min( by: { abs($0.1 - max) < abs($1.1 - max) } )!

        var results: [Color] = []
        for i in closestMin.offset...closestMax.offset {
            results.append(Color(hex: colors[i]))
        }
        return results
    }
    
    static let colors: [TemperatureColor] = [
        .init(colorHex: "DE17EE", value: -17.8),
        .init(colorHex: "D017EE", value: -16.4),
        .init(colorHex: "CA18EE", value: -15.0),
        .init(colorHex: "C01AEF", value: -13.6),
        .init(colorHex: "B01BF0", value: -12.2),
        .init(colorHex: "991DF0", value: -10.8),
        .init(colorHex: "861FF0", value: -9.4),
        .init(colorHex: "681EE1", value: -8.1),
        .init(colorHex: "5C21F0", value: -6.7),
        .init(colorHex: "4A24E7", value: -5.3),
        .init(colorHex: "4227E3", value: -3.9),
        .init(colorHex: "3A29DD", value: -2.5),
        .init(colorHex: "2F2ED7", value: -1.1),
        .init(colorHex: "2633D1", value: 0.3),
        .init(colorHex: "2136CE", value: 1.7),
        .init(colorHex: "1D38CC", value: 3.1),
        .init(colorHex: "2145B3", value: 4.4),
        .init(colorHex: "23449A", value: 5.8),
        .init(colorHex: "2C6A7D", value: 7.2),
        .init(colorHex: "337D63", value: 8.6),
        .init(colorHex: "3A8E4F", value: 10.0),
        .init(colorHex: "40A631", value: 11.4),
        .init(colorHex: "48BF1B", value: 12.8),
        .init(colorHex: "4DCF1D", value: 14.2),
        .init(colorHex: "56D81E", value: 15.6),
        .init(colorHex: "65D71E", value: 16.9),
        .init(colorHex: "7CD71D", value: 18.3),
        .init(colorHex: "8CD71D", value: 19.7),
        .init(colorHex: "A1D51D", value: 21.1),
        .init(colorHex: "B4D51C", value: 22.5),
        .init(colorHex: "CBD51B", value: 23.9),
        .init(colorHex: "E8D41A", value: 25.3),
        .init(colorHex: "FBCE19", value: 26.7),
        .init(colorHex: "FCC317", value: 28.1),
        .init(colorHex: "F9B115", value: 29.4),
        .init(colorHex: "F89E13", value: 30.8),
        .init(colorHex: "F78716", value: 32.2),
        .init(colorHex: "F6741A", value: 33.6),
        .init(colorHex: "F65E1E", value: 35.0),
        .init(colorHex: "F3561C", value: 36.4),
        .init(colorHex: "EC4A1A", value: 37.8),
        .init(colorHex: "E84016", value: 39.2),
        .init(colorHex: "DD2D11", value: 40.6),
        .init(colorHex: "D7210D", value: 41.9),
        .init(colorHex: "D1140A", value: 43.3),
        .init(colorHex: "CE0B05", value: 44.7),
        .init(colorHex: "CA0202", value: 46.1),
        .init(colorHex: "C60202", value: 47.5),
        .init(colorHex: "C60202", value: 48.9)
    ]
   
}

