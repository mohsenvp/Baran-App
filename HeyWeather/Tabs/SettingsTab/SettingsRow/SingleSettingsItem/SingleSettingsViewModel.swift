//
//  SingleSettingsViewModel.swift
//  HeyWeather
//
//  Created by Kamyar on 11/16/21.
//
import SwiftUI
import Foundation

class SingleSettingsViewModel: ObservableObject {
    @Published var isPremium: Bool = false
    @Published var weatherDataSources: [WeatherDataSource] = [WeatherDataSource]()
    @Published var aqiDataSource: [AQIDataSource] = [AQIDataSource]()
    @Published var currentWeatherDataSource: WeatherDataSource = DataSourceAgent.getCurrentWeatherDataSource()
    @Published var currentAQIDataSource: AQIDataSource = DataSourceAgent.getCurrentAQIDataSource()
    
    var type: SettingsRowType
    var timeFormat = TimeFormat.getUserTimeFormat()
    var appearance: AppAppearance = UserDefaults.get(for: .appAppearance) ?? .auto
    var currentLanguage = LocalizeHelper.shared.currentLanguage
    var currentAppIcon: Int = UserDefaults.get(for: .appIcon) ?? 0
    // MARK: Getters
    
    func loadUnit(for type: AppUnit) -> AppUnitLogic {
        switch type {
        case .temperature:
            guard let savedUnit: String = UserDefaults.get(for: .tempUnit),
                  let unit = TemperatureUnit(rawValue: savedUnit) else {
                      return TemperatureUnit.celsius
                  }
            return unit
        case .speed:
            guard let savedUnit: String = UserDefaults.get(for: .speedUnit),
                  let unit = SpeedUnit(rawValue: savedUnit) else {
                return SpeedUnit.kmph
            }
            return unit
        case .distance:
            guard let savedUnit: String = UserDefaults.get(for: .distanceUnit),
                  let unit = DistanceUnit(rawValue: savedUnit) else {
                return DistanceUnit.km
            }
            return unit
        case .pressure:
            guard let savedUnit: String = UserDefaults.get(for: .pressureUnit),
                  let unit = PressureUnit(rawValue: savedUnit) else {
                return PressureUnit.hPa
            }
            return unit
        case .precipitation:
            guard let savedUnit: String = UserDefaults.get(for: .precipitationUnit),
                  let unit = PrecipitationUnit(rawValue: savedUnit)else {
                return PrecipitationUnit.mm
            }
            return unit
        }
    }
    

    
    func getDataSources() {
        Task { [weak self] in
            do {
                let dataSources = try await Repository().getDataSources()
                self?.weatherDataSources = dataSources.weatherDataSource
                
                if let selectedWeatherDataSource = self?.weatherDataSources.first(where: { $0.selected }) {
                    DataSourceAgent.setSelectedWeatherDataSource(dataSource: selectedWeatherDataSource)
                    self?.currentWeatherDataSource = selectedWeatherDataSource
                }
                
                self?.aqiDataSource = dataSources.aqiDataSource
                if let selectedAQIDataSource = self?.aqiDataSource.first(where: { $0.selected }) {
                    DataSourceAgent.setSelectedAQIDataSource(dataSource: selectedAQIDataSource)
                    self?.currentAQIDataSource = selectedAQIDataSource
                }
              
            } catch {
                
            }
        }
    }
    
    // MARK: Setters
    
    func setAppUnit(value: AppUnitLogic,for unit: AppUnit) {
        switch unit {
        case .temperature:
            UserDefaults.save(value: (value as! TemperatureUnit).rawValue, for: .tempUnit)
        case .speed:
            UserDefaults.save(value: (value as! SpeedUnit).rawValue, for: .speedUnit)
        case .distance:
            UserDefaults.save(value: (value as! DistanceUnit).rawValue, for: .distanceUnit)
        case .pressure:
            UserDefaults.save(value: (value as! PressureUnit).rawValue, for: .pressureUnit)
        case .precipitation:
            UserDefaults.save(value: (value as! PrecipitationUnit).rawValue, for: .precipitationUnit)
        }
        NotificationCenter.default.post(name: NSNotification.Name(Constants.shouldUpdateWeatherPublisherName), object: nil)
    }
    
    func setValue<T: Codable>(value: T, for type: SettingsRowType) {
        switch type {
        case .timeFormat:
            UserDefaults.save(value: value, for: .timeFormat)
            timeFormat = value as! TimeFormatType
            NotificationCenter.default.post(name: NSNotification.Name(Constants.shouldUpdateWeatherPublisherName), object: nil)
        case .appIcon:
            UserDefaults.save(value: value, for: .appIcon)
        case .language:
            if value is AppLanguage {
                LocalizeHelper.shared.setLanguage(language: value as! AppLanguage)
            }
        case .appearance:
            UserDefaults.save(value: value, for: .appAppearance)
            
        default:
            return
        }
    }
    

    func setNewLanguage(language: AppLanguage) {
        LocalizeHelper.shared.setLanguage(language: language)
        self.currentLanguage = language
    }
    
    func setNewWeatherDataSource(dataSource: WeatherDataSource) {
        DataSourceAgent.setCurrentWeatherDataSource(dataSource: dataSource)
        self.currentWeatherDataSource = dataSource
    }
    
    func setNewAQIDataSource(dataSource: AQIDataSource) {
        DataSourceAgent.setCurrentAQIDataSource(dataSource: dataSource)
        self.currentAQIDataSource = dataSource
    }
    
    
    func setNewAppearance(appearance: AppAppearance) {
        switch(appearance) {
        case .light:
            AppState.shared.colorScheme = .light
        case .dark:
            AppState.shared.colorScheme = .dark
        case .auto:
            AppState.shared.colorScheme = nil
        }
        self.appearance = appearance
        setValue(value: appearance, for: .appearance)
    }
    
    func setAppIcon(index: Int) {
        let name = "AppIcon-\(index)"
        setValue(value: index, for: .appIcon)

        UIApplication.shared.setAlternateIconName(name) { error in
            if error != nil && UIApplication.shared.responds(to: #selector(getter: UIApplication.supportsAlternateIcons)) && UIApplication.shared.supportsAlternateIcons {
                typealias setAlternateIconName = @convention(c) (NSObject, Selector, NSString, @escaping (NSError) -> ()) -> ()
                let selectorString = "_setAlternateIconName:completionHandler:"
                let selector = NSSelectorFromString(selectorString)
                let imp = UIApplication.shared.method(for: selector)
                let method = unsafeBitCast(imp, to: setAlternateIconName.self)
                method(UIApplication.shared, selector, name as NSString, { _ in })
                
            }
            
        }
    }
    
    
    init(type: SettingsRowType, isPremium: Bool) {
        self.type = type
        self.isPremium = isPremium
    }
}




