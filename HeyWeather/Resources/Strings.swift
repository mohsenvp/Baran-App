//
//  Strings.swift
//  HeyWeather
//
//  Created by Kamyar on 10/23/21.
//

import Foundation
import SwiftUI


enum Strings {
    
    enum SettingsTab {

        static func getTitle(for rowType: SettingsRowType) -> Text {
            switch rowType {
            case .dataSources:
                return Text("Forecast Sources", tableName: "SettingsTab")
            case .appUnits:
                return Text("Application Units", tableName: "SettingsTab")
            case .timeFormat:
                return Text("Time Format", tableName: "SettingsTab")
            case .appIcon:
                return Text("App Icon", tableName: "SettingsTab")
            case .language:
                return Text("Language", tableName: "SettingsTab")
            case .appearance:
                return Text("Appearance", tableName: "SettingsTab")
            case .aboutUs:
                return Text("About us", tableName: "SettingsTab")
            case .contactUs:
                return Text("Contact us", tableName: "SettingsTab")
            case .share:
                return Text("Share HeyWeather", tableName: "SettingsTab")
            case .review:
                return Text("Review HeyWeather", tableName: "SettingsTab")
            case .reddit:
                return Text("Reddit", tableName: "SettingsTab")
            case .twitter:
                return Text("X (FKA Twitter)", tableName: "SettingsTab")
            case .userNotificationConfig:
                return Text("Notification", tableName: "SettingsTab")
            }
        }
        
    }
    
    
    enum WeatherDetails {

        static func getWeatherDetailsTitle(for type: WeatherDetailsViewType) -> Text {
            switch type {
            case .wind:
                return Text("Wind", tableName: "WeatherDetails")
            case .humidity:
                return Text("Humidity", tableName: "WeatherDetails")
            case .pressure:
                return Text("Pressure", tableName: "WeatherDetails")
            case .uvIndex:
                return Text("UV Index", tableName: "WeatherDetails")
            case .dewPoint:
                return Text("Dew Point", tableName: "WeatherDetails")
            case .visibility:
                return Text("Visibility", tableName: "WeatherDetails")
            case .clouds:
                return Text("Clouds", tableName: "WeatherDetails")
            case .precipitation:
                return Text("Precipitation", tableName: "WeatherDetails")
            }
        }
        
        static func getWeatherDetailsText(for type: WeatherDetailsViewType) -> Text {
            
            switch type {
            case .pressure:
                return Text("PRESSURE.ABOUT", tableName: "WeatherDetails")
            case .humidity:
                return Text("HUMIDITY.ABOUT", tableName: "WeatherDetails")
            case .dewPoint:
                return Text("DEW.ABOUT", tableName: "WeatherDetails")
            case .wind:
                return Text("WIND.ABOUT", tableName: "WeatherDetails")
            case .visibility:
                return Text("VISIBILITY.ABOUT", tableName: "WeatherDetails")
            case .uvIndex:
                return Text("UV.ABOUT", tableName: "WeatherDetails")
            case .clouds:
                return Text("CLOUDS.ABOUT", tableName: "WeatherDetails")
            case .precipitation:
                return Text("")
            }
        }
    }
    
    enum LiveActivity {
        static func getTitle(for relativeTime: Int) -> Text {
            if relativeTime == 0 {
                return Text("Steady Rain", tableName: "LiveActivty")
            }else if relativeTime > 0 {
                return Text("Starts in", tableName: "LiveActivty")
            }else {
                return Text("Ends in", tableName: "LiveActivty")
            }
        }
        
    }
    
    enum NetworkAlerts {
        static func getNetworkMessage(for networkFailResponse: NetworkFailResponse) -> Text {
            switch networkFailResponse {
            case .noInternet:
                return Text("There is a problem connecting to the internet\nPlease check your WiFi Settings\nand make sure that you are online", tableName: "Alerts")
            case .internalServer:
                return Text("We are facing a serven error, Please check back again later", tableName: "Alerts")
            case .notModified:
                return Text("Data is not modified since the last time you were here", tableName: "Alerts")
            case .badRequest:
                return Text("We have a Bad Request error on our side, please check back later", tableName: "Alerts")
            case .unauthorized:
                return Text("The action you are trying to do is UnAuthorized, Please try reopenning the app or come back later", tableName: "Alerts")
            case .forbidden:
                return Text("The action you are trying to do is Forbidden, Please try reinstalling the app", tableName: "Alerts")
            case .notFound:
                return Text("The resource you requested can not be found, this will be fixed soon", tableName: "Alerts")
            case .conflict:
                return Text("There is a conflict in your request, please check back again later", tableName: "Alerts")
            case .unknown:
                return Text("We are facing an Unknown error, check back later so we can fix it", tableName: "Alerts")
            case .appStorePlans:
                return Text("Unable to load plans", tableName: "Alerts")
            case .outOfSync:
                return Text("Please open the\nHeyWeather App\non your iPhone\nto continue", tableName: "Alerts")
            }
        }
        
    }
    
}
