//
//  TimeTravelViewModel.swift
//  HeyWeather
//
//  Created by Mohammad Yeganeh on 8/22/23.
//

import SwiftUI


class TimeTravelViewModel: ObservableObject {
    
    @Published var isSubscriptionViewPresented: Bool = false

    @Published var selectedDate: Date = Calendar.current.date(byAdding: .day, value: -10, to: Date.now)!
    @Published var weather: Weather = .init()
    @Published var isDatePickerVisible: Bool = true
    @Published var isLoading: Bool = false
    @Published var city: City
       
    init(city: City) {
        self.city = city
    }

    func getWeather(){
        isLoading = true
        Task { [weak self] in
            do {
                self?.weather = try await Repository().getWeatherHistory(for: self?.city ?? .init(), date: self?.selectedDate ?? .now)
                self?.isLoading = false
                self?.isDatePickerVisible.toggle()
            }catch {
                self?.isLoading = false
            }
        }
    }
    
    func getValue(type: WeatherDetailsViewType) -> String {
        switch type {
        case .wind:
            return  (weather.details.windSpeed ?? 0).localizedWindSpeed
        case .humidity:
            return weather.details.humidityDescription ?? ""
        case .uvIndex:
            return "\(weather.details.uvIndex ?? 0)"
        case .pressure:
            return (weather.details.pressure ?? 0).localizedPressure
        case .dewPoint:
            return (weather.details.dewPoint ?? 0).localizedDewPoint
        case .visibility:
            return (weather.details.visibility ?? 0).localizedVisibility
        case .clouds:
            return weather.details.cloudsDescription ?? ""
        case .precipitation:
            return "\(weather.details.precipitation?.localizedPrecipitation ?? 0)%"
        }
    }
    
    
}
