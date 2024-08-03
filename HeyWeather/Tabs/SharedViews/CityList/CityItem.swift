//
//  CityItem.swift
//  HeyWeather
//
//  Created by Kamyar on 10/27/21.
//

import SwiftUI

struct CityItem: View {
    @State var weatherData: WeatherData
    @Binding var selectedCity: City
    let allowedToSelect: Bool
    @State var isRedacted: Bool
    
    
    var body: some View {
        let astronomy = Repository().getAstronomy(city: weatherData.location, count:  1, timeZone: weatherData.timezone).first!
        var textColor: Color {
            AnimatedWeatherBackground.getTextColor(
                sunrise: astronomy.sun.sunrise,
                sunset: astronomy.sun.sunset,
                weather: weatherData.today
            )
        }
        
        HStack {
            ConditionIcon(iconSet: Constants.default3DIconSet, condition: weatherData.today.condition)
                .frame(maxWidth: 40)
                .cornerRadius(10)
            
            Text(weatherData.today.temperature.now.localizedTemp)
                .fonted(.title, weight: .bold)
                .frame(width:60)
                .padding(.horizontal,2)
                .foregroundColor(textColor)
                .lineLimit(1)
                .minimumScaleFactor(0.8)
                .contentTransition(.numericText())
            
            VStack(alignment: .leading, spacing: 0) {
                Text(weatherData.location.name)
                    .fonted(.body, weight: .medium)
                    .lineLimit(1)
                    .unredacted()
                    .foregroundColor(textColor)
                    .shadow(radius: weatherData.today.condition.isDay ? 0 : 1)
                
                
                Text(weatherData.today.localDate.shortWeekday + Constants.space +  weatherData.today.localDate.shortLocalizedString + Constants.space + Constants.space + Date().timeInTimezone(timezone: weatherData.timezone))
                    .fonted(.subheadline, weight: .regular)
                    .opacity(Constants.primaryOpacity)
                    .padding([.top, .bottom], 2)
                    .foregroundColor(textColor)
                
                    if (weatherData.location.isCurrentLocation) {
                        HStack(spacing:0) {
                            Image(Constants.Icons.location)
                                .resizable()
                                .frame(width: 12, height: 12)
                                .padding(.trailing, 2)
                                .foregroundColor(textColor.opacity(0.8))
                            Text("Auto Update", tableName: "CityList")
                                .fonted(.footnote, weight: .regular)
                                .lineLimit(1)
                                .foregroundColor(textColor.opacity(0.8))
                    }
                    .unredacted()
                }
            }
            Spacer()
            if weatherData.location == selectedCity {
                Image(Constants.Icons.checked)
                    .foregroundColor(textColor)
                    .fonted(.title2, weight: .regular)
                    .cornerRadius(10)
                    .unredacted()
            } else {
                if !allowedToSelect {
                    Image(Constants.Icons.premium)
                        .renderingMode(.template)
                        .foregroundColor(textColor)
                        .fonted(.title2, weight: .regular)
                        .cornerRadius(10)
                        .unredacted()
                }
            }
        }
        .padding(16)
        .background {
            AnimatedWeatherBackground(
                sunrise: astronomy.sun.sunrise,
                sunset: astronomy.sun.sunset,
                weather: weatherData.today,
                isAnimationEnabled: true
            )
        }
        .cornerRadius(Constants.weatherTabRadius)
        .padding(.horizontal)
        .padding(.vertical, 2)
        .redacted(isRedacted: isRedacted, supportInvalidation: false)
    }
}

#if DEBUG
struct CityItem_Previews: PreviewProvider {
    static var previews: some View {
        CityItem(weatherData: .init(), selectedCity: .constant(.init()), allowedToSelect: true, isRedacted: false)
    }
}
#endif
