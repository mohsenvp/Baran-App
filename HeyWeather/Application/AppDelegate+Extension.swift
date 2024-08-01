//
//  File.swift
//  HeyWeather
//
//  Created by Kamyar on 10/10/21.
//

import Foundation
import UserNotifications
import UIKit
import Firebase
import SwiftyJSON
import GoogleMaps
import WatchConnectivity

extension AppDelegate: UNUserNotificationCenterDelegate {
    
    func doOnLaunch() {
        UNUserNotificationCenter.current().delegate = self
        UIApplication.shared.applicationIconBadgeNumber = 0
        
        
        startNetworkDebugging()
        configureGoogleMaps()
        AppStoreAgent.setupSwiftyStoreKit()
        
        setDefaultAppearance()
        setAppAppearance()
        startWatchSession()
        sendUserConfig()
//        setAstronomyNotifications()
    }
    
    func setAstronomyNotifications(){
        NotificationManager.shared.setAstronomyNotifications()
    }
    
    func startWatchSession(){
        let _ = Connectivity.shared
    }

    func setAppAppearance(){
        let appearance: AppAppearance = UserDefaults.get(for: .appAppearance) ?? .auto
        
        switch(appearance) {
        case .light:
            AppState.shared.colorScheme = .light
        case .dark:
            AppState.shared.colorScheme = .dark
        case .auto:
            AppState.shared.colorScheme = nil
        }
    }
    
    func sendUserConfig(){
        AppSettingAgent.sync()
    }
    
    func saveDeviceToken(deviceToken: Data) {
        var token = ""
        for i in 0..<deviceToken.count {
            token = token + String(format: "%02.2hhx", arguments: [deviceToken[i]])
        }
        
        if !token.isEmpty {
            sendNotificationToken(token)
        }
    }
    
    
    // MARK: - Handle user response to notifications
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        let userInfo = response.notification.request.content.userInfo
        handleNotificationResponse(for: userInfo)
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.banner, .badge, .sound])
    }
    
    func configureGoogleMaps(){
        GMSServices.provideAPIKey(Constants.googleMapApiKey)
    }
    
    // MARK: - Private Functions
    
    private func startNetworkDebugging() {
#if DEBUG
        NetworkActivityLogger.shared.startLogging()
#endif
    }

    private func sendNotificationToken(_ token: String) {
        if UserDefaults.get(for: .notificationToken) == token {
            return
        }
        UserDefaults.save(value: token, for: .notificationToken)
        print("Seding notification token \(token)")
        Task {
            do {
                _ = try await Repository().sendNotificationToken(notificationToken: token)
            } catch { }
        }
    }
    
    private func handleNotificationResponse(for userInfo: Dictionary<AnyHashable,Any>) {
        guard let typeString = userInfo["type"] as? String,
              let type: NotificationType = .init(rawValue: typeString) else { return }
        switch type {
        case .app:
            guard let linkString = userInfo["app"] as? String,
                  let appLink: AppLink = .init(rawValue: linkString) else { return }
            var navigateToTab: Tab = .weather
            var navigateFromWeatherTab: WeatherTabNavigationLink?
            var navigateFromWidgetTab: WidgetKind?
            var presentModal: WeatherTabModal?
            switch appLink {
            case .widget:
                navigateToTab = .widget
            case .map:
                navigateToTab = .maps
            case .settings:
                navigateToTab = .settings
            case .hourly:
                navigateFromWeatherTab = .hourly
            case .daily:
                navigateFromWeatherTab = .daily
            case .aqi:
                presentModal = .aqi
            case .astronomy:
                presentModal = .astronomy
            case .subscription:
                presentModal = .subscription
            case .offer:
                presentModal = .offer
            case .customizableWidgets:
                navigateToTab = .widget
                navigateFromWidgetTab = .customizable
            }
            AppState.shared.navigateToTab = navigateToTab
            AppState.shared.navigateFromWeatherTab = navigateFromWeatherTab
            AppState.shared.navigateFromWidgetTab = navigateFromWidgetTab
            AppState.shared.presentModal = presentModal
        case .store:
            AppState.shared.navigateToAppStore()
        case .web:
            guard let urlString = userInfo["url"] as? String else { return }
            AppState.shared.urlString = urlString
        case .general:
            return
        }
    }
    
    private func setDefaultAppearance() {
        UIPageControl.appearance().currentPageIndicatorTintColor = Constants.accentUIColor
        UIPageControl.appearance().pageIndicatorTintColor = .quaternaryLabel
        UIRefreshControl.appearance().tintColor = .init(.label)
        let tabBarAppearance = UITabBarAppearance()
        tabBarAppearance.configureWithTransparentBackground()
        tabBarAppearance.backgroundColor = Constants.tabbarBackgroundUIColor
        UITabBar.appearance().standardAppearance = tabBarAppearance
        UITabBar.appearance().scrollEdgeAppearance = tabBarAppearance
        
        UIView.appearance(whenContainedInInstancesOf: [UIAlertController.self]).tintColor = Constants.accentUIColor
        UIRefreshControl.appearance().tintColor = UIColor.clear

    }
    
}
