//
//  HeyWeatherApp.swift
//  HeyWeather
//
//  Created by Kamyar on 10/10/21.
//

import SwiftUI

@main
struct HeyWeatherApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    @AppStorage(UserDefaultsKey.isFirstLaunch.rawValue, store: Constants.groupUserDefaults) var isFirstLaunch = true
    
    var body: some Scene {
        WindowGroup {
            if isFirstLaunch {
                OnBoardingView()
            }else{
                MainTab()
            }
        }
    }
    
    init() {
        
        if isFirstLaunch {
            authorizeDevice()
            loadDefaultThemes()
        }

        countUpLaunches()
    }
    
    private func authorizeDevice() {
        Task {
            do {
                try await Repository().authorizeDevice()
            }catch {
                
            }
        }
    }
    
    func loadDefaultThemes(){
        
        let t1 = WidgetTheme(colorStart:  #colorLiteral(red: 0.03921568627, green: 0.3019607843, blue: 0.4078431373, alpha: 1), colorEnd:  #colorLiteral(red: 0.03137254902, green: 0.5137254902, blue: 0.5843137255, alpha: 1), iconSet: "03", fontColor:  #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1))
        let t2 = WidgetTheme(colorStart:  #colorLiteral(red: 0.1647058824, green: 0.1843137255, blue: 0.3098039216, alpha: 1), colorEnd:  #colorLiteral(red: 0.568627451, green: 0.4980392157, blue: 0.7019607843, alpha: 1), iconSet: "01", fontColor:  #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1))
        let t3 = WidgetTheme(colorStart:  #colorLiteral(red: 0.8196078431, green: 0.3019607843, blue: 0.4470588235, alpha: 1), colorEnd:  #colorLiteral(red: 1, green: 0.6705882353, blue: 0.6705882353, alpha: 1), iconSet: "14", fontColor:  #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1))
        let t4 = WidgetTheme(colorStart:  #colorLiteral(red: 0.9490196078, green: 0.8039215686, blue: 0.3607843137, alpha: 1), colorEnd:  #colorLiteral(red: 0.9490196078, green: 0.5725490196, blue: 0.1137254902, alpha: 1), iconSet: "27", fontColor:  #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1))
        let t5 = WidgetTheme(colorStart:  #colorLiteral(red: 0.1137254902, green: 0.1098039216, blue: 0.8980392157, alpha: 1), colorEnd:  #colorLiteral(red: 0.2745098039, green: 0.2862745098, blue: 1, alpha: 1), iconSet: "18", fontColor:  #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1))
        let t6 = WidgetTheme(colorStart:  #colorLiteral(red: 0.4392156899, green: 0.01176470611, blue: 0.1921568662, alpha: 1), colorEnd:  #colorLiteral(red: 0.7254901961, green: 0, blue: 0.3568627451, alpha: 1), iconSet: "21", fontColor:  #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1))
        let t7 = WidgetTheme(colorStart:  #colorLiteral(red: 0.9647058824, green: 0.9450980392, blue: 0.9450980392, alpha: 1), colorEnd:  #colorLiteral(red: 0.6862745098, green: 0.8274509804, blue: 0.8862745098, alpha: 1), iconSet: "05", fontColor:  #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1))
        let t8 = WidgetTheme(colorStart:  #colorLiteral(red: 0.3647058824, green: 0.2196078431, blue: 0.568627451, alpha: 1), colorEnd:  #colorLiteral(red: 0.9764705882, green: 0.5803921569, blue: 0.09019607843, alpha: 1), iconSet: "10", fontColor:  #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1))
        let t9 = WidgetTheme(colorStart:  #colorLiteral(red: 0.1921568662, green: 0.007843137719, blue: 0.09019608051, alpha: 1), colorEnd:  #colorLiteral(red: 0.1921568662, green: 0.007843137719, blue: 0.09019608051, alpha: 1), iconSet: "09", fontColor:  #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1))
        
        let defaultThemes = [t1,t2,t3,t4,t5,t6,t7,t8,t9]
        
        var allThems : [WidgetTheme] = []
        
        for i in 0..<defaultThemes.count {
            var t = defaultThemes[i]
            t.viewNo = i
            t.forSize = "small"
            allThems.append(t)
        }
        for i in 0..<defaultThemes.count {
            var t = defaultThemes[i]
            t.viewNo = i
            t.forSize = "medium"
            allThems.append(t)
        }
        for i in 0..<defaultThemes.count {
            var t = defaultThemes[i]
            t.viewNo = i
            t.forSize = "large"
            allThems.append(t)
        }

        UserDefaults.save(value: allThems, for: .allCustomizableThems)
    }
}

extension HeyWeatherApp {
    fileprivate func countUpLaunches() {
        let appLaunches: Int = UserDefaults.get(for: .appLaunches) ?? 0
        UserDefaults.save(value: appLaunches + 1, for: .appLaunches)
    }
}
