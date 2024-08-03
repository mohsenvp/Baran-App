//
//  ClimateDetailViewModel.swift
//  HeyWeather
//
//  Created by Mohammad Yeganeh on 7/30/23.
//

import Foundation
import SwiftUI

class ClimateDetailViewModel: ObservableObject {
    
    @Published var climateData: ClimateData = .init()
    @Published var city: City
    @Published var isRedacted: Bool = true
    @Published var rainFallChartData: [ChartData] = []
    @Published var snowFallChartData: [ChartData] = []
    @Published var precipitationChartData: [ChartData] = []
    @Published var daylightChartData: [ChartData] = []
    @Published var minTempChartData: [ChartData] = []
    @Published var meanTempChartData: [ChartData] = []
    @Published var maxTempChartData: [ChartData] = []
    @Published var isSubscriptionViewPresented: Bool = false

    
    init(city: City) {
        self.city = city
        getClimate()
    }
    
    
    func getClimate(forceCache: Bool = false, forceUpdate: Bool = false){
        Task { [weak self] in
            do {
                self?.climateData = try await Repository().getClimate(city: self?.city ?? .init(), forceUpdate: forceUpdate, forceCache: forceCache)
                await self?.refreshChartDatas()
            } catch { }
        }
    }
    
    @MainActor
    func refreshChartDatas() {
        self.rainFallChartData = self.climateData.getChartData(type: .rainfall)
        self.snowFallChartData = self.climateData.getChartData(type: .snowfall)
        self.precipitationChartData = self.climateData.getChartData(type: .precipitation)
        self.daylightChartData = self.climateData.getChartData(type: .daylight)
        self.minTempChartData = self.climateData.getChartData(type: .minTemp)
        self.meanTempChartData = self.climateData.getChartData(type: .meanTemp)
        self.maxTempChartData = self.climateData.getChartData(type: .maxTemp)
        self.isRedacted = false
    }
    
}
