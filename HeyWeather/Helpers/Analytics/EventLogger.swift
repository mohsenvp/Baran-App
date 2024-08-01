//
//  AnalyticsEvents.swift
//  HeyWeather
//
//  Created by Kamyar on 11/13/21.
//

import Foundation
//import FirebaseAnalytics
import SwiftUI

struct EventLogger {
    static func log(event: String, parameters: [String:Any] = [:]) {
//        FirebaseAnalytics.Analytics.logEvent(event, parameters: parameters)
    }
//    
    static func logViewEvent(view: String) {
//        self.log(event: AnalyticsEventScreenView, parameters: [AnalyticsParameterScreenName: view,
//                                                              A∫nalyticsParameterScreenClass: view])
    }
    
    static func logFailResponse(failResponse: NetworkFailResponse) {
        let event = "NetworkFailResponse"
        self.log(event: event, parameters: ["response" : failResponse.rawValue])
    }
}
