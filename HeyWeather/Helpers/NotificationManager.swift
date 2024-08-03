//
//  NotificationManager.swift
//  HeyWeather
//
//  Created by Mohsen on 05/12/2023.
//

import UserNotifications

enum AstronomyNotifId : String{
    case astronomy_notification = "astronomy_notification"
    case sunrise_notification = "astronomy.sunrise."
    case fullMoon_notification = "astronomy.fullmoon."
    case sunset_notification = "astronomy.sunset."
}


class NotificationManager {
    static let shared = NotificationManager()
    let categoryId = Constants.appBundleId
    let notificationCenter = UNUserNotificationCenter.current()
    
    private init() {}
    
    
    private func getAstronomyData() -> [Astronomy]{
        let astronomyData = AstronomyManager.shared.getAstronomy(city: CityAgent.getMainCity(), count: 30, timeZone: TimeZone(identifier: "UTC")!)
        return astronomyData
    }
    
    func setAstronomyNotifications(){
        let astronomyData: [Astronomy] = getAstronomyData()
        let loadedConfig: [NotificationConfigItem] = loadConfigsFromUserDefaults()

        // Remove Astronomy pending notifications
        notificationCenter.removePendingNotificationRequests(withIdentifiers: [AstronomyNotifId.astronomy_notification.rawValue])

        if !loadedConfig.isEmpty {
            
            _ = loadedConfig.map { notificationConfig in
                switch notificationConfig.type{
                case .fullMoon:
                    if notificationConfig.isSelected{
                        self.recurringFullMoonNotification(notificationConfig: notificationConfig, astronomyData: astronomyData)
                    }
                    break
                case .sunset:
                    if notificationConfig.isSelected{
                        self.recurringSunsetNotification(notificationConfig: notificationConfig, astronomyData: astronomyData)
                    }
                    break
                case .sunrise:
                    if notificationConfig.isSelected{
                        self.recurringSunriseNotification(notificationConfig: notificationConfig, astronomyData: astronomyData)
                    }
                    break
                default:
                    break
                }
            }
        }

    }
    
    // Mark : This function print all pending notifications
    func getSchedulednotifications(){
        notificationCenter.getPendingNotificationRequests { request in
            for req in request{
                if req.trigger is UNCalendarNotificationTrigger{
                    print("mmm \(req.content.title)",(req.trigger as! UNCalendarNotificationTrigger).nextTriggerDate()?.description ?? "invalid next trigger date")
                }
            }
        }
    }

    
    private func loadConfigsFromUserDefaults() -> [NotificationConfigItem] {
        let data : [NotificationConfigItem] = UserDefaults.get(for: .notificationConfigs) ?? []
        return data
    }
    
    private func scheduledNotification(notificationRequest: UNNotificationRequest){
        notificationCenter.add(notificationRequest)
    }
    
    private func createContent(title: String, body: String) -> UNMutableNotificationContent {
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = body
        content.sound = UNNotificationSound.default
        content.threadIdentifier = AstronomyNotifId.astronomy_notification.rawValue
        content.categoryIdentifier = self.categoryId
        
        
        return content
    }
    
    
    private func recurringSunsetNotification(notificationConfig: NotificationConfigItem, astronomyData: [Astronomy]) {
        guard let days = notificationConfig.days else {
            print("No days provided for notification")
            return
        }
        // i is a counter to provide unique ID
        var i = 0

        let notificationsRequest = astronomyData.map { item -> UNNotificationRequest? in
            guard let sunset = item.sun.sunset else{
                return nil
            }
            let sunsetDateWithRelativeSeconds = subtractSecondsAndGetTime(from: sunset, relativeSeconds: notificationConfig.relative_seconds ?? 0)
            
            let title = String(localized: "Sunset", table: "Sun")
            var body = ""
            if notificationConfig.relative_seconds == 0 {
                body = String(localized: "Sun is set now. Night duration: \(item.sun.getNightDurationHours()) hrs.", table: "Notifications")
            } else {
                let minutes = (notificationConfig.relative_seconds ?? 0) / 60
                let timeFormat = sunset.toUserTimeFormatWithMinuets().lowercased()
                body = String(localized: "Sun sets in \(minutes) min at \(timeFormat), Night duration: \(item.sun.getNightDurationHours()) hrs \(item.sun.getNightDurationMinutes()) mins.", table: "Notifications")
            }
            
            // Change first day from 0 to 2 - first day is monday
            var calendar = Calendar.current
            calendar.timeZone = .current
            calendar.firstWeekday = 7
            let sunsetComponents = calendar.dateComponents([.weekday], from: sunsetDateWithRelativeSeconds)
            let weekDay = ((sunsetComponents.weekday ?? 0) + 5) % 7
            
            if days.contains(weekDay) {
                let trigger = UNCalendarNotificationTrigger(dateMatching: calendar.dateComponents([.day, .hour, .minute], from: sunsetDateWithRelativeSeconds), repeats: false)
                    
                let identifier = "\(AstronomyNotifId.sunset_notification.rawValue).\(i)"
                i += 1
                return UNNotificationRequest(identifier: identifier, content: createContent(title: title, body: body), trigger: trigger)
            }
            return nil
        }

        notificationsRequest.forEach { notificationRequest in
            if let notificationRequest = notificationRequest {
                scheduledNotification(notificationRequest: notificationRequest)
            }
        }
    }
    
    private func recurringSunriseNotification(notificationConfig: NotificationConfigItem, astronomyData: [Astronomy]) {
        guard let days = notificationConfig.days else {
            print("No days provided for notification")
            return
        }
        // i is a counter to provide unique ID
        var i = 0
        
        let notificationsRequest = astronomyData.map { item -> UNNotificationRequest? in
            guard let sunrise = item.sun.sunrise else{
                return nil
            }
            let sunriseDateWithRelativeSeconds = subtractSecondsAndGetTime(from: sunrise, relativeSeconds: notificationConfig.relative_seconds ?? 0)
            
            let title = String(localized: "Sunrise", table: "Sun")
            var body = ""
            if notificationConfig.relative_seconds == 0 {
                body = String(localized: "Sun is rising now. Daylight duration: \(item.sun.getDayDurationHours()) hrs \(item.sun.getDayDurationMinutes()) min.", table: "Notifications")
            } else {
                let minutes = (notificationConfig.relative_seconds ?? 0) / 60
                let timeFormat = sunrise.toUserTimeFormatWithMinuets().lowercased()
                body = String(localized: "Sun rise in \(minutes) min at \(timeFormat), Daylight duration: \(item.sun.getDayDurationHours()) hrs \(item.sun.getDayDurationMinutes()) min.", table: "Notifications")
            }
            
            var calendar = Calendar.current
            calendar.firstWeekday = 7
            let sunriseComponents = calendar.dateComponents([.weekday], from: sunriseDateWithRelativeSeconds)
            let weekDay = ((sunriseComponents.weekday ?? 0) + 5) % 7
            
            if days.contains(weekDay) {
                let trigger = UNCalendarNotificationTrigger(dateMatching: calendar.dateComponents([.day, .hour, .minute], from: sunriseDateWithRelativeSeconds), repeats: false)
                let identifier = "\(AstronomyNotifId.sunrise_notification.rawValue).\(i)"
                i += 1
                return UNNotificationRequest(identifier: identifier, content: createContent(title: title, body: body), trigger: trigger)
            }
            
            return nil
        }
        
        notificationsRequest.forEach { notificationRequest in
            if let notificationRequest = notificationRequest {
                scheduledNotification(notificationRequest: notificationRequest)
            }
        }
    }
    
    private func recurringFullMoonNotification(notificationConfig: NotificationConfigItem, astronomyData: [Astronomy]) {
        let fullMoonAstronomyData = astronomyData.filter { 99.5...100 ~= $0.moon.illumination }

        
        let notificationsRequest = fullMoonAstronomyData.map { item -> UNNotificationRequest in
            let middle = item.moon.set.distance(to: item.moon.rise) / 2
            let fullMoonDateWithRelativeSeconds = subtractSecondsAndGetTime(from: item.moon.rise.addingTimeInterval(middle), relativeSeconds: notificationConfig.relative_seconds ?? 0)
            
            let title = String(localized: "Full Moon", table: "Moon")
            var body = ""
            if notificationConfig.relative_seconds == 0 {
                if item.moon.isVisible() {
                    body = String(localized: "Full moon now! Visible in sky", table: "Notifications")
                } else {
                    body = String(localized: "Full moon now! Not visible in your area.", table: "Notifications")
                }
            } else {
                if item.moon.isVisible() {
                    body = String(localized: "Full moon in \((notificationConfig.relative_seconds ?? 0) / 60) min, visible in sky", table: "Notifications")
                } else {
                    body = String(localized: "Full moon in \((notificationConfig.relative_seconds ?? 0) / 60) min, not visible in your area.", table: "Notifications")
                }
            }
            
            var calendar = Calendar.current
            calendar.firstWeekday = 7
            
            let trigger = UNCalendarNotificationTrigger(dateMatching: calendar.dateComponents([.day, .hour, .minute], from: fullMoonDateWithRelativeSeconds), repeats: false)
            
            // full moon has only one notification
            let identifier = AstronomyNotifId.fullMoon_notification.rawValue
            
            return UNNotificationRequest(identifier: identifier, content: createContent(title: title, body: body), trigger: trigger)
        }

        notificationsRequest.forEach { scheduledNotification(notificationRequest: $0) }
    }
    
    func subtractSecondsAndGetTime(from date: Date, relativeSeconds: Int) -> Date {
        let calendar = Calendar.current
        let modifiedDate = calendar.date(byAdding: .second, value: -relativeSeconds, to: date)!
        
        return modifiedDate
    }
}
