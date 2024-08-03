//
//  TimeTravelWeatherView.swift
//  HeyWeather
//
//  Created by Mohammad Yeganeh on 8/22/23.
//

import SwiftUI


struct TimeTravelWeatherView: View {
    @ObservedObject var viewModel: TimeTravelViewModel

    var body: some View {
        VStack(spacing: 0){
            
            Text(viewModel.city.name)
                .lineLimit(1)
                .font(.custom(Constants.AmericanTypewriteFontName, size: 18).weight(.semibold))
                .foregroundColor(Constants.TimeTravelPrimary)
                .padding(.horizontal)
                .padding(.top)
            
            weatherTopView
            
            
            ConditionIcon(iconSet: Constants.defaultTimeTravelIconSet, condition: viewModel.weather.condition)
                .frame(width: 150)
                .foregroundStyle(
                    Constants.TimeTravelPrimary.gradient
                        .shadow(.inner(color: .black.opacity(0.3), radius: 3, x: 1, y: 4))
                    )
                .accessibilityHidden(true)
            
            TimeTravelWeatherDetail(viewModel: viewModel)
            
            Spacer()
        }
    }
    @ViewBuilder var weatherFooterView: some View {
        Line()
            .stroke(style: StrokeStyle(lineWidth: 0.5))
            .foregroundColor(Constants.TimeTravelPrimary)
            .frame(height: 1)
            .accessibilityHidden(true)
        
        HStack {
            
            Text(viewModel.selectedDate.formatted())
            
            Text("Weather Summary", tableName: "TimeTravel")
                
        }
        .font(.custom(Constants.AmericanTypewriteFontName, size: 12))
        .foregroundColor(Constants.TimeTravelPrimary)
        .padding(.horizontal)
        .padding(.bottom, 2)
        
        Line()
            .stroke(style: StrokeStyle(lineWidth: 0.5))
            .foregroundColor(Constants.TimeTravelPrimary)
            .frame(height: 1)
            .accessibilityHidden(true)
    }
    
    
    @ViewBuilder var weatherTopView: some View {
        ZStack {
            HStack {
                VStack(spacing: 9){
                    Line()
                        .stroke(style: StrokeStyle(lineWidth: 0.5))
                        .foregroundColor(Constants.TimeTravelPrimary)
                        .frame(height: 1)
                        .padding(.trailing)
                        .accessibilityHidden(true)
                   
                    Text("L: \(viewModel.weather.temperature.min.localizedTemp)")
                        .foregroundColor(.blue.opacity(0.8))
                        .font(.custom(Constants.AmericanTypewriteFontName, size: 18))
                        .accessibilityLabel(Text("at min", tableName: "Accessibility"))
                        .accessibilityValue(viewModel.weather.temperature.min.localizedTemp)
                    
                    Line()
                        .stroke(style: StrokeStyle(lineWidth: 0.5))
                        .foregroundColor(Constants.TimeTravelPrimary)
                        .frame(height: 1)
                        .accessibilityHidden(true)
                }
                .frame(maxWidth: .infinity)
                
                Spacer(minLength: 120)
                VStack(spacing: 9){
                    Line()
                        .stroke(style: StrokeStyle(lineWidth: 0.5))
                        .foregroundColor(Constants.TimeTravelPrimary)
                        .frame(height: 1)
                        .padding(.leading)
                        .accessibilityHidden(true)

                    Text("H: \(viewModel.weather.temperature.max.localizedTemp)")
                        .foregroundColor(.red.opacity(0.8))
                        .font(.custom(Constants.AmericanTypewriteFontName, size: 18))
                        .accessibilityLabel(Text("at max", tableName: "Accessibility"))
                        .accessibilityValue(viewModel.weather.temperature.max.localizedTemp)
                    
                    Line()
                        .stroke(style: StrokeStyle(lineWidth: 0.5))
                        .foregroundColor(Constants.TimeTravelPrimary)
                        .frame(height: 1)
                        .accessibilityHidden(true)
                }
                .frame(maxWidth: .infinity)

            }
            .padding(.top, 4)
            
    

            Text(viewModel.weather.temperature.now.localizedTemp)
                .font(.custom(Constants.AmericanTypewriteFontName, size: 58).weight(.semibold))
                .foregroundStyle(
                    Constants.TimeTravelPrimary.gradient
                        .shadow(.inner(color: .black.opacity(0.25), radius: 3, x: 1, y: 4))
                    )
                .accessibilityLabel(Text("current temperature", tableName: "Accessibility"))
                .accessibilityValue(viewModel.weather.temperature.now.localizedTemp)
            
        }
        .padding(.top, 20)
    }
    
 
}
