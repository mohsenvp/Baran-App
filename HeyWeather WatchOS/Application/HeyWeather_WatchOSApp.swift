//
//  HeyWeather_WatchOSApp.swift
//  HeyWeather WatchOS Watch App
//
//  Created by Mohammad Yeganeh on 8/7/23.
//

import SwiftUI
import WatchKit
import WatchConnectivity
import SwiftyJSON

@main
struct HeyWeather_WatchOS_App: App {
    @ObservedObject var localizeHelper = LocalizeHelper.shared

    var body: some Scene {
        WindowGroup {
            MainView()
                .environment(\.locale, Locale(identifier: localizeHelper.currentLanguage.rawValue))
                .environment(\.layoutDirection, localizeHelper.currentLanguage.isRTL ? .rightToLeft : .leftToRight)
        }
    }


}

