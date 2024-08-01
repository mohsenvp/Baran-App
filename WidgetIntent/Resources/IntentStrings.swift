//
//  WidgetIntentConstants.swift
//  WidgetIntent
//
//  Created by Mohammad Yeganeh on 5/24/23.
//

import Foundation
import SwiftUI

enum WidgetStrings {
    

    static func getBackgroundTitle(for background: WidgetBackground) -> String {
        
        switch background {
        case .def:
            return String(localized: "Default", table: "Widgets")
        case .auto:
            return String(localized: "Light | Dark (iOS Setting)", table: "Widgets")
        case .dark:
            return String(localized: "Dark", table: "Widgets")
        case .light:
            return String(localized: "Light", table: "Widgets")
        case .blue:
            return String(localized: "Blue", table: "Widgets")
        case .teal:
            return String(localized: "Teal", table: "Widgets")
        case .orange:
            return String(localized: "Orange", table: "Widgets")
        case .red:
            return String(localized: "Red", table: "Widgets")
        }
    }
    
    static func getLookTitle(for look: WidgetLook) -> String {
        switch look {
        case .original:
            return String(localized: "Original Look (PREMIUM)", table: "Widgets")
        case .neumorph:
            return String(localized: "Neumorphic Look (PREMIUM)", table: "Widgets")
        case .skeumorph:
            return String(localized: "Skeumorphic Look (PREMIUM)", table: "Widgets")
        case .simple:
            return String(localized: "Simple Look (PREMIUM)", table: "Widgets")
        }
    }
    
    static func getLookDescription(for look: WidgetLook) -> String {

        switch look {
        case .original:
            return String(localized: "Same colors and icons in coherence with the app.", table: "Widgets")
        case .neumorph:
            return String(localized: "Inspired by the neumorphism of macOS.", table: "Widgets")
        case .skeumorph:
            return String(localized: "Inspired by the skeumorphic design of iOS 6.", table: "Widgets")
        case .simple:
            return String(localized: "Simplified icons and colors for a seamless experience", table: "Widgets")
        }
    }
    
    static func getLockScreenTitle(for kind: LockScreenWidgetKind) -> String {
        switch kind {
        case .currentOne:
            return String(localized: "Current Weather Condition", table: "Widgets")
        case .currentTwo:
            return String(localized: "Current Weather Condition (Detailed)", table: "Widgets")
        case .hourlyOne:
            return String(localized: "Horizontal Hourly Forecast", table: "Widgets")
        case .hourlyTwo:
            return String(localized: "Vertical Hourly Forecast", table: "Widgets")
        case .dailyOne:
            return String(localized: "Horizontal Daily Forecast", table: "Widgets")
        case .dailyTwo:
            return String(localized: "Vertical Daily Forecast", table: "Widgets")
        case .precipitation:
            return String(localized: "Current Precipitation", table: "Widgets")
        case .cloudiness:
            return String(localized: "Cloudiness", table: "Widgets")
        case .uv:
            return String(localized: "UV Index", table: "WeatherDetails")
        case .humidity:
            return String(localized: "Humidity", table: "WeatherDetails")
        case .aqi:
            return String(localized: "AQI Widgets", table: "Widgets")
        }
    }
    
    static func getLockScreenDescription(for kind: LockScreenWidgetKind) -> String {
        switch kind {
        case .currentOne:
            return String(localized: "Current Temperature and daily max and min (PREMIUM)", table: "Widgets")
        case .currentTwo:
            return String(localized: "Current Temperature, Condition, Wind Speed, Humidity and Cloudiness (PREMIUM)", table: "Widgets")
        case .hourlyOne:
            return String(localized: "Weather Forecast for the upcoming hours (PREMIUM)", table: "Widgets")
        case .hourlyTwo:
            return String(localized: "Weather Forecast for the upcoming hours including precipitation (PREMIUM)", table: "Widgets")
        case .dailyOne:
            return String(localized: "Weather Forecast for the upcoming days (PREMIUM)", table: "Widgets")
        case .dailyTwo:
            return String(localized: "Weather Forecast for the upcoming days (PREMIUM)", table: "Widgets")
        case .precipitation:
            return String(localized: "Precipitation chance and amount (PREMIUM)", table: "Widgets")
        case .cloudiness:
            return String(localized: "Cloudiness Percentage of the sky right now (PREMIUM)", table: "Widgets")
        case .uv:
            return String(localized: "Current UV Index (PREMIUM)", table: "Widgets")
        case .humidity:
            return String(localized: "Humidity Percentage right now (PREMIUM)", table: "Widgets")
        case .aqi:
            return String(localized: "Protect yourself from pollution with AQI Forecast Widgets", table: "Widgets")
        }
    }
}
