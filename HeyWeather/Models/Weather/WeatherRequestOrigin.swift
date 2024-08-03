//
//  WeatherRequestOrigin.swift
//  HeyWeather
//
//  Created by Reza Ranjbaran on 29/05/2023.
//

import Foundation

enum WeatherRequestOrigin: String, CaseIterable {
    case weatherTab = "weather_tab"
    case citylistView = "city_list"
    case widgetTab =  "widget_tab"
    case homescreenWidget = "homescreen_widget"
    case lockscreenWidget = "lockscreen_widget"
    case siriShortcut = "siri_shortcut"
    case iMessageApp = "imessage_app"
    case appClip = "app_clip"
    case appleWatch = "apple_watch"
    case appleWatchWidget = "apple_watch_widget"
    case appleWatchComplication = "apple_watch_complication"
    case appleWatchCityList = "apple_watch_city_list"
    case notificationConfigView = "notification_config_view"

}

enum WeatherRequestCacheType : Int,CaseIterable {
    case premium
    case regular
}
