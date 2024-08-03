//
//  SevereWeatherSupportedCountriesSheet.swift
//  HeyWeather
//
//  Created by Mojtaba on 11/27/23.
//

import SwiftUI

struct SevereWeatherSupportedCountriesSheet: View {
    var countries = SevereWeatherSupportedCountriesModel().countries
    var body: some View {
        List() {
            ForEach(SevereWeatherContinentType.allCases, id: \.self) { type in
                Section {
                    ForEach(countries.filter( {type == $0.continent})) { country in
                        Text(country.name)
                            .foregroundStyle(Color.primary)
                    }
                } header: {
                    Text(type.rawValue)
                        .foregroundStyle(Color.primary)
                }
            }
        }
    }
}

#Preview {
    SevereWeatherSupportedCountriesSheet()
}
