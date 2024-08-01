//
//  AppState.swift
//  HeyWeather
//
//  Created by Kamyar on 11/14/21.
//

import Foundation
import UIKit
import SwiftUI
import ActivityKit

class AppState: ObservableObject {
    static let shared = AppState()
    @Published var navigateToTab : Tab = .weather
    @Published var presentModal: WeatherTabModal?
    @Published var navigateFromWeatherTab: WeatherTabNavigationLink?
    @Published var navigateFromWidgetTab: WidgetKind?
    @Published var urlString: String?
    @Published var language = LocalizeHelper.shared.currentLanguage
    @Published var colorScheme: ColorScheme?
    @Published var isLoading: Bool = true
    @Published var weatherCondition: WeatherCondition = .init(type: .clear, intensity: .light)
    @Published var statusBarHasWhiteForeground: Bool = false
    @Published var premium: Premium = .init()
    
    func navigateToAppStore() {
        guard let url: URL = .init(string: Constants.appStoreURL),
        UIApplication.shared.canOpenURL(url) else { return }
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
    func navigateToAppSettingPage() {
        if let url = URL(string: "\(UIApplication.openSettingsURLString)&path=\(Constants.appBundleId)") {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
    
    func syncWithWatch(){
        //todo can be written better
        
        guard let userAgent: String = UserDefaults.get(for: .userAgent) else {return}
        guard let uniqueId: String = UserDefaults.get(for: .uniqueId) else {return}

        @AppStorage(Constants.tempUnitString, store: Constants.groupUserDefaults) var tempUnit: String = Constants.defaultTempUnit.rawValue
        @AppStorage(Constants.speedUnitString, store: Constants.groupUserDefaults) var speedUnit: String = Constants.defaultSpeedUnit.rawValue
        @AppStorage(Constants.distanceUnitString, store: Constants.groupUserDefaults) var distanceUnit: String = Constants.defaultDistanceUnit.rawValue
        @AppStorage(Constants.pressureUnitString, store: Constants.groupUserDefaults) var pressureUnit: String = Constants.defaultPressureUnit.rawValue
        @AppStorage(Constants.precipitationUnitString, store: Constants.groupUserDefaults) var precipitationUnit: String = Constants.defaultPrecipitationUnit.rawValue
        
        Connectivity.shared.send(
            premium: premium,
            mainCity: CityAgent.getMainCity(),
            cities: CityAgent.getAllCities(),
            userAgent: userAgent,
            uniqueId: uniqueId,
            tempUnit: tempUnit,
            speedUnit: speedUnit,
            distanceUnit: distanceUnit,
            pressureUnit: pressureUnit,
            precipitationUnit: precipitationUnit,
            currentWeatherDataSource: DataSourceAgent.getCurrentWeatherDataSource(),
            currentAQIDataSource: DataSourceAgent.getCurrentAQIDataSource(),
            timeFormat: TimeFormat.getUserTimeFormat().rawValue,
            currentLanguage: LocalizeHelper.shared.currentLanguage.rawValue,
            errorHandler:  { error in
            print(error.localizedDescription)
        })
    }
    
}

enum Tab: String, CaseIterable {
    case weather
    case widget
    case maps
    case settings
}
