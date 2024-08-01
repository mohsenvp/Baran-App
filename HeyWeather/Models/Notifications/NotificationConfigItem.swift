//
//  NotificationConfigItem.swift
//  HeyWeather
//
//  Created by Mojtaba on 11/26/23.
//

import Foundation

struct NotificationConfigItem: Codable, Equatable {
    var type: NotificationConfigType
    var isSelected: Bool
    var at_hour: Int?
    var at_min: Int?
    var relative_seconds: Int?
    var days: [Int]?
    var details: [String]?
    
    init(type: NotificationConfigType, isSelected: Bool = false, at_hour: Int? = nil, at_min: Int? = nil, relative_seconds: Int? = nil, days: [Int]? = nil, details: [String]? = nil) {
        self.type = type
        self.isSelected = isSelected
        self.at_hour = at_hour
        self.at_min = at_min
        self.relative_seconds = relative_seconds
        self.days = days
        self.details = details
    }
    
    static func == (lhs: NotificationConfigItem, rhs: NotificationConfigItem) -> Bool {
        return lhs.type == rhs.type
    }
}
