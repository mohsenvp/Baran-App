//
//  CityListViewModel.swift
//  HeyWeather
//
//  Created by Kamyar on 10/27/21.
//

import Foundation
import SwiftUI

class CityListViewModel: ObservableObject {
    let repository = Repository()
    let freeAccountCityLimit = 2
    @Published var mainCity: City = CityAgent.getMainCity()
    @Published var addedCity: City?
    @Published var isCitySearchModalPresented = false
    @Published var isRedacted = true
    @Published var networkFailResponse: NetworkFailResponse?
    @Published var weatherDatas = [WeatherData]()
    @Published var isPremium: Bool = false
    @Published var isMaxCitiesAlertPresented = false
    @Published var isSubscriptionViewPresented = false
    @Binding var isCityListOpen: Bool
    
    
    func maxCitiesAlert() -> Alert {
        return isPremium ?
        Alerts.maxCitiesAlert():
        Alerts.freePlanMaxCitiesAlert {
            self.presentSubscriptionView()
        }
    }
    
    
    private func freePlanMaxCitiesAlert() -> Alert {
        return Alerts.freePlanMaxCitiesAlert {
            self.presentSubscriptionView()
        }
    }
    
    private func premiumMaxCitiesAlert() -> Alert {
        return Alerts.maxCitiesAlert()
    }
    
    func setMainCity(city: City) {
        CityAgent.saveMainCity(city: city)
        self.mainCity = city
        self.isCityListOpen = false
        AppState.shared.syncWithWatch()
    }
    
    func initialize(isPremium: Bool) {
        
        self.isPremium = isPremium
        self.reloadData(forceCache: true)
        
        Task {
            if let currentCity = CityAgent.getAllCities().first(where: { $0.isCurrentLocation }) {
                let city = await self.repository.CheckAutoLocationAndReturnCity(city: currentCity)
                CityAgent.removeFromCityList(city: city)
                CityAgent.addToCityList(city: city)
            }
            self.reloadData()
        }
    }
    
    func addCity(city: City) {
        guard weatherDatas.filter({$0.location == city && !city.isCurrentLocation }).isEmpty else { return }
        if (weatherDatas[0].location.isCurrentLocation && city.isCurrentLocation) {
            let city = weatherDatas[0].location
            weatherDatas.remove(at: 0)
            CityAgent.removeFromCityList(city: city)
        }
        var weatherData: WeatherData = repository.getDefaultOrCachedWeatherData(for: city)
        weatherData.location = city
        city.isCurrentLocation ? weatherDatas.insert(weatherData, at: 0) : weatherDatas.append(weatherData)
        CityAgent.addToCityList(city: city)
        reloadData(forceUpdate: true)
        CityAgent.emitCityListUpdated()
    }
    
    func onAddCityTapped() {
        self.addedCity = nil
        self.isCitySearchModalPresented = true
    }
    
    func presentSubscriptionView() {
        self.isSubscriptionViewPresented = true
    }
    
    func moveCity(from: IndexSet, to: Int) {
        var cities = CityAgent.getAllCities()
        cities.move(fromOffsets: from, toOffset: to)
        UserDefaults.save(value: cities, for: .cities)
        
        var weatherItems: [WeatherData] = []
        cities.forEach { city in
            if let weatherItem: WeatherData = weatherDatas.first(where: {$0.location.id == city.id}) {
                weatherItems.append(weatherItem)
            }
        }
        weatherDatas = weatherItems
        
        let cachedData = CachableData(data: weatherDatas, dataType: .mutipleCitiesWeatherData)
        FileManager.save(value: cachedData, for: .mutipleCitiesWeatherData)
        
        CityAgent.emitCityListUpdated()
    }
    
    func removeCity(index: Int) {
        withAnimation(.easeOut) {
            let city = weatherDatas[index].location
            weatherDatas.remove(at: index)
            CityAgent.removeFromCityList(city: city)
        }
        CityAgent.emitCityListUpdated()
    }
    
    private func reloadData(forceCache: Bool = false, forceUpdate: Bool = false) {
        Task { [weak self] in
            do {
                if let response: [WeatherData] = try await self?.repository.getMultipleCitiesWeather(for: CityAgent.getAllCities(),forceCache: forceCache, forceUpdate: forceUpdate) {
                    DispatchQueue.main.async {[weak self] in
                        self?.weatherDatas.removeAll()
                        for weatherData in response {
                            self?.weatherDatas.append(weatherData)
                        }
                        CityAgent.emitCityListUpdated()
                    }
                }
            }catch {
                self?.networkFailResponse = error as? NetworkFailResponse
            }
        }
    }
    
    init(isCityListOpen: Binding<Bool>) {
        self._isCityListOpen = isCityListOpen
    }
    
}
