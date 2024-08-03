//
//  HomeTabView.swift
//  HeyWeather
//
//  Created by Mohammad Yeganeh on 8/7/23.
//

import SwiftUI

struct HomeTabView: View {

    @ObservedObject var viewModel: WatchViewModel
    @Namespace var animation
    var body: some View {
        VStack(spacing: 8){
            
            HomeTopView(viewModel: viewModel)
            
            if viewModel.dataMode == .weather {
                HomeWeatherView(viewModel: viewModel, animation: animation)
                    .frame(height: 70)
            }else {
                HomeDetailView(viewModel: viewModel, animation: animation)
                    .frame(height: 70)
            }
        }
        
    }
}

private struct HomeTopView: View {
    @ObservedObject var viewModel: WatchViewModel
    
    var body: some View {
        VStack(spacing: 0) {
            Text(viewModel.city?.name ?? "")
                .fonted(.caption2)
                .foregroundColor(viewModel.textColor)
                .padding(.horizontal, 20)
                .contentTransition(.interpolate)
            
            HStack(spacing: 10){
                ConditionIcon(iconSet: Constants.default3DIconSet, condition: viewModel.weatherData.today.condition)
                    .frame(width: 50, height: 50)
                
                Text(viewModel.weatherData.today.temperature.now?.localizedTemp ?? "")
                    .foregroundColor(viewModel.textColor)
                    .fonted(.title, weight: .semibold)
                    .contentTransition(.numericText())
            }
        }
    }
}
private struct HomeWeatherView: View {
    @ObservedObject var viewModel: WatchViewModel

    var animation : Namespace.ID
    var body: some View {
       
        VStack(spacing: 8) {
            Text("\(viewModel.weatherData.today.temperature.max?.localizedTemp ?? "")↑ ↓\(viewModel.weatherData.today.temperature.min?.localizedTemp ?? "")")
                .fonted(.callout, weight: .medium)
                .foregroundColor(viewModel.textColor)
                .contentTransition(.numericText())
            
            
            HStack {
                
                VStack(spacing: 0){
                   
                    
                    Image(WatchDataMode.windSpeed.icon)
                        .resizable()
                        .renderingMode(.template)
                        .frame(width: 16, height: 16)
                    
                    Text((viewModel.weatherData.today.details.windSpeed?.convertedSpeed() ?? 0).localizedNumber(withFractionalDigits: 1))
                        .fonted(.caption2, weight: .light)
                }
                .foregroundColor(.white)
                .frame(width: 50, height: 50)
                .background(
                    Circle().fill(.ultraThinMaterial)
                )
                
                Spacer(minLength: 0)

                WindDirectionCompassView(windDegree: 20)
                    .matchedGeometryEffect(id: "detail", in: animation)
                
                Spacer(minLength: 0)
                
                VStack(spacing: 0){
                    Image(WatchDataMode.humidity.icon)
                        .resizable()
                        .renderingMode(.template)
                        .frame(width: 16, height: 16)
                    
                    Text("\(viewModel.weatherData.today.details.humidity?.localizedNumber ?? "")%")
                        .fonted(.caption2, weight: .light)
                }
                .foregroundColor(.white)
                .frame(width: 50, height: 50)
                .background(
                    Circle().fill(.ultraThinMaterial)
                )
            }
            .padding(.horizontal, 12)
        }
        
    }
}

private struct HomeDetailView: View {
    @ObservedObject var viewModel: WatchViewModel
    var animation : Namespace.ID

    
    var body: some View {
        HStack {
            
            VStack(alignment: .leading){
                
                viewModel.dataMode.title
                    .fonted(.caption2)
                    .foregroundStyle(.secondary)
                    .transition(.push(from: .leading))
                
                Text(viewModel.activeDetailValue)
                    .fonted(.title3)
                    .minimumScaleFactor(0.7)
                    .contentTransition(.numericText())
                    .animation(.spring(duration: 0.2), value: viewModel.activeDetailValue)

                
            }
            
            Spacer(minLength: 0)
            
            Image(viewModel.dataMode.icon)
                .renderingMode(.template)
                .resizable()
                .frame(width: 30, height: 30)
                .animation(.none, value: viewModel.dataMode)
            
        }
        .matchedGeometryEffect(id: "detail", in: animation)
        .padding(12)
        .background(.ultraThinMaterial)
        .cornerRadius(Constants.weatherTabRadius)
        .padding(.horizontal)
        
    }
}
#Preview {
    HomeTabView(viewModel: .init())
}
