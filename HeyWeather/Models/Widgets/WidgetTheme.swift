//
//  WidgetTheme.swift
//  WeatherApp
//
//  Created by RezaRg on 7/31/20.
//

import Foundation
import SwiftUI

struct WidgetTheme: Codable {
    var viewNo : Int = 0
    var forSize: String = "small"
    var city : City
    var iconSet : String
    var font : String?
    var colorStartString : String
    var colorEndString : String
    var fontColorString : String
    var backgroundImageName: String?
    
    var shouldHideBG : Bool? = false

    var showCityName : Bool = true
    var showAddress : Bool = false
    var showUpdateTime : Bool = true
    
    
    var colorStart : Color {
        get {
            Color(hex: colorStartString)
        }
    }
    
    var colorEnd : Color {
        get {
            Color(hex: colorEndString)
        }
    }
    
    var fontColor : Color {
        get {
            return Color(hex: fontColorString)
        }
    }
    
    init() {
        self.city = CityAgent.getMainCity()
        self.colorStartString =  #colorLiteral(red: 0.03359872848, green: 0.1276057065, blue: 0.2478212714, alpha: 1).toHexString()
        self.colorEndString = #colorLiteral(red: 0.3254901961, green: 0.4705882353, blue: 0.5843137255, alpha: 1).toHexString()
        self.iconSet = "02"
        self.fontColorString = "FFFFFF"
        self.font = "Default"
    }
    init(city: City) {
        self.city = city
        self.colorStartString =  #colorLiteral(red: 0.03359872848, green: 0.1276057065, blue: 0.2478212714, alpha: 1).toHexString()
        self.colorEndString = #colorLiteral(red: 0.3254901961, green: 0.4705882353, blue: 0.5843137255, alpha: 1).toHexString()
        self.iconSet = "01"
        self.fontColorString = "FFFFFF"
        self.font = "Default"
    }
    init(city: City, showCityName: Bool, showAddress: Bool, textColor: String = "FFFFFF") {//init for AQI Widget
        self.city = city
        self.colorStartString =  #colorLiteral(red: 0.03359872848, green: 0.1276057065, blue: 0.2478212714, alpha: 1).toHexString()
        self.colorEndString = #colorLiteral(red: 0.3254901961, green: 0.4705882353, blue: 0.5843137255, alpha: 1).toHexString()
        self.iconSet = "s02"
        self.fontColorString = textColor
        self.font = "Default"
    }
    
    init(colorStart : UIColor, colorEnd : UIColor, iconSet : String, fontColor : UIColor) {
        self.city = CityAgent.getMainCity()
        self.colorStartString = colorStart.toHexString()
        self.colorEndString = colorEnd.toHexString()
        self.iconSet = iconSet
        self.fontColorString = fontColor.toHexString()
        self.font = "Default"
    }
    
    var backgroundColor: LinearGradient {
        get {
            return LinearGradient(gradient: Gradient(colors: [colorStart, colorEnd]), startPoint: .topLeading, endPoint: .bottomTrailing)
        }
    }
    
    @ViewBuilder func getBackground()-> some View {
        if shouldHideBG == true {
            Color.clear
        }else if let key = backgroundImageName {
            let imageData : Data = FileManager.get(for: key)!
            Image(uiImage: imageData.toImage())
                .resizable()
                .aspectRatio(contentMode: .fill)
        } else {
            LinearGradient(gradient: Gradient(colors: [colorStart, colorEnd]), startPoint: .topLeading, endPoint: .bottomTrailing)
        }
    }
}

