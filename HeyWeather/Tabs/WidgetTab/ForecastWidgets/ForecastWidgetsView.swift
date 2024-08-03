//
//  ForecastWidgetsView.swift
//  HeyWeather
//
//  Created by Kamyar on 1/26/22.
//

import SwiftUI

struct ForecastWidgetsView: View {
    @EnvironmentObject var premium : Premium
    @Binding var isPresented: Bool
    var weatherData: WeatherData
    
    var body: some View {
        Group {
            if !premium.isPremium {
                PremiumForecasts(isPresented: $isPresented)
            }else {
                SuggestedForecasts(isPresented: $isPresented, weatherData: weatherData)
            }
        }.environment(\.layoutDirection, LocalizeHelper.shared.currentLanguage.isRTL ? .rightToLeft : .leftToRight)
        
    }
    
    
}

private struct SuggestedForecasts: View {
    @Binding var isPresented: Bool
    @State var isTutorialShown: Bool = false
    @State var settings: [ForecastWidgetSetting] = [
        ForecastWidgetSetting(),
        ForecastWidgetSetting(),
        ForecastWidgetSetting(),
        ForecastWidgetSetting()
    ]
    @State var selectedSetting: ForecastWidgetSetting = .init()
    @State var selectedWidgetFamily: WidgetSize = .small
    var weatherData: WeatherData
    
    
    func randomizeSettings(){
        settings = [
            ForecastWidgetSetting(),
            ForecastWidgetSetting(),
            ForecastWidgetSetting(),
            ForecastWidgetSetting()
        ]
    }
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
                    
                    Text("Forecast Widgets", tableName: "Widgets")
                        .fonted(.title2, weight: .bold)
                    
                    Text("Here are some suggestions\ntap on the style you like to see the tutorial", tableName: "Widgets")
                        .fonted(.caption, weight: .regular)
                        .multilineTextAlignment(.center)
                        .foregroundColor(.secondary)
                        .padding(.horizontal, 20)
                    
                    Button {
                        randomizeSettings()
                    } label: {
                        Text("Randomize Again", tableName: "WidgetTab")
                            .fonted(.callout, weight: .medium)
                    }.padding(.bottom, 12)
                    
                    HStack(spacing: 18){
                        Button {
                            selectedSetting = settings[0]
                            selectedWidgetFamily = .small
                            isTutorialShown.toggle()
                        } label: {
                            ForecastWidgetFamily(
                                weather: weatherData,
                                setting: settings[0],
                                widgetSize: .systemSmall,
                                isPreviewForAppWidgetTab: true
                            )
                            .frameWidget(size: .small)
                            .mediumShadow()
                        }
                        
                        
                        Button {
                            selectedWidgetFamily = .small
                            selectedSetting = settings[1]
                            isTutorialShown.toggle()
                        } label: {
                            
                            ForecastWidgetFamily(
                                weather: weatherData,
                                setting: settings[1],
                                widgetSize: .systemSmall,
                                isPreviewForAppWidgetTab: true
                            )
                            .frameWidget(size: .small)
                            .mediumShadow()
                        }
                    }
                    
                    Button {
                        selectedWidgetFamily = .medium
                        selectedSetting = settings[2]
                        isTutorialShown.toggle()
                    } label: {
                        ForecastWidgetFamily(
                            weather: weatherData,
                            setting: settings[2],
                            widgetSize: .systemMedium,
                            isPreviewForAppWidgetTab: true
                        )
                        .frameWidget(size: .medium)
                        .mediumShadow()
                    }
                    
                    Button {
                        selectedWidgetFamily = .large
                        selectedSetting = settings[3]
                        isTutorialShown.toggle()
                    } label: {
                        ForecastWidgetFamily(
                            weather: weatherData,
                            setting: settings[3],
                            widgetSize: .systemLarge,
                            isPreviewForAppWidgetTab: true
                        )
                        .frameWidget(size: .large)
                        .mediumShadow()
                    }
                }
            }
            
            ForecastTutorialView(
                isShown: $isTutorialShown,
                isParentShown: $isPresented,
                settings: $selectedSetting,
                widgetFamily: $selectedWidgetFamily
            )
            
        }
    }
    
}

private struct PremiumForecasts: View {
    @State var isSubscriptionViewPresented: Bool = false
    @EnvironmentObject var premium : Premium
    @Binding var isPresented: Bool
    var body: some View {
        ScrollView(showsIndicators: false){
            VStack {
                HStack {
                    Spacer()
                    Button {
                        isPresented.toggle()
                    } label: {
                        Image(systemName: Constants.SystemIcons.xmark)
                            .padding(20)
                    }
                    .accentColor(.init(.label))
                }
                
                ZStack(alignment: .topLeading) {
                    VStack(alignment: .leading) {
                        Text("HeyWeather")
                            .fonted(.subheadline, weight: .semibold)
                            .foregroundColor(.init(.secondary))
                        
                        Text("Forecast Widgets", tableName: "Widgets")
                            .fonted(.title, weight: .bold)
                            .foregroundColor(.init(.label))
                        
                    }
                    .padding(.top, 20)
                    .padding(.trailing, 120)
                    .accessibilityElement(children: .combine)
                    
                    HStack {
                        Spacer()
                        Image(Constants.Icons.logoart)
                            .resizable()
                            .foregroundColor(Constants.accentColor)
                            .frame(width: 120, height: 120)
                            .accessibilityHidden(true)
                    }
                    
                }
                .padding(.horizontal, 20)
                
                InfiniteImageView()
                    .padding(.vertical, 20)
                
                Button {
                    isSubscriptionViewPresented.toggle()
                } label: {
                    PremiumButton()
                }.padding(20)
            }
        }
        .sheet(isPresented: $isSubscriptionViewPresented) {
            SubscriptionView(viewModel: .init(premium: premium), isPresented: $isSubscriptionViewPresented)
            
        }
    }
    
    struct PremiumButton: View {
        
        var body: some View {
            HStack {
                Image(Constants.Icons.premium)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 30, height: 30)
                    .padding()
                VStack(alignment: .leading) {
                    
                    Text("GO PREMIUM!", tableName: "Widgets")
                        .fonted(.body, weight: .medium)
                    
                    HStack(spacing: 2){
                        Text("TO USE FORECAST WIDGETS", tableName: "Widgets")
                            .opacity(Constants.secondaryOpacity)
                            .fonted(.caption, weight: .regular)
                            .multilineTextAlignment(.leading)
                    }
                    
                    
                }
                Spacer()
                Image(systemName: Constants.SystemIcons.chevronRight)
                    .fonted(.headline, weight: .regular)
                    .flipsForRightToLeftLayoutDirection(true)
                    .padding(.trailing, 12)
                
                
            }
            .foregroundColor(.white)
            .padding()
            .background(Constants.accentGradient)
            .cornerRadius(20)
        }
    }
}


struct forecasts_Previews: PreviewProvider {
    @State static var isPresented = false

    static var previews: some View {
        SuggestedForecasts(isPresented: $isPresented, weatherData: .init())
    }
}
