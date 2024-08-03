//
//  WeatherAlert.swift
//  HeyWeather
//
//  Created by Kamyar on 12/18/21.
//

import Foundation
import SwiftyJSON

struct WeatherAlert: Codable, Equatable, Identifiable {

    
    
    var id: UUID = .init()
    var headline: String? = nil
    var instruction: String? = nil
    var event: String? = nil
    var starts: Date? = nil
    var ends: Date? = nil
    var area: String? = nil
    var certainty: AlertCertainty? = nil
    var messageType: String? = nil
    var severity: AlertSeverity? = nil
    var urgency: AlertUrgency? = nil
    var senderName: String? = nil
    var description: String? = nil
    var response: AlertResponse? = nil
    var color: String? = "#F43023"
    
    var expanded: Bool = false
    
    mutating func toggleExpantion(){
        self.expanded = !self.expanded
    }
    
    init(){
        
    }
    init(json: JSON, timezone: TimeZone) {
        let localSecondsFromGMT: TimeInterval = .init(timezone.secondsFromGMT())

        if let startDateTimeStamp = json["starts"].double {
            starts = Date(timeIntervalSince1970: startDateTimeStamp).addingTimeInterval(localSecondsFromGMT)
        }
        if let endDateTimeStamp = json["ends"].double {
            ends = Date(timeIntervalSince1970: endDateTimeStamp).addingTimeInterval(localSecondsFromGMT)
        }

        area = json["area"].string
        messageType = json["message_type"].stringValue
        event = json["event"].string
        senderName = json["sender_name"].string
        description = json["description"].string
        instruction = json["instruction"].string
        headline = json["headline"].string
        
        if json["severity"].exists(), json["severity"] != JSON.null {
            severity = AlertSeverity(json: json["severity"])
        }
        if json["certainty"].exists(), json["certainty"] != JSON.null {
            certainty = AlertCertainty(json: json["certainty"])
        }
        if json["urgency"].exists(), json["urgency"] != JSON.null  {
            urgency = AlertUrgency(json: json["urgency"])
        }
        if json["response"].exists(), json["response"] != JSON.null  {
            response = AlertResponse(json: json["response"])
        }
        color = json["color_code"].string
    }
    
    
    static func == (lhs: WeatherAlert, rhs: WeatherAlert) -> Bool {
        lhs.id == rhs.id && lhs.expanded == rhs.expanded
    }
}

//MARK: Certainty
struct AlertCertainty: Codable {
    var type: String? = ""
    var description: String? = ""
    init(json: JSON) {
        type = json["type"].string
        description = json["description"].string
    }
}



//MARK: Sevirity
struct AlertSeverity: Codable {
    var type: String? = ""
    var description: String? = ""
    init(json: JSON) {
        type = json["type"].string
        description = json["description"].string
    }
}


//MARK: Urgency
struct AlertUrgency: Codable {
    var type: String? = ""
    var description: String? = ""
    init(json: JSON) {
        type = json["type"].string
        description = json["description"].string
    }
}


//MARK: Response
struct AlertResponse: Codable {
    var type: String? = ""
    var description: String? = ""
    init(json: JSON) {
        type = json["type"].string
        description = json["description"].string
    }
}
