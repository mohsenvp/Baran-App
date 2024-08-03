//
//  CityAgnet.swift
//  HeyWeather
//
//  Created by Kamyar on 10/11/21.
//

import Foundation
import CoreLocation

struct CityAgent {
    
    static func retreiveCity(location: CLLocation) async -> City? {
        let geocoder = CLGeocoder()
        do {
            let placemarks = try await geocoder.reverseGeocodeLocation(location, preferredLocale: .current)
            if let placemark = placemarks.last {
                let country = placemark.country ?? ""
                let street = placemark.name ?? ""
                let city  = placemark.locality ?? placemark.administrativeArea ?? ""
                let location = Location(lat: location.coordinate.latitude, long: location.coordinate.longitude)
                let c = City(id: 0, name: "\(city), \(street)", state: "", country: country, location: location, placeMarkCityName: city)
                return c
            }
        } catch {
            print(error.localizedDescription)
            return nil
        }
        return City(id: 0, name: "\(location.coordinate.latitude.localizedNumber(withFractionalDigits: 2)), \(location.coordinate.longitude.localizedNumber(withFractionalDigits: 2))", state: "", country: "", location: Location(lat: location.coordinate.latitude, long: location.coordinate.longitude))
    }
    
    static func emitCityListUpdated(){
        NotificationCenter.default.post(name: NSNotification.Name(Constants.cityListChangedName), object: nil)
    }
    
    static func saveMainCity(city: City) {
        UserDefaults.save(value: city, for: .selectedCity)
        UserDefaults.save(value: city, for: .mainCity)
    }
    
    static func getMainCity() -> City {
        return UserDefaults.get(for: .mainCity) ?? City()
    }
    
    static func saveSelectedCity(city: City) {
        UserDefaults.save(value: city, for: .selectedCity)
    }
    
    static func getSelectedCity() -> City {
        return UserDefaults.get(for: .selectedCity) ?? getMainCity()
    }
    
    static func getAllCities() -> [City] {
        let cities: [City] = UserDefaults.get(for: .cities) ?? [City()]
        return cities
    }
    
    static func addToCityList(city: City) {
        var cities: [City] = []
        if let savedCities: [City] = UserDefaults.get(for: .cities) {
            cities = savedCities
        }
        if city.isCurrentLocation { cities.insert(city, at: 0) } else { cities.append(city) }
        UserDefaults.save(value: cities, for: .cities)
    } 
    
    static func selectNextCity() {
        let cities: [City] = getAllCities()
        let selectedCity = getMainCity()
        let selectedCityIndex = cities.firstIndex(of: selectedCity) ?? 0
        if selectedCityIndex + 1 < cities.count {
            saveMainCity(city: cities[selectedCityIndex + 1])
        }else {
            saveMainCity(city: cities[0])
        }
    }
    
    static func removeFromCityList(city: City) {
        guard let index = getAllCities().firstIndex(of: city),
        let cities: [City] = UserDefaults.get(for: .cities) else { return }
        var newCities = cities
        newCities.remove(at: index)
        UserDefaults.save(value: newCities, for: .cities)
    }
    
    static func citiesCount() -> Int {
        return self.getAllCities().count
    }
    
    static func returnCityFromId(cityId: Int) -> City {
        
        let allCities = CityAgent.getAllCities()
        var selectedCity: City
        
        if let matchedCity = allCities.filter({$0.id == cityId}).first {
            selectedCity = matchedCity
        } else {
            selectedCity = CityAgent.getMainCity()
        }
        
        return selectedCity
        
    }
    
}
