//
//  NotificationContent.swift
//  HeyWeather
//
//  Created by Mohammad Yeganeh on 11/29/23.
//

import Foundation
import SwiftyJSON

struct NotificationContent: Codable {
    var title: String = ""
    var body: String = ""
    
    init(){
        
    }
    
    init(from json: JSON) {
        let timezone: TimeZone = .init(identifier: json["timezone"].stringValue) ?? .current
        let detailsJson = json["details"]
        
        if detailsJson.exists() {
            
            let secondsFromGMT: TimeInterval = TimeInterval(timezone.secondsFromGMT())
            guard let type = NotificationConfigType(rawValue: json["type"].stringValue) else {return}
            title = getNotificationTitle(type: type)
            
            var details: [String] = []
            NotificationWeatherConfigExtra.allCases.forEach { detail in
                if detailsJson[detail.rawValue].exists() {
                    let value = detailJsonToStringValue(
                        singleDetail: detailsJson[detail.rawValue],
                        detail: detail,
                        secondsFromGMT: secondsFromGMT
                    )
                    details.append(value)
                }
            }
            if type == .todaySummary || type == .tomorrowOutlook {
                body = details.joined(separator: ", ") + "."
            }else{
                let time = Date(timeIntervalSince1970: detailsJson["time"].doubleValue).addingTimeInterval(secondsFromGMT).toUserTimeFormatWithMinuets()
                let value = convertValue(value: detailsJson["value"], type: type)
                body = "\(type.name) will be \(value) around \(time)."
            }
        }
        
    }
    
    
    private func getNotificationTitle(type: NotificationConfigType) -> String {
        switch type {
        case .todaySummary:
            return String(localized: "Today, \(Date().formatted(date: .numeric, time: .omitted))", table: "Notifications")
        case .tomorrowOutlook:
            return String(localized: "Tomorrow, \(Date().formatted(date: .numeric, time: .omitted))", table: "Notifications")
        case .rainAlert, .snowAlert:
            return String(localized: "\(type.name)", table: "Notifications")
        default:
            return String(localized: "\(type.name) Alert", table: "Notifications")
        }
    }
    
    private func convertValue(value: JSON, type: NotificationConfigType) -> String {
        switch type {
        case .rainAlert:
            return "\(value.doubleValue.localizedPrecipitation)%"
        case .highUv:
            return "\(value.intValue.localizedNumber)"
        case .highTemperature, .lowTemperature:
            return "\(value.doubleValue.localizedTemp)"
        case .highWind:
            return "\(value.doubleValue.localizedWindSpeed)"
        case .poorAqi:
            return "\(value.intValue.localizedNumber)"
        case .snowAlert:
            return "\(value.doubleValue.localizedPrecipitation)%"
        default:
            return ""
        }
    }
    
    private func detailJsonToStringValue(
        singleDetail: JSON,
        detail: NotificationWeatherConfigExtra,
        secondsFromGMT: TimeInterval
    ) -> String {
        
        switch detail {
        case .precp:
            return "\(detail.name): \(singleDetail.doubleValue.localizedPrecipitationWithUnit)"
        case .sunrise:
            let sunrise = Date(timeIntervalSince1970: singleDetail.doubleValue).addingTimeInterval(secondsFromGMT)
            return"\(detail.name): \(sunrise.toUserTimeFormatWithMinuets())"
        case .sunset:
            let sunset = Date(timeIntervalSince1970: singleDetail.doubleValue).addingTimeInterval(secondsFromGMT)
            return "\(detail.name): \(sunset.toUserTimeFormatWithMinuets())"
        case .condition:
            return "\(singleDetail.stringValue.capitalized)"
        case .pop:
            return "\(detail.name): \(singleDetail.doubleValue.localizedPrecipitation)%"
        case .dew:
            return "\(detail.name): \(singleDetail.doubleValue.localizedTemp)"
        case .moon:
            return "\(detail.name): \(singleDetail.stringValue)"
        case .cloud, .rh:
            return "\(detail.name): \(singleDetail.intValue.localizedNumber)%"
        case .nighttime, .daytime:
            return "\(detail.name): \(singleDetail.intValue.secondsToHoursAndMinutes())"
        case .aqi:
            return "\(detail.name): \(singleDetail["status"].stringValue)(\(singleDetail["value"].intValue))"
        case .pressure:
            return "\(detail.name): \(singleDetail.intValue.localizedPressure)"
        case .wind:
            return "\(detail.name): \(singleDetail.doubleValue.localizedWindSpeed)"
        case .temp:
            return "\(detail.name): \(singleDetail["max"].doubleValue.localizedTemp)↑ ↓\(singleDetail["min"].doubleValue.localizedTemp)"
        case .uv:
            return "\(detail.name): \(singleDetail.intValue.localizedNumber)"
        case .vis:
            return "\(detail.name): \(singleDetail.intValue.localizedVisibility)"
        }
        
    }
}
