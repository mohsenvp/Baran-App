//
//  AppLink.swift
//  HeyWeather
//
//  Created by Kamyar on 12/18/21.
//

import Foundation

enum AppLink: String, CaseIterable {
    case widget, map, settings // Tabs
    case hourly
    case daily
    case aqi
    case astronomy
    case subscription
    case offer
    case customizableWidgets = "customizable_widgets"
}
