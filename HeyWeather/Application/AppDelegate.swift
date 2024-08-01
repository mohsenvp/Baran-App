//
//  AppDelegate.swift
//  HeyWeather
//
//  Created by Kamyar on 10/10/21.
//

import Foundation
import UIKit.UIApplication
import FirebaseAnalytics
import UserNotifications
import SwiftyJSON
import WatchConnectivity

class AppDelegate: NSObject, UIApplicationDelegate {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        doOnLaunch()
        
        return true
    }

    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        saveDeviceToken(deviceToken: deviceToken)
    }
    
}

