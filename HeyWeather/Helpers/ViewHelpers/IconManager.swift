//
//  IconManager.swift
//  HeyWeather
//
//  Created by Kamyar on 12/12/21.
//

import Foundation
import UIKit.UIImage

struct IconManager {
    static func getIconName(for condition: WeatherCondition, iconSet: String) -> String {
        
        let conditionType = condition.type != .nothing ? condition.type : .clouds
        let intensity = condition.intensity
        let isDay = condition.isDay
        
        var imgString = "\(iconSet)_\(conditionType)_\(intensity)_\(isDay ? "day" : "night")"
        
        if let _ = UIImage(named: imgString) {
            // Good to Go! Complete Set with intensity and day
        } else {
            imgString = imgString.replace("_day", withString: "")
            imgString = imgString.replace("_night", withString: "")
            if let _ = UIImage(named: imgString) {
                // Good to Go! Complete Set with intensity
            } else {
                imgString = imgString.replace("_light", withString: "_normal")
                imgString = imgString.replace("_heavy", withString: "_normal")
                
                imgString = "\(imgString)_\(isDay ? "day" : "night")"
                if let _ = UIImage(named: imgString) {
                    // Good to Go! Complete Set with normal and day
                } else {
                    imgString = imgString.replace("_day", withString: "")
                    imgString = imgString.replace("_night", withString: "")
                    
                    if let _ = UIImage(named: imgString) {
                        // Good to Go! Complete Set with normal
                    } else {
                        // Bad to Go! Something is wrong
                        print ("SOMETHING WENT WRONG:  \(iconSet)_\(conditionType)_\(intensity)_\(isDay ? "day" : "night")")
                        imgString = "wait"
                    }
                    
                }
                
            }
        }
        return imgString
    }
}
