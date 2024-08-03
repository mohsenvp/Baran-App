//
//  WeatherMapsTab.swift
//  HeyWeather
//
//  Created by Kamyar on 8/14/21.
//

import SwiftUI
import MapKit

struct MapsTab: View {

    @StateObject var viewModel: MapViewModel = .init()
    @Environment(\.colorScheme) var colorScheme
    @State var elementsOpacity = 1.0
    @State var elementsLoadingOpacity = 0.0
    @ObservedObject var localizeHelper = LocalizeHelper.shared
    @Environment(\.scenePhase) var scenePhase
    @EnvironmentObject var premium: Premium

    
    var body: some View {
        ZStack(alignment: .bottom){
            
            MapView(viewModel: viewModel)
                .edgesIgnoringSafeArea(.all)
            
            VStack {
                HeaderView(viewModel: viewModel)
                    .padding(12)
                
                Spacer()
            }
            .opacity(elementsLoadingOpacity)
            .animation(Constants.isWidthCompact ? nil : .linear(duration: 0.1), value: elementsLoadingOpacity)
            
            VStack(alignment: .trailing, spacing: 0){
                
                Spacer()
                
                LocationButtonView(shouldCenterCity: $viewModel.shouldCenterCity)
                    .padding(12)
                
                HStack(spacing: 12){
                    TimeLineView(viewModel: viewModel)
                    DateTimeView(viewModel: viewModel)
                }.padding(.horizontal, 12)
                
                LayerGuideView(viewModel: viewModel)
                    .padding(12)
                
            }
            .opacity(elementsOpacity)
            .opacity(elementsLoadingOpacity)
            .animation(Constants.isWidthCompact ? nil : .linear(duration: 0.1), value: elementsLoadingOpacity)
            .animation(Constants.isWidthCompact ? nil : .linear(duration: 0.1), value: elementsOpacity)
            
        }
        .accessibilityHidden(true)
        .onAppear {
            viewModel.onAppear(colorScheme: colorScheme, premium: premium)
        }.onChange(of: colorScheme) { newColorScheme in
            if scenePhase == .active {
                viewModel.getMapStyle(style: newColorScheme == .dark ? .dark : .light)
            }
        }.onChange(of: viewModel.isLayersViewOpen) { isShown in
            elementsOpacity = isShown ? 0 : 1
        }.onChange(of: viewModel.isLoadingLayerData) { isLoading in
            elementsLoadingOpacity = isLoading ? 0 : 1
        }.onChange(of: localizeHelper.currentLanguage) { newValue in
            viewModel.onAppear(colorScheme: colorScheme, premium: premium)
        }.onChange(of: CityAgent.getSelectedCity()) { newValue in
            viewModel.shouldCenterCity.toggle()
        }
    }
}
