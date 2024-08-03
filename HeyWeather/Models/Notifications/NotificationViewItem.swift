//
//  NotificationViewItem.swift
//  HeyWeather
//
//  Created by Mojtaba on 11/26/23.
//

import Foundation

struct NotificationViewItem: Identifiable, Equatable {
    var id: UUID = UUID()
    var type: NotificationConfigType
    var name: String
    var icon: String
    var description: String
    var category: String
    var config: NotificationConfigItem
    

    init(type: NotificationConfigType, config: NotificationConfigItem) {
        self.type = type
        self.name = type.name
        self.description = type.description
        self.icon = type.icon
        self.category = type.category
        self.config = config
    }
    
    static func == (lhs: NotificationViewItem, rhs: NotificationViewItem) -> Bool {
        return lhs.id == rhs.id
    }
}
