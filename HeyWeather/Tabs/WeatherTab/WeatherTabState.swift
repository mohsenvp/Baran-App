//
//  swift
//  HeyWeather
//
//  Created by Mohammad Yeganeh on 10/14/23.
//

import Foundation
import SwiftUI
import ActivityKit

class WeatherTabState: ObservableObject, Identifiable {
    
    
    let coordinateSpace: String = UUID().uuidString
    @Published var city: City
    @Published var weatherData: WeatherData
    @Published var astronomy: Astronomy = Astronomy()
    @Published var aqiData: AQIData = .init(isBlank: false)
    @Published var isWeatherRedacted: Bool = false
    @Published var isAstronomyRedacted: Bool = true
    @Published var isLoadingForRefresher: Bool = false
    @Published var isAQIRedacted: Bool = true

    @Published var tappedWeather: Weather?
    @ObservedObject var liveActivity = LiveActivityAgent.shared
    @Published var liveActivityPermissionAlertPresented: Bool = false
    @Published var liveActivityHasActiveAlertPresented: Bool = false
    @Published var retryShown: Bool = false
    @Published var networkFailResponse: NetworkFailResponse? = nil
    @Published var premium: Premium

    @Published var isClimatePresented: Bool = false
    @Published var isTimeTravelPresented: Bool = false
    
    let repository: Repository = Repository()


    var latestCacheDate: Date? {
        return repository.getLatestCacheDate(for: city)
    }
    
    func checkStatusBarColor(){
        AppState.shared.statusBarHasWhiteForeground = textColor == .white
    }
    
    var astronomies: [Astronomy] = []
    var moons: [MoonDataModel] {
        return self.astronomies.map({$0.moon})
    }
    var suns: [SunDataModel] {
        return self.astronomies.map({$0.sun})
    }    

    var textColor: Color {
        return AnimatedWeatherBackground.getTextColor(
            sunrise: astronomy.sun.sunrise,
            sunset: astronomy.sun.sunset,
            weather: weatherData.today
        )
    }
    
    
    init(city: City, premium: Premium){
        self.city = city
        self.premium = premium
        isWeatherRedacted = true
        isAstronomyRedacted = true
        weatherData = repository.getDefaultOrCachedWeatherData(for: city)
    }
    
    @MainActor
    func onAppear(){
        checkStatusBarColor()
        Task {
            await updateLocationAndUpdateData()
        }
    }

    func trackPrecipitationActivity(overrideCurrent: Bool = false){
        if #available(iOS 16.1, *) {
            if overrideCurrent || liveActivity.isTrackingCurrentCity() {
                Task {
                    await liveActivity.stopAllActivities(city: city) {
                        if overrideCurrent {//this is true only when starting activty
                            self.liveActivity.startPrecipitationActivity(precipitation: self.weatherData.precipitation, city: self.city)
                        }
                    }
                }
                return
            }
            if ActivityAuthorizationInfo().areActivitiesEnabled {
                if liveActivity.hasActiveActivity() {
                    liveActivityHasActiveAlertPresented.toggle()
                }else {
                    liveActivity.startPrecipitationActivity(precipitation: weatherData.precipitation, city: city)
                }
            }else {
                liveActivityPermissionAlertPresented.toggle()
            }
        }
    }
    
    
    func updateLocationAndUpdateData() async {
        if (city.isCurrentLocation) {
            city = await repository.CheckAutoLocationAndReturnCity(city: city)
            CityAgent.removeFromCityList(city: city)
            CityAgent.addToCityList(city: city)
            AppState.shared.syncWithWatch()
        }
        updateData()
    }
    
    
    @MainActor
    private func updateWeather(for city: City, forceUpdate: Bool = false, forceCache: Bool = false) {
        isLoadingForRefresher = true

        Task { [weak self] in
            do {
                if let data = try await self?.repository.getWeather(
                    for: city,
                    requestItems: WeatherRequestItem.allCases,
                    requestOrigin: .weatherTab,
                    forceUpdate : forceUpdate,
                    forceCache: forceCache
                ) {
                    self?.weatherData = data
                    AppState.shared.weatherCondition = data.today.condition
                }
                self?.isWeatherRedacted = false
                self?.checkStatusBarColor()
                self?.isLoadingForRefresher = false

                AppState.shared.isLoading = false
            }catch {
                self?.retryShown = true
                self?.isLoadingForRefresher = false

                self?.networkFailResponse = error as? NetworkFailResponse
            }
        }
    }

    
    @MainActor
    private func updateAstronomy(for city: City) {
        self.astronomies = self.repository.getAstronomy(city: city, count: 28, timeZone: self.weatherData.timezone)
        self.astronomy = self.astronomies.first!
        self.isAstronomyRedacted = false
    }
    
    @MainActor
    private func updateAQI(for city: City, forceUpdate: Bool = false, forceCache: Bool = false) {
        isAQIRedacted = true
        var requestItems: [AQIRequestItem] = [.current]
        if premium.isPremium {
            requestItems.append(.daily)
            requestItems.append(.hourly)
        }
        Task { [weak self] in
            do {
                if let aqiData = try await self?.repository.getAQI(for: city, requestItems: requestItems, requestOrigin: .weatherTab, forceUpdate: forceUpdate, forceCache: forceCache) {
                    self?.aqiData = aqiData
                }
                self?.isAQIRedacted = false
            }catch {
                self?.networkFailResponse = error as? NetworkFailResponse
            }
        }
    }

    @MainActor
    private func updateAlerts(for city: City, forceUpdate: Bool = false, forceCache: Bool = false) {
//        Task { [weak self] in
//            do {
//                if let alerts = try await self?.repository.getWeather(for: city, requestItems: [.alerts], requestOrigin: .weatherTab, forceUpdate: forceUpdate, forceCache: forceCache) {
//                    self?.weatherData.setAlerts(alerts: alerts.alerts)
//                }
//            }catch {
//                self?.networkFailResponse = error as? NetworkFailResponse
//            }
//        }
    }

    
    @MainActor
    func updateData(forceUpdate: Bool = false, forceCache: Bool = false) {
        self.networkFailResponse = nil
        self.retryShown = false
        
        self.updateWeather(for: city, forceUpdate: forceUpdate, forceCache: forceCache)
        self.updateAQI(for: city, forceUpdate: forceUpdate, forceCache: forceCache)
        self.updateAlerts(for: city, forceUpdate: forceUpdate, forceCache: forceCache)
        self.updateAstronomy(for: city)
    }
    
    @MainActor
    func updateOnlyWeatherData(forceUpdate: Bool = false, forceCache: Bool = false) {
        updateWeather(for: city, forceUpdate: forceUpdate, forceCache: forceCache)
    }

    
    @MainActor
    func updateOnlyAQIData(forceUpdate: Bool = false, forceCache: Bool = false) {
        updateAQI(for: city, forceUpdate: forceUpdate, forceCache: forceCache)
    }

}
