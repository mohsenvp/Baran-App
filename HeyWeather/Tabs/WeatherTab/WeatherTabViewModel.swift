//
//  WeatherTabViewModel.swift
//  HeyWeather
//
//  Created by Kamyar on 10/27/21.
//

import Foundation
import UserNotifications
import UIKit.UIApplication
import SwiftUI
import WidgetKit

class WeatherTabViewModel: ObservableObject {
    let shouldUpdateWeatherPublisher = Constants.shouldUpdateWeatherPublisher
    let shouldUpdateAQIPublisher = Constants.shouldUpdateAQIPublisher
    let premiumPurchaseWasSuccessful = Constants.premiumPurchaseWasSuccessfulPublisher
    let cityListChangedPublished = Constants.cityListChangedPublisher
    
    @ObservedObject var appState = AppState.shared
    
    @Published var tabItems: [WeatherTabState] = [.init(city: CityAgent.getMainCity(), premium: .init())]
    
    
    let repository = Repository()
    @Published var isSubscriptionModalPresented: Bool = false
    @Published var navigationLinkType: WeatherTabNavigationLink = .hourly
    @Published var isNavigationLinkActive: Bool = false
    @Published var isWebViewPresented: Bool = false
    
    @Published var isAlertViewPresented: Bool = false
    @Published var isMoonDetailsViewPresented: Bool = false
    @Published var isSunDetailsViewPresented: Bool = false
    @Published var isAQISheetPresented: Bool = false
    @Published var isExtraDetailSheetPresented: Bool = false
    @Published var extraDetailType: WeatherDetailsViewType = .wind
    @Published var urlString: String?
    @Published var currentPhase: ScenePhase = .active
    @Published var confettiShown: Bool = false
    @Published var premium: Premium
    
    init(premium: Premium) {
        self.premium = premium
        initTabs()
        checkForNotificationResponse()
    }
    
    func initTabs(){
        
        let cities = CityAgent.getAllCities()
        tabItems.removeAll(keepingCapacity: false)
        
        ///this is for selecting main city on app launch
        CityAgent.saveSelectedCity(city: CityAgent.getMainCity())
        
        cities.forEach { city in
            let tab = WeatherTabState(city: city, premium: premium)
            tabItems.append(tab)
        }
        
        if cities.count > 1 {
            self.getMultipleCities()
        }
    }
    
    func updateTabs(){
        let cities = CityAgent.getAllCities()
        
        // Add missing city
        let missingCities = cities.filter { city in
            !tabItems.contains { $0.city.id == city.id }
        }
        
        for city in missingCities {
            let tab = WeatherTabState(city: city, premium: premium)
            if repository.isCityCacheValid(for: city) {
                tab.updateData(forceCache: true)
            }
            tabItems.append(tab)
        }
        
        // Remove deleted city
        tabItems.removeAll { item in
            !cities.contains { $0.id == item.city.id }
        }
        
        //order cities
        let orderedItems = cities.compactMap { city in
            tabItems.first { $0.city.id == city.id }
        }
        
        self.tabItems = orderedItems
        
    }
    
    private func getMultipleCities(forceCache: Bool = false, forceUpdate: Bool = false) {
        Task { [weak self] in
            if let weatherDatas = try await self?.repository.getMultipleCitiesWeather(for: CityAgent.getAllCities(),forceCache: forceCache, forceUpdate: forceUpdate) as? [WeatherData] {
                weatherDatas.forEach({ weatherData in
                    if let tabIndex = self?.tabItems.firstIndex(where: {$0.city.id == weatherData.location.id}) {
                        if self?.tabItems[tabIndex].weatherData.today.isAvailable ?? false == false {
                            self?.tabItems[tabIndex].weatherData = weatherData
                        }
                    }
                })
            }
            self?.appState.isLoading = false
        }
    }
    
    func updateWeatherDataForMainTabs(){
        let selectedCityId = CityAgent.getSelectedCity().id
        let mainCityId = CityAgent.getMainCity().id
        
        let filteredTabItems = tabItems.filter { $0.city.id == selectedCityId || $0.city.id == mainCityId }
        filteredTabItems.forEach { $0.updateOnlyWeatherData(forceUpdate: true) }
    }
    
    func updateAQIDataForMainTabs(){
        let selectedCityId = CityAgent.getSelectedCity().id
        let mainCityId = CityAgent.getMainCity().id
        
        let filteredTabItems = tabItems.filter { $0.city.id == selectedCityId || $0.city.id == mainCityId }
        filteredTabItems.forEach { $0.updateOnlyAQIData(forceUpdate: true) }
    }
    
    func updateEverything(){
        tabItems.forEach { $0.updateData(forceUpdate: true) }
    }
    
    private func checkForNotificationResponse() {
        if let navigationLink = appState.navigateFromWeatherTab {
            navigateDetails(navigationLink)
            AppState.shared.navigateFromWeatherTab = nil
        } else if let modal = appState.presentModal {
            presentModal(modal)
            AppState.shared.presentModal = nil
        } else if let urlString = appState.urlString {
            self.urlString = urlString
            presentModal(.webView)
            AppState.shared.urlString = nil
        } else {
            checkLaunchesCount()
        }
    }
    
    func requestNotificationPermission() {
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.alert, .sound, .badge]) { (granted, error) in
            DispatchQueue.main.async {
                UIApplication.shared.registerForRemoteNotifications()
            }
        }
    }
    
    func updateCurrentPhaseToNewPhase(_ newPhase : ScenePhase, selectedTabIndex: Int) {
        if (currentPhase == .background && newPhase == .active) {
            Task {
                await tabItems[selectedTabIndex].updateLocationAndUpdateData()
            }
        }
        
        if (newPhase == .background || newPhase == .active) {
            currentPhase = newPhase
        }
        
        ///Sync user config when app goes into background
        if (currentPhase == .active && (newPhase == .background || newPhase == .inactive)) {
            WidgetCenter.shared.reloadAllTimelines()
            AppSettingAgent.sync()
            NotificationManager.shared.setAstronomyNotifications()
        }
    }
    
    func afterSuccessfulPurchase(selectedTabIndex: Int) {
        tabItems[selectedTabIndex].updateData(forceUpdate: true)
        
        self.confettiShown = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 7) {
            self.confettiShown = false
            AppStoreAgent.requestReview()
        }
    }
    
    private func checkLaunchesCount() {
        let appLaunches: Int = UserDefaults.get(for: .appLaunches) ?? 0
        if appLaunches.isTimeToReview { AppStoreAgent.requestReview() }
        if appLaunches.isTimeToShowSubscription && !premium.isPremium{
            presentModal(.subscription)
        }
        if appLaunches.isTimeToRequestForNotificationPermission {
            requestNotificationPermission()
        }
    }
    
    
    func navigateDetails(_ type: WeatherTabNavigationLink) {
        self.navigationLinkType = type
        self.isNavigationLinkActive = true
    }
    
    func presentModal(_ type: WeatherTabModal) {
        switch type {
        case .subscription:
            self.isSubscriptionModalPresented = true
        case .offer:
            return
        case .alert:
            self.isAlertViewPresented = true
        case .webView:
            self.isWebViewPresented = true
        case .astronomy:
            self.isMoonDetailsViewPresented = true
        case .aqi:
            self.isAQISheetPresented = true
        case .extraDetail:
            self.isExtraDetailSheetPresented = true
        }
    }
    
    func presentExtraDetailModal(type: WeatherDetailsViewType) {
        extraDetailType = type
        presentModal(.extraDetail)
    }
    
}

// MARK: - Types of navigation links that open from weather tab
enum WeatherTabNavigationLink: String, CaseIterable {
    case hourly
    case daily
    case cityList
    case weatherAlerts
}

// MARK: - Types of modals that open from weather tab
enum WeatherTabModal: String, CaseIterable {
    case subscription
    case offer
    case alert
    case webView
    case astronomy
    case aqi
    case extraDetail
}


// MARK: - Extension for check app review time

fileprivate extension Int {
    var isTimeToReview: Bool {
        return self % 50 == 7
    }
    var isTimeToShowSubscription: Bool {
        return self % 10 == 0
    }
    var isTimeToRequestForNotificationPermission: Bool {
        return self < 3
    }
}
