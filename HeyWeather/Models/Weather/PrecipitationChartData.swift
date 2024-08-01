//
//  PrecipitationChartData.swift
//  HeyWeather
//
//  Created by Mohammad Yeganeh on 5/15/23.
//

import Foundation
import SwiftyJSON

struct PrecipitationChartData: Codable, Identifiable, Equatable, Hashable{
    var id: UUID = .init()
    var date: Date
    var rate: Double
    var percentValue: Int
    var intensity: PrecipitationIntensity
    init(json: JSON) {
        self.date = Date(timeIntervalSince1970: json["timestamp"].doubleValue)
        self.rate = json["precipitation"].doubleValue.localizedPrecipitation
        self.percentValue = PrecipitationChartData.precipitationToPercent(precip: json["precipitation"].doubleValue)
        self.intensity = PrecipitationChartData.rateToIntensity(rate: json["precipitation"].doubleValue)
    }
    
    
    init() {
        self.date = .now + TimeInterval(Int.random(in: 0...60))
        self.rate = Double.random(in: 0...10)
        self.percentValue = Int.random(in: 0...100)
        let random = Int.random(in: 0...3)
        switch random {
        case 0:
            self.intensity = .drizzle
        case 1:
            self.intensity = .light
        case 2:
            self.intensity = .moderate
        case 3:
            self.intensity = .heavy
        default:
            self.intensity = .heavy
        }
    }
    
    static func generateFakeData() -> [PrecipitationChartData] {
        var data: [PrecipitationChartData] = []
        for _ in 0...30 {
            data.append(.init())
        }
        return data
    }
    static func precipitationToPercent(precip: Double) -> Int {
        let x = 10 * min(precip, 10)
        var y = 61.4613 * x + 588.603
        y = 41.5418 * log(y) - 265.69
        
        return min (max(0 ,Int(y)), 100)
    }
    
    
    static func rateToIntensity(rate: Double) -> PrecipitationIntensity {
        if rate > 2.5 {
            return .heavy
        }
        if rate > 1 {
            return .moderate
        }
        if rate > 0.5 {
            return .light
        }
        return .drizzle
    }
    
    static func toSimpleItems(chartData: [PrecipitationChartData]) -> [Double] {
        var data: [Double] = []
        if chartData.count >= 60 {
            for i in 0..<chartData.count {
                if i % 2 == 0 && i + 1 < chartData.count{
                    data.append((chartData[i].rate + chartData[i + 1].rate) / 2)
                }
            }
        }else {
            for i in 0..<chartData.count {
                data.append(chartData[i].rate)
            }
        }
        return data
    }
    
    static func == (lhs: PrecipitationChartData, rhs: PrecipitationChartData) -> Bool {
        return lhs.id == lhs.id && lhs.rate == rhs.rate && lhs.date == rhs.date
    }
}

enum PrecipitationIntensity: String, CaseIterable, Codable {
    case drizzle
    case light
    case moderate
    case heavy
}
