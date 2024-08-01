//
//  SettingsTabViewModel.swift
//  HeyWeather
//
//  Created by Kamyar on 10/27/21.
//

import Foundation

class SettingsTabViewModel: ObservableObject {
    @Published var currentAppIcon: Int = UserDefaults.get(for: .appIcon) ?? 0
  
    func logView() {
        let viewTitle = Constants.ViewTitles.settingsTab
        EventLogger.logViewEvent(view: viewTitle)
    }
    
    func refreshAppIcon(){
        currentAppIcon = UserDefaults.get(for: .appIcon) ?? 0
    }
}
