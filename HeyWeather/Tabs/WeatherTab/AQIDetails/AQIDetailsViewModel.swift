//
//  AQIDetailsViewModel.swift
//  HeyWeather
//
//  Created by Kamyar on 12/8/21.
//

import Foundation
import SwiftUI

class AQIDetailsViewModel: ObservableObject {
    var aqiData: AQIData

    @Published var isForecastRedacted: Bool = true
    @Published var isSubscriptionViewPresented: Bool = false
    @Published var showAqiValue: Bool = false
    @ObservedObject var premium: Premium

    var dailyForecast: [AQI] {
        return  aqiData.dailyForecast.isEmpty ? [.init(), .init(), .init(), .init()] : aqiData.dailyForecast
    }

    init(aqiData: AQIData, premium: Premium) {
        self.aqiData = aqiData
        self.premium = premium
    }
    

}
