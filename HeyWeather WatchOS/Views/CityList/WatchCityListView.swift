//
//  CityListView.swift
//  HeyWeather
//
//  Created by Mohammad Yeganeh on 8/7/23.
//

import SwiftUI

struct WatchCityListView: View {
    @ObservedObject var viewModel: WatchViewModel

    var body: some View {
        let selectedCity = CityAgent.getSelectedCity()
        List(selection: $viewModel.city) {
            ForEach(viewModel.weatherDatas) { weatherData in
                NavigationLink(value: weatherData.location) {
                    CityListItem(
                        weatherData: weatherData,
                        selected: selectedCity == weatherData.location
                    )
                }
                .buttonStyle(.plain)
                .listRowInsets(EdgeInsets())
            }
        }
        .onChange(of: viewModel.city) {
            viewModel.onCityChanged()
        }
        .listStyle(.elliptical)
        .navigationTitle(Text("City List", tableName: "CityList"))
    }
}

private struct CityListItem : View {
    let weatherData: WeatherData
    let selected: Bool
    
    var body: some View {
        let astronomy = Repository().getAstronomy(city: weatherData.location, count:  1, timeZone: weatherData.timezone).first!
        let textColor = AnimatedWeatherBackground.getTextColor(
            sunrise: astronomy.sun.sunrise,
            sunset: astronomy.sun.sunset,
            weather: weatherData.today
        )
        HStack {
            VStack(alignment: .leading){
                Text(weatherData.location.name)
                    .fonted(.body, weight: .bold)
                    .lineLimit(1)
                
                Text(Date().timeInTimezone(timezone: weatherData.timezone))
                    .fonted(.caption2, weight: .regular)
                    .opacity(Constants.primaryOpacity)
            }
            Spacer(minLength: 0)
            
            if selected {
                Image(Constants.Icons.checked)
            }else{
                Text(weatherData.today.temperature.now?.localizedTemp ?? "")
                    .fonted(.title2, weight: .semibold)
            }
        }
        .foregroundStyle(textColor)
        .padding(18)
        .background(AnimatedWeatherBackground(
//            sunrise: weatherData.astronomy?.sun.sunrise,
//            sunset: weatherData.astronomy?.sun.sunset,
            sunrise: astronomy.sun.sunrise,
            sunset: astronomy.sun.sunset,
            weather: weatherData.today,
            isAnimationEnabled: true
        ))
        .clipShape(RoundedRectangle(cornerRadius: Constants.weatherTabRadius))
    }
}
