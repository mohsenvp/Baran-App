//
//  IntentHandler.swift
//  WidgetIntent
//
//  Created by Kamyar on 10/31/21.
//

import Intents

class IntentHandler: INExtension, CustomizableWidgetConfigIntentHandling, ForecastWidgetConfigIntentHandling, LockScreenWidgetConfigIntentHandling, AQIWidgetConfigIntentHandling{
    

    func provideWidgetCityOptionsCollection(for intent: AQIWidgetConfigIntent) async throws -> INObjectCollection<WidgetCity> {
        return getAllCityForWidgets()
    }
    
    func provideWidgetStyleOptionsCollection(for intent: AQIWidgetConfigIntent) async throws -> INObjectCollection<WidgetStyle> {
        return getAllStylesForWidget(widgetKind: .aqi)
    }
    
    
    // MARK: CustomizableWidget Functions
    func provideWidgetCityOptionsCollection(for intent: CustomizableWidgetConfigIntent) async throws -> INObjectCollection<WidgetCity> {
        return getAllCityForWidgets()
    }
    
    func defaultWidgetCity(for intent: CustomizableWidgetConfigIntent) -> WidgetCity? {
        return getDefaultCityForWidgets()
    }
    
    func provideWidgetStyleOptionsCollection(for intent: CustomizableWidgetConfigIntent) async throws -> INObjectCollection<WidgetStyle> {
        return getAllStylesForWidget(widgetKind: .customizable)
    }
    
    func defaultWidgetStyle(for intent: CustomizableWidgetConfigIntent)  -> WidgetStyle? {
        return getDefaultStyleForWidgets(widgetKind: .customizable)
    }
    
    // MARK: ForecastWidget Functions
    func provideWidgetCityOptionsCollection(for intent: ForecastWidgetConfigIntent) async throws -> INObjectCollection<WidgetCity> {
        return getAllCityForWidgets()
    }
    
    func defaultWidgetCity(for intent: ForecastWidgetConfigIntent) -> WidgetCity? {
        return getDefaultCityForWidgets()
    }
    
    func provideWidgetLookOptionsCollection(for intent: ForecastWidgetConfigIntent) async throws -> INObjectCollection<WidgetStyle> {
        return getAllWidgetLook()
    }
    
    func defaultWidgetLook(for intent: ForecastWidgetConfigIntent) -> WidgetStyle? {
        return getDefaultWidgetLook()
    }
    
    func provideWidgetBackgroundOptionsCollection(for intent: ForecastWidgetConfigIntent) async throws -> INObjectCollection<WidgetStyle> {
        return getAllWidgetBackground()
    }
    
    func defaultWidgetBackground(for intent: ForecastWidgetConfigIntent) -> WidgetStyle? {
        return getDefaultWidgetBackground()
    }
    
    
    // MARK: LockScreenWidget Functions
    func provideWidgetCityOptionsCollection(for intent: LockScreenWidgetConfigIntent) async throws -> INObjectCollection<WidgetCity> {
        return getAllCityForWidgets()
    }
    
    func defaultWidgetCity(for intent: LockScreenWidgetConfigIntent) -> WidgetCity? {
        return getDefaultCityForWidgets()
    }
    
}


extension IntentHandler {
    
    // MARK: - Return all cities and default city
    func getAllCityForWidgets() -> INObjectCollection<WidgetCity> {
        var cities: [City]

        if let citiesData: Data = UserDefaults.init(suiteName: WidgetConstants.appGroupBundleId)?.data(forKey: "cityListItems") {
            do {
                cities = try JSONDecoder().decode([City].self, from: citiesData)
            }catch {
                cities = [City()]
            }
        } else {
            cities = [City()]
        }

        let widgetCities: [WidgetCity] = cities.map { city in
            let widgetCity = WidgetCity(
                identifier: String(city.id),
                display: city.name
            )
            return widgetCity
        }
        
        return INObjectCollection<WidgetCity>(items: widgetCities)
    }
    
    func getDefaultCityForWidgets() -> WidgetCity? {
        var city: City
        if let mainCityData: Data = UserDefaults.init(suiteName: WidgetConstants.appGroupBundleId)?.data(forKey: "mainCity") {
            let decoder = JSONDecoder()
            do {
                city = try decoder.decode(City.self, from: mainCityData)
            }catch {
                city = City()
            }
        } else {
            city = City()
        }
        let widgetCity = WidgetCity(identifier: String(city.id), display: city.isCurrentLocation ? String(localized: "Current Location", table: "CityList") : city.name)
        return widgetCity
    }
    
    // MARK: -  Return all styles for customizable widgets
    func getAllStylesForWidget(widgetKind : WidgetKind) -> INObjectCollection<WidgetStyle> {
        
        if widgetKind == .aqi {
            var widgetStyles : [WidgetStyle] = []
            
            for i in 0..<AQIWidgetStyle.allCases.count {
                
                let widgetStyle = WidgetStyle(identifier: "\(i)", display: AQIWidgetStyle.allCases[i].title() + " \(i > 0 ? "(\(String(localized: "Premium", table: "Premium").uppercased()))" : "")")
                widgetStyles.append(widgetStyle)
            }
            
            return INObjectCollection<WidgetStyle>(items: widgetStyles)
        }
        
        
        var widgetStyles : [WidgetStyle] = []
        for i in 0..<9 {
            if i == 0 {
                widgetStyles.append(WidgetStyle(identifier: "\(i)", display: String(localized: "Style \(i + 1)", table: "Widgets")))
            }else{
                widgetStyles.append(WidgetStyle(identifier: "\(i)", display: String(localized: "Style \(i + 1) (PREMIUM)", table: "Widgets")))
            }
        }

        return INObjectCollection<WidgetStyle>(items: widgetStyles)
    }
    
    func getDefaultStyleForWidgets(widgetKind : WidgetKind) -> WidgetStyle? {
        return WidgetStyle(identifier: "0", display: String(localized: "Style \(1)", table: "Widgets"))
    }
    
    // MARK: -  Return all looks for forecast widgets
    func getAllWidgetLook() -> INObjectCollection<WidgetStyle> {
        
        var widgetLooks: [WidgetStyle]
        
        let s0 = WidgetStyle( identifier: "0", display: WidgetLook.original.title(), subtitle: WidgetLook.original.description(), image: INImage(named: WidgetConstants.WidgetLookIcons.original))
        let s1 = WidgetStyle( identifier: "1", display: WidgetLook.neumorph.title(), subtitle: WidgetLook.neumorph.description(), image: INImage(named: WidgetConstants.WidgetLookIcons.neumorph))
        let s2 = WidgetStyle( identifier: "2", display: WidgetLook.simple.title(), subtitle: WidgetLook.simple.description(), image: INImage(named: WidgetConstants.WidgetLookIcons.simple))
        let s3 = WidgetStyle( identifier: "3", display: WidgetLook.skeumorph.title(), subtitle: WidgetLook.skeumorph.description(), image: INImage(named: WidgetConstants.WidgetLookIcons.skeumorph))
        
        widgetLooks = [s0,s1,s2,s3]
        
        return INObjectCollection<WidgetStyle>(items: widgetLooks)
    }
    
    
    func getDefaultWidgetLook() -> WidgetStyle? {
        return WidgetStyle(identifier: "0", display: WidgetLook.original.title())
    }
    
    // MARK: -  Return all backgrounds for forecast widgets
    func getAllWidgetBackground() -> INObjectCollection<WidgetStyle> {
        
        var widgetLooks: [WidgetStyle]
        
        let s0 = WidgetStyle( identifier: "0", display: WidgetBackground.def.title(), subtitle: nil, image: INImage(named: "bg_def"))
        let s1 = WidgetStyle( identifier: "1", display: WidgetBackground.auto.title(), subtitle: nil, image: INImage(named: "bg_\(WidgetBackground.auto.rawValue)"))
        let s2 = WidgetStyle( identifier: "2", display: WidgetBackground.light.title(), subtitle: nil, image: INImage(named: "bg_\(WidgetBackground.light.rawValue)"))
        let s3 = WidgetStyle( identifier: "3", display: WidgetBackground.dark.title(), subtitle: nil, image: INImage(named: "bg_\(WidgetBackground.dark.rawValue)"))
        let s4 = WidgetStyle( identifier: "4", display: WidgetBackground.blue.title(), subtitle: nil, image: INImage(named: "bg_\(WidgetBackground.blue.rawValue)"))
        let s5 = WidgetStyle( identifier: "5", display: WidgetBackground.teal.title(), subtitle: nil, image: INImage(named: "bg_\(WidgetBackground.teal.rawValue)"))
        let s6 = WidgetStyle( identifier: "6", display: WidgetBackground.orange.title(), subtitle: nil, image: INImage(named: "bg_\(WidgetBackground.orange.rawValue)"))
        let s7 = WidgetStyle( identifier: "7", display: WidgetBackground.red.title(), subtitle: nil, image: INImage(named: "bg_\(WidgetBackground.red.rawValue)"))
        
        widgetLooks = [s0,s1,s2,s3,s4,s5,s6,s7]
        
        return INObjectCollection<WidgetStyle>(items: widgetLooks)
    }
    
    func getDefaultWidgetBackground() -> WidgetStyle? {
        return WidgetStyle( identifier: "0", display: WidgetBackground.def.title())
    }
    
 
}
