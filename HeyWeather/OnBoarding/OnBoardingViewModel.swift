//
//  OnBoardingViewModel.swift
//  HeyWeather
//
//  Created by MYeganeh on 4/15/23.
//

import Foundation
import UserNotifications
import UIKit

class OnBoardingViewModel: ObservableObject {
    
    @Published var isCitySearchModalPresented = false
    @Published var chosenCity: City?
    @Published var isLoading : Bool = false
    
    
    
    func logView() {
        let viewTitle = Constants.ViewTitles.welcomeViews
        EventLogger.logViewEvent(view: viewTitle)
    }
    
    
    func startLocatingUser() {
        isLoading = true
        let repository = Repository()
        Task { [weak self] in
            let city = await repository.getNewLocation()
            self?.isLoading = false
            guard let city = city else {
                if let _ : [City] = UserDefaults.get(for: .cities) {
                    self?.navigateMainTab()
                }else {
                    self?.presentCitySearchModal()
                }
                return
            }
            CityAgent.saveMainCity(city: city)
            CityAgent.removeFromCityList(city: city)
            CityAgent.addToCityList(city: city)
            self?.navigateMainTab()
        }
    }
    
    func setMainCity(city: City) {
        CityAgent.addToCityList(city: city)
        CityAgent.saveMainCity(city: city)
    }
    
    func navigateMainTab() {
        UserDefaults.save(value: false, for: .isFirstLaunch)
    }
    
    func presentCitySearchModal() {
        self.isCitySearchModalPresented = true
    }
    
    init() {}
}
