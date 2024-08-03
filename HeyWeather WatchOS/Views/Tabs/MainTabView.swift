//
//  MainTabView.swift
//  HeyWeather
//
//  Created by Mohammad Yeganeh on 8/7/23.
//

import SwiftUI

struct MainTabView: View {
    
    @ObservedObject var viewModel: WatchViewModel
    @State var selectedTab: Int = 0
    var body: some View {
        TabView(selection: $selectedTab){
            HomeTabView(viewModel: viewModel).tag(0)
            HourlyTabView(viewModel: viewModel).tag(1)
            DailyTabView(viewModel: viewModel).tag(2)
            AQITabView(viewModel: viewModel).tag(3)
        }
        .onTapGesture {
            viewModel.nextDataMode()
        }
        .tabViewStyle(.verticalPage)
        .background(
            AnimatedWeatherBackground(
                sunrise: viewModel.astronomy.sun.sunrise,
                sunset: viewModel.astronomy.sun.sunset,
                weather: viewModel.weatherData.today,
                isAnimationEnabled: true
            ).edgesIgnoringSafeArea(.all)
        )
        .toolbar {
            if selectedTab != 3 {
                ToolbarItemGroup(placement: .topBarTrailing) {
                    Button(action: {
                        viewModel.dataModeSheetPresented.toggle()
                    }, label: {
                        Image(viewModel.dataMode.icon)
                            .renderingMode(.template)
                            .resizable()
                            .foregroundColor(.primary)
                            .frame(width: 20, height: 20)
                            .animation(.none, value: viewModel.dataMode)
                    })
                }
            }
        }
        .sheet(isPresented: $viewModel.dataModeSheetPresented) {
            DataModeSheet(selectedMode: viewModel.dataMode) { newMode in
                viewModel.dataMode = newMode
                viewModel.dataModeSheetPresented = false
            }
        }
        
    }
}

#Preview {
    MainTabView(viewModel: .init())
}
