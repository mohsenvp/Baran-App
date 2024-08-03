//
//  ContentView.swift
//  HeyWeather
//
//  Created by Kamyar on 10/10/21.
//

import SwiftUI



struct MainTab: View {
    @Environment(\.scenePhase) var scenePhase
    @StateObject var viewModel = MainTabViewModel()
    @ObservedObject var localizeHelper = LocalizeHelper.shared
    @ObservedObject var appState = AppState.shared
    @Environment(\.isSubscriptionViewPresented) var isSubscriptionViewPresented
    static let generalTable: String = "Widgets"

    var body: some View {
        ZStack {
            TabView(selection: $appState.navigateToTab){
                
                WeatherTab(viewModel: WeatherTabViewModel(premium: viewModel.premium))
                .tabItem {
                    ConditionIcon(
                        iconSet: Constants.defaultTabBarIconSet,
                        condition: appState.weatherCondition
                    )
                    Text("Weather", tableName: "TabItems")
                }
                .tag(Tab.weather)
                
                
                WidgetTab()
                .tabItem {
                    Image(Constants.Icons.tabWidget)
                    Text("Widgets", tableName: "TabItems")
                }
                .overlay(TabbarTopLine())
                .tag(Tab.widget)

                
                MapsTab()
                .tabItem {
                    Image(Constants.Icons.tabMap)
                    Text("Maps", tableName: "TabItems")
                }
                .overlay(TabbarTopLine())
                .tag(Tab.maps)
                
                
                SettingsTab()
                    .tabItem {
                        Image(Constants.Icons.tabSetting)
                        Text("Settings", tableName: "TabItems")
                    }
                    .overlay(TabbarTopLine())
                    .tag(Tab.settings)
            }
            .onChange(of: scenePhase) { newPhase in
                viewModel.updateCurrentPhaseToNewPhase(newPhase)
            }
            .sheet(isPresented: $viewModel.isSubscriptionViewPresented, content: {
                SubscriptionView(viewModel: .init(premium: viewModel.premium), isPresented: $viewModel.isSubscriptionViewPresented)
                    .preferredColorScheme(appState.colorScheme)
                    .environment(\.locale, Locale(identifier: localizeHelper.currentLanguage.rawValue))
                    .environmentObject(viewModel.premium)
                
            })

            LogoLoadingView()
                .opacity(appState.isLoading ? 1 : 0)
                .allowsHitTesting(appState.isLoading)


        }
        .environmentObject(viewModel.premium)
        .environment(\.font, .system(.body, design: Constants.appFontDesign))
        .environment(\.isSubscriptionViewPresented, $viewModel.isSubscriptionViewPresented)
        .environment(\.locale, Locale(identifier: localizeHelper.currentLanguage.rawValue))
        .environment(\.layoutDirection, localizeHelper.currentLanguage.isRTL ? .rightToLeft : .leftToRight)
        .dynamicTypeSize(...Constants.maxDynamicType)
        .preferredColorScheme(appState.colorScheme)


    }
}

private struct TabbarTopLine: View {
    var body: some View {
        VStack(spacing: 0){
            Spacer()
            Line().background(Color(.systemGray5)).frame(height: 1)
        }
    }
}

#if DEBUG
struct MainTab_Previews: PreviewProvider {
    static var previews: some View {
        MainTab()
    }
}
#endif

