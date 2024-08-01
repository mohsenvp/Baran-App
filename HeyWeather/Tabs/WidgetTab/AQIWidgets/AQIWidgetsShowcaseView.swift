//
//  AQIWidgetsShowcaseView.swift
//  HeyWeather
//
//  Created by Mohammad Yeganeh on 8/1/23.
//

import SwiftUI

struct AQIWidgetsShowcaseView: View {
    @Binding var isPresented: Bool
    @State var isTutorialShown: Bool = false
    @State var selectedSetting: AQIWidgetSetting = .init()
    @State var selectedWidgetFamily: WidgetSize = .small
    @State var isSubscriptionViewPresented: Bool = false
    var weatherData: WeatherData
    var aqiData: AQIData
    var premium: Premium

    var body: some View {
        ZStack {
            ScrollView(showsIndicators: false){
                
                VStack(spacing: 16){
                    
                    HStack {
                        Spacer()
                        Button {
                            isPresented.toggle()
                        } label: {
                            Image(systemName: Constants.SystemIcons.xmark)
                                .padding(20)
                        }
                        .accentColor(.init(.label))
                    }.zIndex(3)
                    
                    Text("AQI Widgets", tableName: "Widgets")
                        .fonted(.title2, weight: .bold)
                    
                   
                    HStack{
                        Image(systemName: Constants.SystemIcons.questionmarkCircle)
                            .fonted(.title, weight: .regular)

                        Text("You can select AQI widgets from the iOS widget gallery and then choose the desired style by long-pressing the widgets. (Premium)", tableName: "Widgets")
                            .fonted(.callout, weight: .regular)
                    }
                    .padding(16)
                    .background(Color(.secondarySystemBackground))
                    .cornerRadius(Constants.widgetRadius + 6)
                    .padding(.horizontal)
                    .frame(maxWidth: Constants.mediumWidgetSize.width * 1.2 + 32)

                    
                    VStack(spacing: 16){
                        HStack {
                            Spacer()
                            VStack(spacing: 12){
                                Spacer()
                                Text("Simple Style", tableName: "Widgets")
                                    .fonted(.headline, weight: .semibold)
                                Text("Elegant and\nto the point", tableName: "Widgets")
                                    .fonted(.body, weight: .regular)
                                    .multilineTextAlignment(.center)
                                Spacer()

                            }
                            
                            Spacer()

                            AQIWidgetFamily(weather: weatherData, aqiData: aqiData, setting: .init(widgetStyle: .simple, showCityName: false), widgetSize: .systemSmall,
                                            isPreviewForAppWidgetTab: true)
                                .frame(width: Constants.smallWidgetSize.width, height: Constants.smallWidgetSize.height)
                                .cornerRadius(Constants.widgetRadius)
                                .onTapGesture {
                                    selectedSetting = .init(widgetStyle: .simple, showCityName: true)
                                    selectedWidgetFamily = .small
                                    isTutorialShown.toggle()
                                }
                            
                        }
                        AQIWidgetFamily(weather: weatherData, aqiData: aqiData, setting: .init(widgetStyle: .simple, showCityName: false), widgetSize: .systemMedium,
                                        isPreviewForAppWidgetTab: true)
                            .frame(maxWidth: Constants.mediumWidgetSize.width * 1.2)
                            .frame(height: Constants.mediumWidgetSize.height)
                            .cornerRadius(Constants.widgetRadius)
                            .onTapGesture {
                                selectedSetting = .init(widgetStyle: .simple, showCityName: true)
                                selectedWidgetFamily = .medium
                                isTutorialShown.toggle()
                            }
                    }
                    .padding(16)
                    .background(Color(.secondarySystemBackground))
                    .cornerRadius(Constants.widgetRadius + 6)
                    .padding(.horizontal)
                    .frame(maxWidth: Constants.mediumWidgetSize.width * 1.2 + 32)

                    
                    
                    
                    VStack(spacing: 16){
                        
                        AQIWidgetFamily(weather: weatherData, aqiData: aqiData, setting: .init(widgetStyle: .guage, showCityName: false), widgetSize: .systemMedium,
                                        isPreviewForAppWidgetTab: true)
                            .background(Color(.systemBackground))
                            .frame(maxWidth: Constants.mediumWidgetSize.width * 1.2)
                            .frame(height: Constants.mediumWidgetSize.height)
                            .cornerRadius(Constants.widgetRadius)
                            .onTapGesture {
                                if premium.isPremium {
                                    selectedSetting = .init(widgetStyle: .guage, showCityName: true)
                                    selectedWidgetFamily = .medium
                                    isTutorialShown.toggle()
                                }else {
                                    isSubscriptionViewPresented.toggle()
                                }
                            }
                        
                        HStack {
                           

                            AQIWidgetFamily(weather: weatherData, aqiData: aqiData, setting: .init(widgetStyle: .guage, showCityName: false), widgetSize: .systemSmall,
                                            isPreviewForAppWidgetTab: true)
                                .background(Color(.systemBackground))
                                .frame(width: Constants.smallWidgetSize.width, height: Constants.smallWidgetSize.height)
                                .cornerRadius(Constants.widgetRadius)
                                .onTapGesture {
                                    if premium.isPremium {
                                        selectedSetting = .init(widgetStyle: .guage, showCityName: true)
                                        selectedWidgetFamily = .small
                                        isTutorialShown.toggle()
                                    }else {
                                        isSubscriptionViewPresented.toggle()
                                    }
                                }
                            
                            Spacer()
                            VStack(spacing: 12){
                                Spacer()
                                Text("Guage Style", tableName: "Widgets")
                                    .fonted(.headline, weight: .semibold)
                                Text("A more\ngraphical look\n(PREMIUM)", tableName: "Widgets")
                                    .fonted(.body, weight: .regular)
                                    .multilineTextAlignment(.center)
                                Spacer()

                            }
                            
                            Spacer()
                            
                        }
                        
                    }
                    .padding(16)
                    .background(Color(.secondarySystemBackground))
                    .cornerRadius(Constants.widgetRadius + 6)
                    .padding(.horizontal)
                    .frame(maxWidth: Constants.mediumWidgetSize.width * 1.2 + 32)

                    
                    VStack(spacing: 16){
                        
                       
                        HStack {
                            Spacer()

                            VStack(spacing: 12){
                                Spacer()
                                Text("Detailed Style", tableName: "Widgets")
                                    .fonted(.headline, weight: .semibold)
                                Text("Classy and\ninformational\n(PREMIUM)", tableName: "Widgets")
                                    .fonted(.body, weight: .regular)
                                    .multilineTextAlignment(.center)
                                Spacer()

                            }
                            Spacer()

                            AQIWidgetFamily(weather: weatherData, aqiData: aqiData, setting: .init(widgetStyle: .detailed, showCityName: false), widgetSize: .systemSmall,
                                            isPreviewForAppWidgetTab: true)
                                .background(Color(.systemBackground))
                                .frame(width: Constants.smallWidgetSize.width, height: Constants.smallWidgetSize.height)
                                .cornerRadius(Constants.widgetRadius)
                                .onTapGesture {
                                    if premium.isPremium {
                                        selectedSetting = .init(widgetStyle: .detailed, showCityName: true)
                                        selectedWidgetFamily = .small
                                        isTutorialShown.toggle()
                                    }else {
                                        isSubscriptionViewPresented.toggle()
                                    }
                                }
                            
                            
                        }
                        
                        AQIWidgetFamily(weather: weatherData, aqiData: aqiData, setting: .init(widgetStyle: .detailed, showCityName: false), widgetSize: .systemMedium,
                                        isPreviewForAppWidgetTab: true)
                            .background(Color(.systemBackground))
                            .frame(maxWidth: Constants.mediumWidgetSize.width * 1.2)
                            .frame(height: Constants.mediumWidgetSize.height)
                            .cornerRadius(Constants.widgetRadius)
                            .onTapGesture {
                                if premium.isPremium {
                                    selectedSetting = .init(widgetStyle: .detailed, showCityName: true)
                                    selectedWidgetFamily = .medium
                                    isTutorialShown.toggle()
                                }else {
                                    isSubscriptionViewPresented.toggle()
                                }
                            }
                        
                        
                    }
                    .padding(16)
                    .background(Color(.secondarySystemBackground))
                    .cornerRadius(Constants.widgetRadius + 6)
                    .padding(.horizontal)
                    .frame(maxWidth: Constants.mediumWidgetSize.width * 1.2 + 32)

                }
            }
            
            AQIWidgetsTutorialView(
                weatherData: weatherData,
                aqiData: aqiData,
                isShown: $isTutorialShown,
                isParentShown: $isPresented,
                settings: $selectedSetting,
                widgetFamily: $selectedWidgetFamily
            )

            
        }
        .dynamicTypeSize(...Constants.maxDynamicType)
        .environment(\.layoutDirection, LocalizeHelper.shared.currentLanguage.isRTL ? .rightToLeft : .leftToRight)
        .sheet(isPresented: $isSubscriptionViewPresented, content: {
            SubscriptionView(viewModel: .init(premium: premium), isPresented: $isSubscriptionViewPresented)
                .environmentObject(premium)
            
        })
        .onReceive(Constants.premiumPurchaseWasSuccessfulPublisher) { _ in
            isPresented = false
        }
        
    }
}
