//
//  ChartData.swift
//  HeyWeather
//
//  Created by Mohammad Yeganeh on 8/7/23.
//

import Foundation
struct ChartData : Identifiable  {
    var id : String {
        return key
    }
    let key : String
    let value : Double
    var accessibleKey: String? = nil
}
