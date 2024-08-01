//
//  NotificationService.swift
//  NotificationServiceExtension
//
//  Created by Kamyar on 12/12/21.
//

import UserNotifications
import SwiftyJSON

class NotificationService: UNNotificationServiceExtension {
    
    var contentHandler: ((UNNotificationContent) -> Void)?
    var bestAttemptContent: UNMutableNotificationContent?
    
    
    override func didReceive(_ request: UNNotificationRequest, withContentHandler contentHandler: @escaping (UNNotificationContent) -> Void) {
        self.contentHandler = contentHandler
        bestAttemptContent = (request.content.mutableCopy() as? UNMutableNotificationContent)
        
        guard let bestAttemptContent = bestAttemptContent else { return }
        
        if let notifData = bestAttemptContent.userInfo["notif_data"] as? Dictionary<String, Any> {
            let json = JSON(notifData)
            Task {
                let city = await Repository().CheckAutoLocationAndReturnCity(city: CityAgent.getMainCity(), isWidget: false)
                let notiticationContent = NotificationContent(from: json)
                bestAttemptContent.title = city.placeMarkCityName
                bestAttemptContent.subtitle = notiticationContent.title
                bestAttemptContent.body = notiticationContent.body
                contentHandler(bestAttemptContent)
            }
        }
    }
    
    override func serviceExtensionTimeWillExpire() {
        if let contentHandler = contentHandler, let bestAttemptContent =  bestAttemptContent {
            contentHandler(bestAttemptContent)
        }
    }
    
}
