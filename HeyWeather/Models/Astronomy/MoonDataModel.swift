//
//  MoonDataModel.swift
//  HeyWeather
//
//  Created by Mohsen on 28/11/2023.
//

import Foundation
import SwiftyJSON


struct MoonDataModel: Codable, Identifiable, Equatable {
    var id: UUID = .init()
    var type: String
    var phase: String
    var illumination: Double
    var parallacticAngle: Double
    var distance: Int64
    var rise: Date!
    var set: Date!
    var alwaysUp: Bool
    var alwaysDown: Bool
    var lastNewMoon: Double
    var nextFullMoon: Double
    var age: Int
    var visible: Bool
    
    init() {
        self.type = "Waxing Gibbous"
        self.phase = "Waxing Gibbous"
        self.illumination = 63.1
        self.parallacticAngle = -28.4
        self.distance = 384158
        self.rise = Date(timeIntervalSince1970: 1618997586)
        self.set = Date(timeIntervalSince1970: 1618969581)
        self.alwaysUp = false
        self.alwaysDown = false
        self.lastNewMoon = 1618194776
        self.nextFullMoon = 1619494384
        self.age = 8
        self.visible = false
    }

    func isVisible() -> Bool {
        let now = Date()
        if self.set == nil || self.rise == nil{
            return true
        }
        if self.set < self.rise {
            if now > self.rise || now < self.set {
                return true
            }else{ return false }
        }else{
            if now < self.set && now > self.rise && self.set.timeIntervalSince1970 != 0 && self.rise.timeIntervalSince1970 != 0 {
                return true
            } else if self.rise.timeIntervalSince1970 == 0 && now < self.set {
                return true
            } else if self.set.timeIntervalSince1970 == 0 && now > self.rise {
                return true
            } else { return false }
        }
        
    }
    
    func hasRise() -> Bool {
        if Calendar.current.component(.day, from: Date()) == Calendar.current.component(.day, from: self.rise) {
            return true
        } else { return false }
    }
    
    func hasSet() -> Bool {
        if Calendar.current.component(.day, from: Date()) == Calendar.current.component(.day, from: self.set) {
            return true
        } else { return false }
    }
    
    func getMoonStringAndAngle() -> (String, Double) {
        var imgString = "moon-p";
        var rotateAngle = 0;
        
        let illumination = self.illumination
        let type = self.type
        
        
        if (illumination <= 3) {
            imgString += "-0-3";
        }else if (illumination <= 14) {
            imgString += "-3-14";
        }else if (illumination <= 25) {
            imgString += "-14-25";
        }else if (illumination <= 36) {
            imgString += "-25-36";
        }else if (illumination <= 47) {
            imgString += "-36-47";
        }else if (illumination <= 53) {
            imgString += "-47-53";
        }else if (illumination <= 64) {
            imgString += "-53-64";
        }else if (illumination <= 75) {
            imgString += "-64-75";
        }else if (illumination <= 86) {
            imgString += "-75-86";
        }else if (illumination <= 97) {
            imgString += "-86-97";
        }else if (illumination <= 100) {
            imgString += "-97-100";
        }
        
        if (type.contains("Wan")) {
            rotateAngle = 0;
        }else if (type.contains("Wax")) {
            rotateAngle = 180;
        }else if (type.contains("New") || type.contains("Full")) {
            rotateAngle = 0;
        }else if (type.contains("Last Quarter")) {
            rotateAngle = 0;
        }else if (type.contains("First Quarter")) {
            rotateAngle = 180;
        }
        
        return (imgString, Double(rotateAngle))
    }
}
