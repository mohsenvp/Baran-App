//
//  SearchCityViewModel.swift
//  HeyWeather
//
//  Created by Kamyar on 10/30/21.
//

import Foundation
import SwiftUI

class SearchCityViewModel: ObservableObject {
    let repository: Repository = .init()
    @Published var query: String = .init()
    @Published var cities = [City]()
    @Published var networkFailResponse: NetworkFailResponse?
    @Published var isAlertPresented: Bool = false
    @Binding var isPresented: Bool
    @Binding var chosenCity: City?
    @Published var isSearching: Bool = false
    var alertType: SearchCityAlertType = .cityLimit
    
    func search(currentValue : String) {
        cities = []
        isSearching = true
        Task { [weak self] in
            do {
                let newCities = try await NetworkManager.shared.getCities(q: currentValue)
                if (currentValue == self?.query) {
                    self?.cities = newCities
                    self?.isSearching = false
                }
            }catch {
                self?.networkFailResponse = error as? NetworkFailResponse
            }
        }
    }
    
    func logView() {
        let viewTitle = Constants.ViewTitles.searchCityView
        EventLogger.logViewEvent(view: viewTitle)
    }
    
    @MainActor
    func chooseCity(city: City) {
        chosenCity = city
        isPresented = false
    }
    
    func chooseCurrentLocation() {
        Task { [weak self] in
            let city = await self?.repository.getNewLocation()
            guard let city = city else {
                await self?.presentAlert(for: .locationPermission)
                return
            }
            await self?.chooseCity(city: city)
        }
    }
    
    @MainActor
    func presentAlert(for type: SearchCityAlertType) {
        alertType = type
        isAlertPresented = true
    }
    
    init(isPresented: Binding<Bool>, chosenCity: Binding<City?>) {
        UITextField.appearance().clearButtonMode = .whileEditing
        _isPresented = isPresented
        _chosenCity = chosenCity
        search(currentValue: "")
    }
}

enum SearchCityAlertType {
    case cityLimit
    case locationPermission
}
