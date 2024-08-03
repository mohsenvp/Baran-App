//
//  OtherWidgetDetails.swift
//  HeyWeather
//
//  Created by Kamyar on 5/11/21.
//

import Foundation

struct OtherWidgetsDetails: Codable {
    var city: City
    var widgetViewType: OtherWidgetsType
    
    init (city: City = CityAgent.getMainCity(), widgetViewType: OtherWidgetsType) {
        self.city = city
        self.widgetViewType = widgetViewType
    }
}

enum OtherWidgetsType: Int, Codable {
    case smallAQI, smallSun, smallAQIWithGuage, smallMoon, mediumAstronomy, mediumAQIAndCurrent, mediumAQIAndMoon, mediumCurrentAndMoon, largeAll
}
