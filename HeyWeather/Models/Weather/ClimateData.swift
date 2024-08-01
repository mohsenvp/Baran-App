//
//  ClimateData.swift
//  HeyWeather
//
//  Created by RezaRg on 9/27/20.
//

import Foundation
import SwiftyJSON


struct ClimateData : Codable, Equatable {
 
    
    
    var id: UUID = .init()
    var city: City
    var updatedAt: Date
    var monthlyClimates : [Climate]

    init (json : JSON, city: City) {

        self.city = city
        self.updatedAt = Date.now
        
        monthlyClimates = [Climate]()
        (0..<json.count).forEach { i in
            let j = json[i]
            let c = Climate(json: j)
            monthlyClimates.append(c)
        }
    }
    
    init() {
        self.city = .init()
        self.updatedAt = .init()
        self.monthlyClimates = []
    }
    //didn't fill chart data in init to avoid large cache size
    
    public func climateForIndex(index: Int) -> Climate {
        for climate in monthlyClimates {
            if climate.index == index {
                return climate
            }
        }
        return .init()
    }
    
    static func getMinTempOfYear(climates: [Climate]) -> Double {
        if climates.count == 0 {
            return 0
        }
        var minTemp: Double = climates[0].minTemp
        for climate in climates {
            if climate.minTemp < minTemp {
                minTemp = climate.minTemp
            }
        }
        return minTemp
    }
    
    static func getMaxTempOfYear(climates: [Climate]) -> Double {
        if climates.count == 0 {
            return 0
        }
        var maxTemp: Double = climates[0].maxTemp
        for climate in climates {
            if climate.maxTemp > maxTemp {
                maxTemp = climate.maxTemp
            }
        }
        return maxTemp
    }
        
    public func getChartData(type: AvailableChartDatas) -> [ChartData] {
        var chartData: [ChartData] = []
        let dataFormatter = DateFormatter()
        dataFormatter.locale = Locale(identifier: LocalizeHelper.shared.currentLanguage.rawValue)
        for climate in monthlyClimates {
            var value: Double = 0.0
            switch type {
            case .rainfall:
                value = climate.sumRainfall.convertedPrecipitation()
            case .snowfall:
                value = climate.sumSnowfall.convertedPrecipitation()
            case .precipitation:
                value = climate.sumPrecipitation.convertedPrecipitation()
            case .daylight:
                value = climate.daytime
            case .minTemp:
                value = climate.minTemp.localizedTempValue
            case .meanTemp:
                value = climate.meanTemp.localizedTempValue
            case .maxTemp:
                value = climate.maxTemp.localizedTempValue
            }
            let chart = ChartData(key: dataFormatter.veryShortMonthSymbols[climate.index - 1], value: value)
            chartData.append(chart)
        }
        return chartData
    }
    
    static func == (lhs: ClimateData, rhs: ClimateData) -> Bool {
        return lhs.id == rhs.id
    }
}

enum AvailableChartDatas {
    case rainfall;
    case snowfall;
    case precipitation;
    case daylight;
    case minTemp;
    case meanTemp;
    case maxTemp;
}
