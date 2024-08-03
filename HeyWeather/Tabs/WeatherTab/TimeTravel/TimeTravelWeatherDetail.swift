//
//  TimeTravelDetailCell.swift
//  HeyWeather
//
//  Created by Mohammad Yeganeh on 8/22/23.
//

import SwiftUI

struct TimeTravelWeatherDetail: View {
    @ObservedObject var viewModel: TimeTravelViewModel
    var body: some View {
        ZStack {
            HStack {
                Spacer()
                Rectangle().fill(Constants.TimeTravelPrimary)
                    .frame(width: 0.5, height: 300)
                Spacer()

            }
            VStack {
                HStack {
                    Spacer()
                    TimeTravelWeatherDetailCell(
                        title: Strings.WeatherDetails.getWeatherDetailsTitle(for: .clouds),
                        value: viewModel.getValue(type: .clouds)
                    )
                    Spacer(minLength: 40)
                    TimeTravelWeatherDetailCell(
                        title: Strings.WeatherDetails.getWeatherDetailsTitle(for: .wind),
                        value: viewModel.getValue(type: .wind)
                    )
                    Spacer()
                }
                Rectangle().fill(Constants.TimeTravelPrimary)
                    .frame(height: 0.6)
                HStack {
                    Spacer()

                    TimeTravelWeatherDetailCell(
                        title: Strings.WeatherDetails.getWeatherDetailsTitle(for: .pressure),
                        value: viewModel.getValue(type: .pressure)
                    )
                    Spacer(minLength: 40)

                    TimeTravelWeatherDetailCell(
                        title: Strings.WeatherDetails.getWeatherDetailsTitle(for: .humidity),
                        value: viewModel.getValue(type: .humidity)
                    )
                    Spacer()
                }
                Rectangle().fill(Constants.TimeTravelPrimary)
                    .frame(height: 0.5)
                HStack {
                    Spacer()
                    TimeTravelWeatherDetailCell(
                        title: Strings.WeatherDetails.getWeatherDetailsTitle(for: .precipitation),
                        value: viewModel.getValue(type: .precipitation)
                    )
                    Spacer(minLength: 40)
                    TimeTravelWeatherDetailCell(
                        title: Strings.WeatherDetails.getWeatherDetailsTitle(for: .dewPoint),
                        value: viewModel.getValue(type: .dewPoint)
                    )
                    Spacer()

                }
                
            }
            .padding(.horizontal, 20)
            
        }
    }
}

struct TimeTravelWeatherDetailCell: View {
    var title: Text
    var value: String
    var body: some View {
        VStack {
            title
                .foregroundColor(Constants.TimeTravelPrimary)
                .font(.custom(Constants.AmericanTypewriteFontName, size: 18).weight(.semibold))
                .frame(maxWidth: .infinity)

            Text(value)
                .font(.custom(Constants.AmericanTypewriteFontName, size: 24).weight(.semibold))
                .foregroundColor(Constants.TimeTravelPrimary)
                .lineLimit(1)
                .minimumScaleFactor(0.8)
                .frame(maxWidth: .infinity)

        }
        .accessibilityElement(children: .combine)
        .frame(maxWidth: .infinity)
        .padding()
    }
}


