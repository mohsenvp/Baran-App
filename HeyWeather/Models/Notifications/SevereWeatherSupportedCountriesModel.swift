//
//  SevereWeatherSupportedCountriesModel.swift
//  HeyWeather
//
//  Created by Mojtaba on 11/28/23.
//

import Foundation

struct SevereWeatherSupportedCountriesModel {
    
    struct SevereWeatherSupportedCountry: Identifiable {
        var id: UUID = UUID()
        var continent: SevereWeatherContinentType
        var name: String
        
        init(continent: SevereWeatherContinentType, name: String) {
            self.continent = continent
            self.name = name
        }
    }
    var countries: [SevereWeatherSupportedCountry] = [
        SevereWeatherSupportedCountry(continent: .northAmerica, name: "USA"),
        SevereWeatherSupportedCountry(continent: .northAmerica, name: "Canada"),
        SevereWeatherSupportedCountry(continent: .europe, name: "Albania"),
        SevereWeatherSupportedCountry(continent: .europe, name: "Austria"),
        SevereWeatherSupportedCountry(continent: .europe, name: "Belgium"),
        SevereWeatherSupportedCountry(continent: .europe, name: "Bosnia and Herzegovina"),
        SevereWeatherSupportedCountry(continent: .europe, name: "Bulgaria"),
        SevereWeatherSupportedCountry(continent: .europe, name: "Croatia"),
        SevereWeatherSupportedCountry(continent: .europe, name: "Cyprus"),
        SevereWeatherSupportedCountry(continent: .europe, name: "Czech Republic"),
        SevereWeatherSupportedCountry(continent: .europe, name: "Denmark"),
        SevereWeatherSupportedCountry(continent: .europe, name: "Estonia"),
        SevereWeatherSupportedCountry(continent: .europe, name: "Finland"),
        SevereWeatherSupportedCountry(continent: .europe, name: "France"),
        SevereWeatherSupportedCountry(continent: .europe, name: "Germany"),
        SevereWeatherSupportedCountry(continent: .europe, name: "Greece"),
        SevereWeatherSupportedCountry(continent: .europe, name: "Hungary"),
        SevereWeatherSupportedCountry(continent: .europe, name: "Iceland"),
        SevereWeatherSupportedCountry(continent: .europe, name: "Ireland"),
        SevereWeatherSupportedCountry(continent: .europe, name: "Italy"),
        SevereWeatherSupportedCountry(continent: .europe, name: "Latvia"),
        SevereWeatherSupportedCountry(continent: .europe, name: "Lithuania"),
        SevereWeatherSupportedCountry(continent: .europe, name: "Luxembourg"),
        SevereWeatherSupportedCountry(continent: .europe, name: "Malta"),
        SevereWeatherSupportedCountry(continent: .europe, name: "Moldova"),
        SevereWeatherSupportedCountry(continent: .europe, name: "Montenegro"),
        SevereWeatherSupportedCountry(continent: .europe, name: "Netherlands"),
        SevereWeatherSupportedCountry(continent: .europe, name: "North Macedonia"),
        SevereWeatherSupportedCountry(continent: .europe, name: "Norway"),
        SevereWeatherSupportedCountry(continent: .europe, name: "Poland"),
        SevereWeatherSupportedCountry(continent: .europe, name: "Portugal"),
        SevereWeatherSupportedCountry(continent: .europe, name: "Romania"),
        SevereWeatherSupportedCountry(continent: .europe, name: "Serbia"),
        SevereWeatherSupportedCountry(continent: .europe, name: "Slovakia"),
        SevereWeatherSupportedCountry(continent: .europe, name: "Slovenia"),
        SevereWeatherSupportedCountry(continent: .europe, name: "Spain"),
        SevereWeatherSupportedCountry(continent: .europe, name: "Sweden"),
        SevereWeatherSupportedCountry(continent: .europe, name: "Switzerland"),
        SevereWeatherSupportedCountry(continent: .europe, name: "United Kingdom")
    ]
    
    
}


enum SevereWeatherContinentType: String, CaseIterable {
    case northAmerica = "North America"
    case europe = "Europe"
}
