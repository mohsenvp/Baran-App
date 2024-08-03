//
//  UserNotificationConfigViewData.swift
//  HeyWeather
//
//  Created by Mojtaba on 11/7/23.
//

import Foundation
import Combine
import UserNotifications
import SwiftyJSON
import UIKit.UIApplication
import SwiftUI



class UserNotificationConfigViewData: ObservableObject {
    
    var currentConfigs = CurrentValueSubject<[NotificationConfigItem], Never>([])
    var cancellabls: Set<AnyCancellable> = []
    var loadedConfig: [NotificationConfigItem] = []
    let categories = ["Summary", "Extra", "Astronomy", "Severe"]
    
    @Published var typeOfNotificationAuth: UNAuthorizationStatus = .notDetermined
    
    @Published var isPermissionGranted : Bool = true
    
    @Published var notificationData: [NotificationViewItem] = [
        
        NotificationViewItem(type: .todaySummary,
                             config: NotificationConfigItem(type: .todaySummary, isSelected: true, at_hour: 8,at_min: 0,days: [0,1,2], details: ["temp","vis","aqi"])),
        NotificationViewItem(type: .tomorrowOutlook,
                             config: NotificationConfigItem(type: .tomorrowOutlook, isSelected: true, at_hour: 17,at_min: 0,days: [0,1,2], details: ["temp","vis","aqi"])),
        NotificationViewItem(type: .rainAlert,
                             config: NotificationConfigItem(type: .rainAlert, isSelected: false, at_hour: 7,at_min: 30,days: [0,1,2])),
        NotificationViewItem(type: .highUv,
                             config: NotificationConfigItem(type: .highUv, isSelected: false, at_hour: 6,at_min: 30,days: [0,1,2])),
        NotificationViewItem(type: .highTemperature,
                             config: NotificationConfigItem(type: .highTemperature, isSelected: false, at_hour: 7,at_min: 0,days: [0,1,2])),
        NotificationViewItem(type: .lowTemperature,
                             config: NotificationConfigItem(type: .lowTemperature, isSelected: false, at_hour: 7,at_min: 0, days: [0,1,2])),
        NotificationViewItem(type: .highWind,
                             config: NotificationConfigItem(type: .highWind, isSelected: false, at_hour: 7,at_min: 0, days: [0,1,2])),
        NotificationViewItem(type: .poorAqi,
                             config: NotificationConfigItem(type: .poorAqi, isSelected: false, at_hour: 7,at_min: 0, days: [0,1,2])),
        NotificationViewItem(type: .snowAlert,
                             config: NotificationConfigItem(type: .snowAlert, isSelected: false, at_hour: 6,at_min: 0,days: [0,1,2])),
        NotificationViewItem(type: .sunrise,
                             config: NotificationConfigItem(type: .sunrise, isSelected: false,  relative_seconds: 180, days: [0,1,2])),
        NotificationViewItem(type: .sunset,
                             config: NotificationConfigItem(type: .sunset, isSelected: false, relative_seconds: 180, days: [0,1,2])),
        NotificationViewItem(type: .fullMoon,
                             config: NotificationConfigItem(type: .fullMoon, isSelected: false, relative_seconds: 180, days: [0,1,2,3,4,5,6])),
        NotificationViewItem(type: .severeWeather,
                             config: NotificationConfigItem(type: .severeWeather, isSelected: true, at_hour: 12, at_min: 30, days: [0,1,2,3,4,5,6]))
    ]
    
    init() {
        loadedConfig = loadConfigsFromUserDefaults()
        if !loadedConfig.isEmpty {
            notificationData = notificationData.map { item in
                var newItem = item
                if let newConfig = loadedConfig.first(where: {newItem.type == $0.type}) {
                    newItem.config = newConfig
                }
                return newItem
            }
        }
        $notificationData.map {$0.map(\.config)}
            .assign(to: \.value, on: currentConfigs)
            .store(in: &cancellabls)
        
        currentConfigs.sink { configs in
            self.saveConfigsToUserDefaults(configs)
        }
        .store(in: &cancellabls)
        checkForUserPermission()
    }
    
    private func saveConfigsToUserDefaults(_ configs: [NotificationConfigItem]) {
        UserDefaults.save(value: configs, for: .notificationConfigs)
    }
    
    private func loadConfigsFromUserDefaults() -> [NotificationConfigItem] {
        let data : [NotificationConfigItem] = UserDefaults.get(for: .notificationConfigs) ?? []
        return data
    }
    
    private func checkForUserPermission()  {
        
        let current = UNUserNotificationCenter.current()
        current.getNotificationSettings(completionHandler: { permission in
            switch permission.authorizationStatus  {
            case .authorized:
                self.isPermissionGranted = true
                self.typeOfNotificationAuth = .authorized
            case .denied:
                self.isPermissionGranted = false
                self.typeOfNotificationAuth = .denied
            case .notDetermined:
                self.isPermissionGranted = false
                self.typeOfNotificationAuth = .notDetermined
                self.requestNotificationPermission()
            case .provisional:
                self.isPermissionGranted = true
                self.typeOfNotificationAuth = .provisional
#if os(iOS)
            case .ephemeral:
                self.isPermissionGranted = true
                self.typeOfNotificationAuth = .ephemeral
#endif
            @unknown default:
                self.isPermissionGranted = false
            }
        })
    }
    
    private func requestNotificationPermission() {
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.alert, .sound, .badge]) { (granted, error) in
            DispatchQueue.main.async {
                if granted {
                    self.isPermissionGranted = true
                    UIApplication.shared.registerForRemoteNotifications()
                }
            }
        }
    }
    func reloadNotificationPermission() {
        checkForUserPermission()
    }
    
}
