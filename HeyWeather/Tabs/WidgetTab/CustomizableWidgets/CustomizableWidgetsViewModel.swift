//
//  CustomizableWidgetsViewModel.swift
//  HeyWeather
//
//  Created by mohamd yeganeh on 4/27/23.
//


import SwiftUI

class CustomizableWidgetsViewModel: ObservableObject {
    
    let weatherData: WeatherData
    
    @Published var smallWidgetTheme : [WidgetTheme] = []
    @Published var mediumWidgetTheme : [WidgetTheme] = []
    @Published var largeWidgetTheme : [WidgetTheme] = []
    
    @Published var tabIndex : Int = 0

    @Published var isCustomizeActive: Bool = false
    
    @Published var customizingWidgetIndex : Int = 0
    @Published var customizingWidgetFamily: WidgetSize = .small
    
    
    func onAppear() {
        logView()
        loadPreferredDetails()
    }
    
    func loadPreferredDetails() {
        if let allThemes : [WidgetTheme] = UserDefaults.get(for: .allCustomizableThems) {
            smallWidgetTheme = allThemes.filter { $0.forSize == "small" }
            mediumWidgetTheme = allThemes.filter { $0.forSize == "medium" }
            largeWidgetTheme = allThemes.filter { $0.forSize == "large" }
        }
    }
    
    
    private func logView() {
        let viewTitle = Constants.ViewTitles.customizableWidgets
        EventLogger.logViewEvent(view: viewTitle)
    }
    
    
    
    init(weatherData: WeatherData) {
        self.weatherData = weatherData
        self.loadPreferredDetails()
    }
    
}
