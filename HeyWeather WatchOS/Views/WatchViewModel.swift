//
//  HomeTabViewModel.swift
//  HeyWeather
//
//  Created by Mohammad Yeganeh on 8/8/23.
//

import Foundation
import SwiftUI
import WidgetKit

class WatchViewModel: ObservableObject {
    
    let repository: Repository = Repository()

    @Published var city: City? = CityAgent.getMainCity()
    @Published var weatherData: WeatherData = WeatherData()
//    @Published var isWeatherRedacted: Bool = true
    @Published var isAQIRedacted: Bool = true
    @Published var aqiData: AQIData = .init()
    @Published var dataModeSheetPresented: Bool = false
    @Published var dataMode: WatchDataMode = .weather
    @Published var astronomy: Astronomy = Astronomy()
    @Published var alertViewShown: Bool = false
    @Published var preferredCompactColumn: NavigationSplitViewColumn = .detail
    @Published var networkFailResponse: NetworkFailResponse = .outOfSync

    //city list page values
    @Published var weatherDatas = [WeatherData]()
    @Published var cities: [City] = CityAgent.getAllCities()
    @Published var premium: Bool = UserDefaults.get(for: .premium) ?? false

    @Published var weatherRedactedReason: RedactionReasons = .init()
    var connectivity: Connectivity = .shared
   
    
    var textColor: Color {
        AnimatedWeatherBackground.getTextColor(
            sunrise: astronomy.sun.sunrise,
            sunset: astronomy.sun.sunset,
            weather: weatherData.today
        )
    }
    

    var activeDetailValue: String {
        switch dataMode {
        case .weather:
            return ""
        case .windSpeed:
            return weatherData.today.details.windSpeed?.localizedWindSpeed ?? 0.localizedNumber
        case .humidity:
            return (weatherData.today.details.humidity?.localizedNumber ?? 0.localizedNumber) + Constants.percent
        case .pressure:
            return weatherData.today.details.pressure?.localizedPressure ?? 0.localizedPressure
        case .uvIndex:
            return weatherData.today.details.uvIndex?.localizedNumber() ?? 0.localizedNumber
        case .dewPoint:
            return weatherData.today.details.dewPoint?.localizedTemp ?? 0.localizedTemp
        case .visibility:
            return weatherData.today.details.visibility?.localizedVisibility ?? 0.localizedVisibility
        case .clouds:
            return (weatherData.today.details.clouds?.localizedNumber ?? 0.localizedNumber) + Constants.percent
        case .precipitation:
            return (weatherData.today.details.pop?.localizedNumber ?? 0.localizedNumber) + Constants.percent
        }
    }

    init() {
        self.weatherRedactedReason = .invalidated
        self.alertViewShown = false
        
        guard let _: String = UserDefaults.get(for: .uniqueId) else {
            networkFailResponse = .outOfSync
            alertViewShown.toggle()
            return
        }
        guard let _: String = UserDefaults.get(for: .userAgent) else {
            networkFailResponse = .outOfSync
            alertViewShown.toggle()
            return
        }
        if city == nil {
            networkFailResponse = .outOfSync
            alertViewShown.toggle()
            return
        }
        CityAgent.saveSelectedCity(city: city!)
        updateLocationAndUpdateData()

    }

    
    
    func reloadValues(){
        
        let uniqueId: String = UserDefaults.get(for: .uniqueId) ?? ""
        
        if uniqueId.isEmpty {
            networkFailResponse = .outOfSync
            alertViewShown.toggle()
            return
        }
        weatherRedactedReason = .invalidated
        alertViewShown = false
        cities = CityAgent.getAllCities()
        
        city = CityAgent.getMainCity()
        if city?.isCurrentLocation == true {
            city = cities.first(where: {$0.isCurrentLocation})
            if CityAgent.getMainCity().isCurrentLocation {
                CityAgent.saveMainCity(city: city!)
            }
        }
        
        
       
        if city == nil {
            networkFailResponse = .outOfSync
            alertViewShown.toggle()
            return
        }
        CityAgent.saveSelectedCity(city: city!)
        premium = UserDefaults.get(for: .premium) ?? false
        updateAstronomy(for: city!, forceUpdate: true)
        updateWeather(for: city!, forceUpdate: true)
        updateAQI(for: city!, forceUpdate: true)
        updateWeatherForCityList(forceUpdate: true)
        WidgetCenter.shared.invalidateConfigurationRecommendations()
    }
    
    
    func updateLocationAndUpdateData() {
        
        updateData()
//        let city: City = CityAgent.getMainCity()
//        if (city.isCurrentLocation) {
//            Task { [weak self] in
//                do {
//                    let c = try await self?.repository.getNewLocation()
//                    if let city = c {
//                        CityAgent.saveMainCity(city: city)
//                        DispatchQueue.main.async { [weak self] in
//                            self?.updateData(forSameCity: true)
//                        }
//                    }else {
//                        DispatchQueue.main.async { [weak self] in
//                            self?.updateData(forSameCity: true)
//                        }
//                    }
//                }catch {
//                    print(error.localizedDescription)
//                    DispatchQueue.main.async { [weak self] in
//                        self?.networkFailResponse = .outOfSync
//                    }
//                }
//            }
//            
//        }else {
//            self.updateData(forSameCity: true)
//        }
    }
    
    
    func getChartData(hourly: Bool) -> [SimpleChartData] {
        let data = hourly ? weatherData.getHourly(for: .now, isPremium: false, isDetail: false) : weatherData.dailyForecast
        var chartData: [SimpleChartData] = []
        var xAxixCount = 7
        
        switch dataMode {
        case .weather:
            return []
        case .windSpeed:
            xAxixCount = 5
            
            chartData = Array(data.compactMap({
                SimpleChartData(
                    date: $0.localDate,
                    value: $0.details.windSpeed?.convertedSpeed() ?? 0,
                    value2: Double($0.details.windDegree ?? 0)
                    )
            }))
        case .humidity:
            chartData = Array(data.compactMap({
                SimpleChartData(
                    date: $0.localDate,
                    value: Double($0.details.humidity ?? 0)
                    )
            }))
        case .pressure:
            chartData = Array(data.compactMap({
                SimpleChartData(
                    date: $0.localDate,
                    value: $0.details.pressure?.convertedPressure() ?? 0
                    )
            }))
        case .uvIndex:
            chartData = Array(data.compactMap({
                SimpleChartData(
                    date: $0.localDate,
                    value: $0.details.uvIndex ?? 0
                    )
            }))
        case .dewPoint:
            xAxixCount = 5
            chartData = Array(data.compactMap({
                SimpleChartData(
                    date: $0.localDate,
                    value: $0.details.dewPoint?.localizedTempValue ?? 0
                    )
            }))
        case .visibility:
            xAxixCount = 5
            chartData = Array(data.compactMap({
                SimpleChartData(
                    date: $0.localDate,
                    value: $0.details.visibility?.convertedDistance() ?? 0
                    )
            }))
        case .clouds:
            chartData = Array(data.compactMap({
                SimpleChartData(
                    date: $0.localDate,
                    value: Double($0.details.clouds ?? 0)
                    )
            }))
        case .precipitation:
            xAxixCount = 4
            chartData = Array(data.compactMap({
                SimpleChartData(
                    date: $0.localDate,
                    value: Double($0.details.pop ?? 0),
                    value2: $0.details.precipitation ?? 0
                    )
            }))
        }
        if chartData.count > xAxixCount {
            return Array(chartData.prefix(xAxixCount))
        }
        return chartData
    }
    
    
    func onCityChanged() {
        guard let city = city else { return }
        CityAgent.saveSelectedCity(city: city)
        if let savedWeatherData = weatherDatas.first(where: {$0.location.id == city.id}) {
            weatherData = savedWeatherData
        }
        updateData()
    }
    
    func nextDataMode(){
        withAnimation(.linear(duration: 0.1)){
            dataMode = dataMode.next
        }
    }
    
    func updateData(forceUpdateWeather: Bool = false, forceCache: Bool = false) {
        guard let city = self.city else {
            networkFailResponse = .outOfSync
            alertViewShown.toggle()
            return
        }
        self.updateWeather(for: city, forceUpdate: forceUpdateWeather, forceCache: forceCache)
        self.updateAstronomy(for: city, forceUpdate: forceUpdateWeather, forceCache: forceCache)
        self.updateAQI(for: city, forceUpdate: forceUpdateWeather, forceCache: forceCache)
        self.updateWeatherForCityList()
    }
    

    private func updateWeather(for city: City, forceUpdate: Bool = false, forceCache: Bool = false) {
        weatherRedactedReason = .invalidated
        
        Task { [weak self] in
            do {
                let data = try await self?.repository.getWeather(
                    for: city,
                    requestItems: WeatherRequestItem.allCases,
                    requestOrigin: .appleWatch,
                    forceUpdate : forceUpdate,
                    forceCache: forceCache
                ) ?? .init()
                await self?.updateWeatherData(weatherData: data)
            }catch {
                DispatchQueue.main.async { [weak self] in
                    if let e = error as? NetworkFailResponse {
                        self?.networkFailResponse = e
                        self?.alertViewShown.toggle()
                        self?.weatherRedactedReason = .init()
                    }
                }
                
            }
        }
    }
    
    @MainActor
    private func updateWeatherData(weatherData: WeatherData) {
        withAnimation {
            self.weatherData = weatherData
        }
        
        
        //Update this weather data item inside MultiWeather Data and in cache
        //todo -> move to a better place like repository
        let weatherDataIndex = weatherDatas.firstIndex(where: {$0.location.id == city?.id}) ?? 0
        if weatherDatas.count > weatherDataIndex {
            weatherDatas[weatherDataIndex] = weatherData
            let cachedData = CachableData(data: weatherDatas, dataType: .mutipleCitiesWeatherData)
            FileManager.save(value: cachedData, for: .mutipleCitiesWeatherData)
        }
       
        
        
        WidgetCenter.shared.reloadAllTimelines()
        DispatchQueue.main.asyncAfter(deadline: .now() + 3, execute: {
            self.weatherRedactedReason = .init()
        })
    }
    
    private func updateWeatherForCityList(forceUpdate: Bool = false) {
        Task { [weak self] in
            do {
                let response: [WeatherData]? = try await self?.repository.getMultipleCitiesWeather(for: self?.cities ?? [], forceUpdate: forceUpdate)
                DispatchQueue.main.async { [weak self] in
                    self?.weatherDatas.removeAll()
                    self?.weatherDatas = response ?? []
                }
            }catch {
            }
        }
    }
    
    private func updateAstronomy(for city: City, forceUpdate: Bool = false, forceCache: Bool = false) {
        let data = self.repository.getAstronomy(city: city, count: 28, timeZone: self.weatherData.timezone ).first ?? .init()
        self.astronomy = data
    }
    
   
    private func updateAQI(for city: City, forceUpdate: Bool = false, forceCache: Bool = false) {
        self.isAQIRedacted = true
        Task { [weak self] in
            do {
                let data = try await self?.repository.getAQI(
                    for: city,
                    requestItems: [.current],
                    requestOrigin: .appleWatch,
                    forceUpdate: forceUpdate,
                    forceCache: forceCache
                ) ?? .init()
                DispatchQueue.main.async { [weak self] in
                    self?.isAQIRedacted = false
                    self?.aqiData = data
                }
            }catch {
            }
        }
    }
    
    
    func getWeatherForCities(){
        weatherDatas.removeAll()
        for city in cities {
            var weatherData = WeatherData()
            weatherData.location = city
            weatherDatas.append(weatherData)
            loadWeather(for: city)
        }
    }
    
    private func loadWeather(for city: City) {
        let index = cities.firstIndex(of: city)!
        Task { [weak self] in
            do {
                let data = try await self?.repository.getWeather(
                    for: city,
                    requestItems: WeatherRequestItem.allCases,
                    requestOrigin: .appleWatch
                ) ?? .init()
                DispatchQueue.main.async { [weak self] in
                    self?.weatherDatas[index] = data
                }
            }catch {
               
            }
        }
    }
    
}
