//
//  AQI.swift
//  WeatherApp
//
//  Created by RezaRg on 9/21/20.
//

import Foundation
import SwiftyJSON

struct AQI : Codable, Identifiable, Equatable {
    
    var id = UUID()
    var date: Date
    var value : Int = 0
    var index : Int = 0
    var status : String = "Good"
    var cautionaryStatement : String = "N/A"
    var healthImplications : String = "N/A"
    var main_pollutant: String = ""
    var progress: Int = 12
    var details: [PollutantsDetail] = []
    var localDate: Date
    var utcDate: Date

    init() {
        self.date = Date.now
        self.localDate = Date.now
        self.utcDate = Date.now
    }
    
    init(value: Int, index: Int, progress: Int) {
        self.value = value
        self.index = index
        self.progress = progress
        self.date = Date.now
        self.localDate = Date.now
        self.utcDate = Date.now
    }
    init(json: JSON, timezone: TimeZone) {
        let currentTimezone: TimeZone = .current
        let secondsFromGMT: TimeInterval = TimeInterval(currentTimezone.secondsFromGMT())
        let dt = json["dt"].doubleValue
        date = Date(timeIntervalSince1970: dt).addingTimeInterval(secondsFromGMT)
        
        self.status = json["status"].string ?? ""
        let descJson = json["desc"]
        self.cautionaryStatement = descJson["cautionary_statement"].string ?? ""
        self.healthImplications = descJson["health_implications"].string ?? ""
        self.index = json["index"].int ?? 1
        self.main_pollutant = json["main_pollutant"].string ?? ""
        self.progress = json["progress"].int ?? 12
        self.value = json["value"].intValue

        
        let localSecondsFromGMT: TimeInterval = .init(timezone.secondsFromGMT())
        localDate = Date(timeIntervalSince1970: dt).addingTimeInterval(localSecondsFromGMT)
        
        let zero: TimeInterval = .init(0)
        utcDate = Date(timeIntervalSince1970: dt).addingTimeInterval(zero)
        
        
        let detailsJson = json["details"]
        (0..<detailsJson.count).forEach { i in
            var detail = PollutantsDetail(json: detailsJson[i])
            if detail.name == "pm2_5"{
                detail.name = "pm2.5"
            }
            self.details.append(detail)
        }
       
        
    }
    
    func getPM25() -> PollutantsDetail? {
        for detail in details {
            if detail.name.lowercased() == "pm2.5" {
                return detail
            }
        }
        return nil
    }
    
    static func == (lhs: AQI, rhs: AQI) -> Bool {
        return lhs.id == rhs.id
    }
    
}

struct PollutantsDetail: Codable, Equatable {
    var name: String
    var value: Float
    var aqi_value: Float
    var index: Int
    var progress: Int
    var status: String
    
    init(json: JSON) {
        self.name = json["name"].string ?? ""
        self.value = json["value"].float ?? 12
        self.aqi_value = json["aqi_value"].float ?? 12
        self.index = json["index"].int ?? 1
        self.progress = json["progress"].int ?? 12
        self.status = json["status"].string ?? ""
    }
    
    init() {
        self.name = "no2"
        self.value = 28
        self.index = 0
        self.progress = 72
        self.status = "Good"
        self.aqi_value = 22
    }
    
}
