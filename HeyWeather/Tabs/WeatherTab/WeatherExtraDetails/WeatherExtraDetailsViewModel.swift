//
//  WeatherExtraDetailsViewModel.swift
//  HeyWeather
//
//  Created by MYeganeh on 4/9/23.
//

import Foundation
import SwiftUI
import SwiftUICharts

class WeatherExtraDetailsViewModel: ObservableObject {
    let type: WeatherDetailsViewType
    let weatherData: WeatherData
    @ObservedObject var premium: Premium
    
    
    init(type: WeatherDetailsViewType, weatherData: WeatherData, premium: Premium) {
        self.type = type
        self.weatherData = weatherData
        self.premium = premium
    }
    
    func getChartData(dataType: WeatherTabNavigationLink) -> [ExtraDetailChartData]{
        let data = dataType == .hourly ? weatherData.getHourly(for: .now, isPremium: premium.isPremium, isDetail: false) : weatherData.dailyForecast
        let xAxixCount = dataType == .hourly ? 10 : 7
        var chartData: [ExtraDetailChartData] = []
        switch type {
        case .wind:
            chartData = Array(data.compactMap({
                ExtraDetailChartData(
                    value: $0.details.windSpeed?.convertedSpeed() ?? 0,
                    xAxisLabel: dataType == .daily ? $0.date.shortWeekday : $0.date.localizedHour(withAmPm: false)
                )
            }))
        case .humidity:
            chartData = Array(data.compactMap({
                ExtraDetailChartData(
                    value: Double($0.details.humidity ?? 0),
                    xAxisLabel: dataType == .daily ? $0.date.shortWeekday : $0.date.localizedHour(withAmPm: false)
                )
            }))
        case .uvIndex:
            chartData = Array(data.compactMap({
                ExtraDetailChartData(
                    value: Double($0.details.uvIndex ?? 0),
                    xAxisLabel: dataType == .daily ? $0.date.shortWeekday : $0.date.localizedHour(withAmPm: false)
                )
            }))
        case .pressure:
            data.forEach { item in
                chartData.append(ExtraDetailChartData(
                    value: item.details.pressure?.convertedPressure() ?? 0,
                    xAxisLabel: dataType == .daily ? item.date.shortWeekday : item.date.localizedHour(withAmPm: false)
                ))
            }
        case .dewPoint:
            data.forEach { item in
                chartData.append(ExtraDetailChartData(
                    value: item.details.dewPoint?.convertedDewPoint() ?? 0,
                    xAxisLabel: dataType == .daily ? item.date.shortWeekday : item.date.localizedHour(withAmPm: false)
                ))
            }
        case .visibility:
            data.forEach { item in
                chartData.append(ExtraDetailChartData(
                    value: (item.details.visibility?.convertedDistance() ?? 0) * Double.random(in: 1..<1.01), //This is done in order to prevent straight line in chart
                    xAxisLabel: dataType == .daily ? item.date.shortWeekday : item.date.localizedHour(withAmPm: false)
                ))
            }
        case .clouds:
            chartData = Array(data.compactMap({
                ExtraDetailChartData(
                    value: Double($0.details.clouds ?? 0),
                    xAxisLabel: dataType == .daily ? $0.date.shortWeekday : $0.date.localizedHour(withAmPm: false)
                )
            }))
        case .precipitation:
            chartData = Array(data.compactMap({
                ExtraDetailChartData(
                    value: $0.details.precipitation?.convertedPrecipitation() ?? 0,
                    xAxisLabel: dataType == .daily ? $0.date.shortWeekday : $0.date.localizedHour(withAmPm: false)
                )
            }))
            
        }
        if chartData.count > xAxixCount {
            return Array(chartData.prefix(xAxixCount))
        }
        return chartData
    }
    
    
    var todayData: String {
        switch type {
        case .wind:
            return  (weatherData.today.details.windSpeed ?? 0).localizedWindSpeed
        case .humidity:
            return weatherData.today.details.humidityDescription ?? ""
        case .uvIndex:
            return "\(weatherData.today.details.uvIndex ?? 0)"
        case .pressure:
            return (weatherData.today.details.pressure ?? 0).localizedPressure
        case .dewPoint:
            return (weatherData.today.details.dewPoint ?? 0).localizedDewPoint
        case .visibility:
            return (weatherData.today.details.visibility ?? 0).localizedVisibility
        case .clouds:
            return weatherData.today.details.cloudsDescription ?? ""
        case .precipitation:
            return "\(weatherData.today.details.precipitation ?? 0)"
        }
    }
    
    var chartUnit: TouchUnit {
        switch type {
        case .wind:
            @AppStorage(Constants.speedUnitString, store: Constants.groupUserDefaults) var unit: String = Constants.defaultSpeedUnit.rawValue
            return .suffix(of: unit)
        case .humidity:
            return .suffix(of: Constants.percent)
        case .uvIndex:
            return .none
        case .pressure:
            @AppStorage(Constants.pressureUnitString, store: Constants.groupUserDefaults) var unit: String = Constants.defaultPressureUnit.rawValue
            return .suffix(of: unit)
        case .dewPoint:
            @AppStorage(Constants.tempUnitString, store: Constants.groupUserDefaults) var unit: String = Constants.defaultTempUnit.rawValue
            return .suffix(of: unit)
        case .visibility:
            @AppStorage(Constants.distanceUnitString, store: Constants.groupUserDefaults) var unit: String = Constants.defaultDistanceUnit.rawValue
            return .suffix(of: unit)
        case .clouds:
            return .none
        case .precipitation:
            @AppStorage(Constants.precipitationUnitString, store: Constants.groupUserDefaults) var unit: String = Constants.defaultPrecipitationUnit.rawValue
            return .suffix(of: unit)
        }
    }
}
