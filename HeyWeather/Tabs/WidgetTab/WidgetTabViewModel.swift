//
//  WidgetTabViewModel.swift
//  HeyWeather
//
//  Created by Kamyar on 10/27/21.
//

import Foundation

class WidgetTabViewModel: ObservableObject {
    @Published var weatherData: WeatherData = Repository().getDefaultOrCachedWeatherData()
    @Published var aqiData: AQIData = .init()
    @Published var astronomy: Astronomy = .init()
    @Published var networkFailResponse: NetworkFailResponse?
    
    func loadData() {
        let mainCity = CityAgent.getSelectedCity()
        let repository = Repository()
        
        self.astronomy = repository.getAstronomy(city: mainCity, timeZone: weatherData.timezone ).first ?? .init()

        Task { [weak self] in
            do {
                self?.weatherData = try await repository.getWeather(for: mainCity, requestItems: WeatherRequestItem.allCases, requestOrigin: .widgetTab, forceCache: true)
                self?.aqiData = try await repository.getAQI(for: mainCity, requestItems: [.current], requestOrigin: .widgetTab)
                

            }catch {
                self?.networkFailResponse = error as? NetworkFailResponse
            }
        }
   
        logView()
    }
    
    private func logView() {
        let viewTitle = Constants.ViewTitles.widgetTab
        EventLogger.logViewEvent(view: viewTitle)
    }
}
