//
//  WeatherDetailsViewModel.swift
//  HeyWeather
//
//  Created by Kamyar on 12/8/21.
//

import Foundation
import SwiftUI


class WeatherDetailsViewModel: ObservableObject {
    typealias ExtraDetailItem = (id: Int, title: Text, value: String, isLocked: Bool)
    let type: WeatherDetailsType
    let weatherData: WeatherData
    let moons: [MoonDataModel]
    let suns: [SunDataModel]
    var aqiData: AQIData = .init()
    let navigationTitle: Text
    
    
    @AppStorage(Constants.precipitationUnitString, store: Constants.groupUserDefaults) var precipitationUnit: PrecipitationUnit = Constants.defaultPrecipitationUnit
    @Published var selectedWeather: Weather
    @Published var selectedAQI: AQI = AQI()
    @Published var selectedMoon: MoonDataModel = MoonDataModel()
    @Published var selectedSun: SunDataModel = SunDataModel()
    @Published var selectedIndex: Int = 0
    @Published var isShowingHourly = false
    @Published var premium: Premium

    var weathers: [Weather] {
        switch type {
        case .daily:
            return weatherData.dailyForecast
        case .hourly:
            return weatherData.hourlyForecast
        }
    }
    
    var sectionedWeathers: [WeatherSection] {
        switch type {
        case .daily:
            return WeatherData.sectionilizeHourlyData(items: weatherData.getDaily(isPremium: premium.isPremium, isDetail: true))
        case .hourly:
            return WeatherData.sectionilizeHourlyData(items: weatherData.getHourly(isPremium: premium.isPremium, isDetail: true))
        }
    }
    
    var extraDetailItems: [ExtraDetailItem] {
        var items: [ExtraDetailItem] = .init()
        let weather = selectedWeather
        var id = 0
        
        if let clouds = weather.details.cloudsDescription {
            id += 1
            let item = (id: id, Strings.WeatherDetails.getWeatherDetailsTitle(for: .clouds), clouds, false)
            items.append(item)
        }
        if let windSpeed = weather.details.windSpeed {
            id += 1
            let item = (id: id, Strings.WeatherDetails.getWeatherDetailsTitle(for: .wind), windSpeed.localizedWindSpeed, false)
            items.append(item)
        }
        if let humidity = weather.details.humidityDescription {
            id += 1
            let item = (id: id, Strings.WeatherDetails.getWeatherDetailsTitle(for: .humidity), humidity, false)
            items.append(item)
        }
        if let pressure = weather.details.pressure {
            id += 1
            let item = (id: id, Strings.WeatherDetails.getWeatherDetailsTitle(for: .pressure), pressure.localizedPressure, false)
            items.append(item)
        }
        if let uvIndex = weather.details.uvIndex {
            id += 1
            let item = (id: id, Strings.WeatherDetails.getWeatherDetailsTitle(for: .uvIndex), uvIndex.localizedNumber(), false)
            items.append(item)
        }
        
        let aqiItem: ExtraDetailItem = (id: id + 1, Text("AQI", tableName: "AQI"), selectedAQI.value.localizedNumber, true)
        
        items.append(aqiItem)
        
        return items
    }
    
    func getWeatherDetailYOffsets(for height: CGFloat, typeSize: DynamicTypeSize) -> [CGFloat] {
        var offsets = [CGFloat]()
        
        let temperatures = type == .hourly ? weathers.map { $0.temperature.now! } : weathers.map { $0.temperature.max! }
        let max = temperatures.max()!
        let min = temperatures.min()!
        
        let absoluteHeight = height - (type == .hourly ? 102 : typeSize < .xxLarge ? 120 : 145)
        
        
        for weather in weathers {
            let temp = type == .hourly ? weather.temperature.now! : weather.temperature.max!
            let scale: CGFloat = CGFloat(max - temp) / CGFloat(max - min)
            let offset = CGFloat(scale * absoluteHeight)
            offsets.append(offset)
        }
        return offsets
    }
    
    func getAQIs() {
        Task { [weak self] in
            self?.aqiData = try await Repository().getAQI(for: CityAgent.getSelectedCity(), requestItems: [.current, .daily], requestOrigin: .weatherTab)
        }
    }

    func onDateChange() {
        findSelectedIndex()
        selectAQI()
        selectMoon()
        selectSun()
    }
    
    private func findSelectedIndex() {
        if let index = weathers.firstIndex(of: selectedWeather) {
            selectedIndex = index
        }else {
            selectedIndex = 0
        }
    }
    
    private func selectAQI() {
        let date = selectedWeather.date
        if let aqi = aqiData.dailyForecast.filter({$0.utcDate.isOnSameDay(with: date)}).first {
            selectedAQI = aqi
        }else {
            selectedAQI = AQI()
        }
    }
    
    private func selectMoon() {
        if selectedIndex < moons.count { selectedMoon = moons[selectedIndex] }
    }
    
    private func selectSun() {
        if selectedIndex < suns.count { selectedSun = suns[selectedIndex] }
    }
    
    
    
    init(type: WeatherDetailsType, tappedWeather:Weather?,  weatherData: WeatherData, aqiData: AQIData, astronomies: [Astronomy], premium: Premium) {
        self.type = type
        self.weatherData = weatherData
        switch type {
        case .daily:
            selectedWeather = tappedWeather ?? weatherData.getDaily(isPremium: premium.isPremium, isDetail: true).first!
            navigationTitle = Text("DAILY FORECAST", tableName: "WeatherTab")
            isShowingHourly = weatherData.getHourly(for: (tappedWeather ?? weatherData.dailyForecast.first!).localDate, isPremium: premium.isPremium, isDetail: true).count > 0
        case .hourly:
            isShowingHourly = false
            selectedWeather = tappedWeather ?? weatherData.getHourly(isPremium: premium.isPremium, isDetail: true).first!
            navigationTitle = Text("HOURLY FORECAST", tableName: "WeatherTab")
        }
        
        self.aqiData = aqiData
        self.moons = astronomies.map { $0.moon }
        self.suns = astronomies.map { $0.sun }
        self.premium = premium
        self.onDateChange()
    }
}
