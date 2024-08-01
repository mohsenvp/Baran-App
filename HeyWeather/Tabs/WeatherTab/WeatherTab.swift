//
//  WeatherTab.swift
//  HeyWeather
//
//  Created by Kamyar on 10/27/21.
//

import SwiftUI



struct OffsetKey: PreferenceKey {
    static var defaultValue: CGFloat = 0
    
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = nextValue()
    }
}
struct OffsetProxy: View {
    var body: some View {
        GeometryReader { proxy in
            Color.clear
                .preference(key: OffsetKey.self, value: proxy.frame(in: .global).minX)
        }
    }
}

struct WeatherTab: View {
    
    @StateObject var viewModel: WeatherTabViewModel
    @EnvironmentObject var premium: Premium
    @Environment(\.scenePhase) var scenePhase
    
    @State var selection: Int = 0
    @State var previousSelection: Int = 0
    @State var nextSelection: Int? = nil
    @State var nextBGOpacity: CGFloat = 0.0
    @State var scrollingIndex: Int? = nil
    
    @State var mainCityDialogShown: Bool = false
    @State var shouldUpdateWeatherTabIndicator: Bool = false
    @State var citiesOffset: CGFloat = 0.0
    
    var body: some View {
        let screenWidth = Constants.screenWidth
        NavigationStack {
            ZStack(alignment: .top) {
                
                AnimatedWeatherBackground(
                    sunrise: viewModel.tabItems[selection].astronomy.sun.sunrise,
                    sunset: viewModel.tabItems[selection].astronomy.sun.sunset,
                    weather: viewModel.tabItems[selection].weatherData.today,
                    isAnimationEnabled: true
                )
                
                if viewModel.tabItems.count > nextSelection ?? 0 {
                    AnimatedWeatherBackground(
                        sunrise: viewModel.tabItems[nextSelection ?? selection].astronomy.sun.sunrise,
                        sunset: viewModel.tabItems[nextSelection ?? selection].astronomy.sun.sunset,
                        weather: viewModel.tabItems[nextSelection ?? selection].weatherData.today,
                        isAnimationEnabled: nextSelection != nil
                    )
                    .opacity(nextBGOpacity)
                }
                
                
                TabView(selection: $selection) {
                    
                    ForEach(0..<viewModel.tabItems.count, id: \.self) { i in
                        WeatherTabItem(
                            weatherTabState: viewModel.tabItems[i],
                            viewModel: viewModel
                        )
                        .tag(i)
                        .overlay(
                            OffsetProxy()
                        )
                        .onPreferenceChange(OffsetKey.self) { offset in
                            if selection != previousSelection {
                                UIImpactFeedbackGenerator(style: .rigid).impactOccurred()
                                CityAgent.saveSelectedCity(city: viewModel.tabItems[selection].city)
                            }
                            previousSelection = selection
                            if i == selection {
                                if scrollingIndex == nil {
                                    scrollingIndex = i
                                    if offset > 0 {
                                        if i != 0 {
                                            nextSelection = i - 1
                                        }
                                    }else {
                                        if i + 1 != viewModel.tabItems.count {
                                            nextSelection = i + 1
                                        }
                                    }
                                }
                                if offset == 0 {
                                    if selection != scrollingIndex ?? 0 {
                                        viewModel.tabItems[selection].onAppear()
                                        if viewModel.tabItems[selection].city != CityAgent.getMainCity(), !mainCityDialogShown {
                                            mainCityDialogShown = true
                                        }else if viewModel.tabItems[selection].city == CityAgent.getMainCity(){
                                            mainCityDialogShown = false
                                        }
                                    }
                                    self.nextBGOpacity = 0.0
                                    self.scrollingIndex = nil
                                }
                                if i == viewModel.tabItems.count - 1, offset < 0, abs(offset) < screenWidth / 4.9 {
                                    citiesOffset = (abs(offset).interpolated(from: 40...screenWidth / 5, to: 0...1)).clamped(to: 0...1)
                                    if citiesOffset == 1 {
                                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2, execute: {
                                            self.viewModel.navigateDetails(.cityList)
                                            citiesOffset = 0.0
                                        })
                                    }
                                }
                                
                            }
                            
                            if i == scrollingIndex {
                                if offset < 0  {
                                    self.nextBGOpacity = abs(offset).interpolated(from: 0...screenWidth, to: 0...1).clamped(to: 0...1) * 2
                                }else {
                                    self.nextBGOpacity = offset.interpolated(from: 0...screenWidth, to: 0...1).clamped(to: 0...1) * 2
                                }
                            }
                            
                        }
                    }
                }
                .tabViewStyle(.page(indexDisplayMode: .never))
                .ignoresSafeArea(.all, edges: [.top])
                ///right arrow for cities list on swipe
                VStack {
                    Spacer()
                    HStack {
                        Spacer()

                        Circle()
                            .trim(from: 0, to: citiesOffset)
                            .stroke(
                                viewModel.tabItems[selection].textColor,
                                lineWidth: 2
                            ).overlay {
                                Image(systemName: Constants.SystemIcons.arrowRight)
                                    .opacity(citiesOffset)
                                    .foregroundStyle(viewModel.tabItems[selection].textColor)
                            }
                            .scaleEffect(citiesOffset == 1.0 ? 1.2 : 1.0)
                            .animation(.bouncy, value: citiesOffset)
                            .frame(width: 40, height: 40)
                            .opacity(citiesOffset != 0.0 ? 1.0 : 0.0)
                                                
                    }
                    .padding()
                    
                    Spacer()
                }
                
            }
            .onAppear {
                moveToSelectedCity()
            }
            .overlay {
                if viewModel.confettiShown {
                    ConfettiView()
                }
            }
            .onReceive(viewModel.shouldUpdateWeatherPublisher) { payload in
                if let shouldUpdateEverything: Bool = payload.object as? Bool, shouldUpdateEverything == true {
                    viewModel.updateEverything()
                }else {
                    viewModel.updateWeatherDataForMainTabs()
                }
            }
            .onReceive(viewModel.shouldUpdateAQIPublisher) { payload in
                viewModel.updateAQIDataForMainTabs()
            }
            .onReceive(viewModel.cityListChangedPublished) { _ in
                viewModel.updateTabs()
            }
            .onReceive(viewModel.premiumPurchaseWasSuccessful) { _ in
                viewModel.afterSuccessfulPurchase(selectedTabIndex: selection)
            }
            .onChange(of: scenePhase) { newPhase in
                viewModel.updateCurrentPhaseToNewPhase(newPhase, selectedTabIndex: selection)
            }
            .snackbar(isShowing: $mainCityDialogShown, title: Text("Set as Default City?", tableName: "WeatherTab"), actionText: Text("Yes", tableName: "General"), dismissOnTap: true, dismissAfter: 4,extraBottomPadding: viewModel.tabItems.count > 1 ? 20 : 0, action: {
                CityAgent.saveMainCity(city: viewModel.tabItems[selection].city)
                AppState.shared.syncWithWatch()
                shouldUpdateWeatherTabIndicator.toggle()
            })
            .overlay {
                WeatherTabIndicator(viewModel: viewModel, selection: selection, shouldUpdate: shouldUpdateWeatherTabIndicator)
            }
            .sheet(isPresented: $viewModel.isMoonDetailsViewPresented, content: {
                MoonDetailsView(
                    viewModel: MoonDetailsViewModel(
                        moons: viewModel.tabItems[selection].moons
                    ), isPresented: $viewModel.isMoonDetailsViewPresented
                )
            })
            .sheet(isPresented: $viewModel.isSunDetailsViewPresented, content: {
                SunDetailsView(
                    viewModel: SunDetailsViewModel(
                        suns: viewModel.tabItems[selection].suns
                    ), isPresented: $viewModel.isSunDetailsViewPresented
                )
            })
            .sheet(isPresented: $viewModel.isAQISheetPresented, content: {
                AQIDetailsView(
                    viewModel: AQIDetailsViewModel(
                        aqiData: viewModel.tabItems[selection].aqiData,
                        premium: premium
                    ), isPresented: $viewModel.isAQISheetPresented
                )
            })
            .sheet(isPresented: $viewModel.isExtraDetailSheetPresented, content: {
                WeatherExtraDetailsView(
                    viewModel: WeatherExtraDetailsViewModel(
                        type: viewModel.extraDetailType,
                        weatherData: viewModel.tabItems[selection].weatherData,
                        premium: viewModel.premium
                    ),
                    isPresented: $viewModel.isExtraDetailSheetPresented
                )
            })
            .sheet(isPresented: $viewModel.isWebViewPresented) {
                if let urlString = viewModel.urlString {
                    WebView(url: .constant(urlString))
                }
            }
            .fullScreenCover(isPresented: $viewModel.isSubscriptionModalPresented, content: {
                SubscriptionView(
                    viewModel: .init(premium: viewModel.premium),
                    isPresented: $viewModel.isSubscriptionModalPresented,
                    isDismissable: false
                )
            })
            .navigationDestination(isPresented: $viewModel.isNavigationLinkActive, destination: {
                switch viewModel.navigationLinkType {
                case .hourly:
                    WeatherDetailsView(
                        viewModel: WeatherDetailsViewModel(
                            type: .hourly,
                            tappedWeather: viewModel.tabItems[selection].tappedWeather,
                            weatherData: viewModel.tabItems[selection].weatherData,
                            aqiData: viewModel.tabItems[selection].aqiData,
                            astronomies: viewModel.tabItems[selection].astronomies,
                            premium: viewModel.premium
                        )
                    )
                    
                case .daily:
                    WeatherDetailsView(
                        viewModel: WeatherDetailsViewModel(
                            type: .daily,
                            tappedWeather: viewModel.tabItems[selection].tappedWeather,
                            weatherData: viewModel.tabItems[selection].weatherData,
                            aqiData: viewModel.tabItems[selection].aqiData,
                            astronomies: viewModel.tabItems[selection].astronomies,
                            premium: viewModel.premium
                        )
                    )
                    
                case .cityList:
                    CityListView(viewModel: CityListViewModel(isCityListOpen: $viewModel.isNavigationLinkActive))
                    
                case .weatherAlerts:
                    WeatherAlertDetailView(alerts: viewModel.tabItems[selection].weatherData.alerts)
                    
                }
            })
            
        }
        .toolbar(.hidden, for: .navigationBar)
        .navigationViewStyle(.stack)
        
    }
    
    
    func moveToSelectedCity(){
        let selectedCity = CityAgent.getSelectedCity()
        for index in 0..<viewModel.tabItems.count {
            if viewModel.tabItems[index].city.id == selectedCity.id {
                previousSelection = index
                selection = index
                viewModel.tabItems[index].onAppear()
            }
        }
    }
    
    
}


private struct WeatherTabIndicator: View {
    
    @ObservedObject var viewModel: WeatherTabViewModel
    var selection: Int
    var shouldUpdate: Bool
    
    var body: some View {
        VStack(spacing: 0){
            Spacer()
            Line().background(Color(.systemGray5)).frame(height: 1)
            HStack{
                Spacer()
                ForEach(0..<viewModel.tabItems.count, id: \.self) { i in
                    Circle().fill(Constants.accentColor.opacity(selection == i ? 1.0 : 0.3))
                        .frame(width: 8, height: 8)
                        .background {
                            if viewModel.tabItems[i].city == CityAgent.getMainCity() {
                                Circle()
                                    .stroke(Constants.accentColor.opacity(selection == i ? 1.0 : 0.3), lineWidth: 1)
                                    .frame(width: 12, height: 12)
                            }
                        }
                }
                Spacer()
            }
            .frame(height: 20)
            .background(Constants.tabbarBackground)
        }
    }
}

extension WeatherTab {
    func changePremiumEnvObject(with newPremium: Premium) {
        premium.autoRenew = newPremium.autoRenew
        premium.expireAt = newPremium.expireAt
        premium.isPremium = newPremium.isPremium
        premium.expireAtTimestamp = newPremium.expireAtTimestamp
    }
}


#if DEBUG
struct WeatherTab_Previews: PreviewProvider {
    static let premium = Premium()
    @State static var isLoadingForRefresher: Bool = false
    @State static var citiesOffset: CGFloat = 0.0
    
    static var previews: some View {
        WeatherTab(viewModel: WeatherTabViewModel(premium: premium))
            .environmentObject(premium)
    }
}
#endif
