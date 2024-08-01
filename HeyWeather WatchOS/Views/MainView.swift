//
//  ContentView.swift
//  HeyWeather WatchOS Watch App
//
//  Created by Mohammad Yeganeh on 8/7/23.
//

import SwiftUI

struct MainView: View {
    
    @StateObject var viewModel: WatchViewModel = .init()
    @ObservedObject var appState = WatchState.shared


    var body: some View {
        ZStack {
            
            NavigationSplitView(preferredCompactColumn: $viewModel.preferredCompactColumn) {
                WatchCityListView(viewModel: viewModel)
            } detail: {
                MainTabView(viewModel: viewModel)
            }
            .environmentObject(viewModel)
            .onChange(of: appState.shouldReload) { _, _ in
                viewModel.reloadValues()
            }
            
            
//            LogoLoadingView()
//                .opacity((viewModel.isWeatherRedacted && !viewModel.weatherData.today.isAvailable) ? 1 : 0)
//                .animation(.linear(duration: 0.1), value: viewModel.isWeatherRedacted)
//                .allowsHitTesting(viewModel.isWeatherRedacted)
            
            if viewModel.alertViewShown {
                ZStack{
                    Color.black.ignoresSafeArea(edges: .all)
                    Strings.NetworkAlerts.getNetworkMessage(for: viewModel.networkFailResponse)
                        .fonted(.body, weight: .semibold)
                        .foregroundStyle(.white)
                        .multilineTextAlignment(.center)
                }
            }
            
        }
       
      
    }
}

#Preview {
    MainView()
}
