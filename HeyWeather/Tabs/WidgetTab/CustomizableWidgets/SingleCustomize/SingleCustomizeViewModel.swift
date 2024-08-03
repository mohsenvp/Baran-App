//
//  SingleCustomizeViewModel.swift
//  HeyWeather
//
//  Created by mohamd yeganeh on 4/27/23.
//


import SwiftUI
import WidgetKit

class SingleCustomizeViewModel: ObservableObject {
    let weatherData: WeatherData
    @Published var edittingTheme: WidgetTheme = .init()
    @Published var widgetIndex : Int = 0
    @Published var widgetFamily: WidgetSize = .small
    
    @Published var selectedBackgroundIndex: Int = 0
    @Published var selectedIconPack: String = "01"
    @Published var selectedFont: String? = nil

    @Published var isImagePickerPresented: Bool = false
    @Published var imageData: Data?
    @Published var edittedImageData: Data?

    @Published var isImageCropperPresented: Bool = false
    @Published var imageCropped: Bool = false
    @Published var isSubscriptionViewPresented: Bool = false
    @Published var selectedTab: Int = 0

        
    func loadPreferredDetails() {
                
        if let allThemes : [WidgetTheme] = UserDefaults.get(for: .allCustomizableThems) {
            var s = ""
            switch widgetFamily {
                case .small :
                    s = "small"
                case .medium :
                    s = "medium"
                default :
                    s = "large"
            }
            edittingTheme = allThemes.first { $0.forSize == s && $0.viewNo == widgetIndex}!
        }
    }
    
    func setPreferredTheme(_ edittingTheme: WidgetTheme, isPremium: Bool) {
        
        let index = widgetIndex
        if var allThemes : [WidgetTheme] = UserDefaults.get(for: .allCustomizableThems) {
            var s = ""
            switch widgetFamily {
                case .small :
                    s = "small"
                case .medium :
                    s = "medium"
                default :
                    s = "large"
            }
            
            let updatedThemeIndex = allThemes.firstIndex(where: { $0.forSize == s && $0.viewNo == index })!
            
            allThemes[updatedThemeIndex] = edittingTheme

            UserDefaults.save(value: allThemes, for: .allCustomizableThems)
        }
        
        WidgetCenter.shared.reloadTimelines(ofKind: WidgetKind.customizable.rawValue)
    }
    
    func setThemeBackgroundColor(index: Int) {//index is -1 if background image is selected
        let colorStyle = Constants.colorStyles[index >= 0 ? index : 0]
        let startColor = colorStyle[0]
        let endColor = colorStyle[1]
        let fontColor = colorStyle[2]
        edittingTheme.colorStartString = startColor.toHexString()
        edittingTheme.colorEndString = endColor.toHexString()
        edittingTheme.fontColorString = fontColor.toHexString()
        if index >= 0 {
            imageData = nil
            edittedImageData = nil
            edittingTheme.backgroundImageName = nil
        }
    }

    
    private func logView() {
        let viewTitle = Constants.ViewTitles.customizableWidgets
        EventLogger.logViewEvent(view: viewTitle)
    }
    
    func onAppear() {
        logView()
        selectedIconPack = edittingTheme.iconSet
        selectedFont = edittingTheme.font
        let startColorString = edittingTheme.colorStartString
        guard let color = Constants.colorStyles.filter({$0[0].toHexString() == startColorString}).first,
              let index = Constants.colorStyles.firstIndex(of: color) else {
            self.selectedBackgroundIndex = -1
            return
        }
        
        if edittingTheme.backgroundImageName != nil {
            self.selectedBackgroundIndex = -1
            self.imageData = FileManager.get(for: edittingTheme.backgroundImageName!)
            self.edittedImageData = self.imageData
            self.edittingTheme.shouldHideBG = true
        }else {
            self.selectedBackgroundIndex = index
        }
    }
    
    init(weatherData: WeatherData, widgetIndex: Int, widgetFamily: WidgetSize) {
        self.weatherData = weatherData
        self.widgetIndex = widgetIndex
        self.widgetFamily = widgetFamily
        self.loadPreferredDetails()
    }
    
    
}
