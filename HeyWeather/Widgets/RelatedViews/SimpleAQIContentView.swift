//
//  SimpleAQIContentView.swift
//  HeyWeather
//
//  Created by Mohammad Yeganeh on 8/12/23.
//

import SwiftUI

struct SimpleAQIContentView: View {
    var weather: WeatherData
    var aqiData: AQIData
    var setting: AQIWidgetSetting
    var widgetSize : WidgetFamily

    var body: some View {
        VStack(alignment: .leading, spacing: -4){
            Group {
                
                Spacer(minLength: 0)
                
                Text(Strings.AQI.airQuality)
                    .fonted(.callout, weight: .medium)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                Spacer(minLength: 0)
                
                Text(Strings.AQI.usAqi)
                    .fonted(.caption2, weight: .regular)
                
                Text("\(aqiData.current.value)")
                    .fonted(.largeTitle, weight: .bold)
                
                Text(aqiData.current.status)
                    .fonted(.body, weight: .regular)
                    .padding(.top, 2)
                
                Spacer(minLength: 0)
                
                if widgetSize == .systemSmall {
                    LocationView(theme: .init(city: weather.location, showCityName: setting.showCityName, showAddress: setting.showAddress), weather: weather)
                }else {
                    AQIDashView(
                        name: Strings.Simple.tomorrow.stringValue(),
                        lineWidth: 3,
                        lineSpacing: 6,
                        foregroundColor: .white
                    )
                    .fonted(.caption2)
                    .padding(.bottom, 6)

                }
                Spacer(minLength: 0)
            }
        }
        .padding(.horizontal, 20)
        .foregroundColor(.white)
    }
}
