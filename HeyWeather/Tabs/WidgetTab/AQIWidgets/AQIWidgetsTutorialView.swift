//
//  AQIWidgetsTutorialView.swift
//  HeyWeather
//
//  Created by Mohammad Yeganeh on 8/1/23.
//

import SwiftUI


struct AQIWidgetsTutorialView: View {
    
    var weatherData: WeatherData
    var aqiData: AQIData
    @Binding var isShown: Bool
    @Binding var isParentShown: Bool
    @Binding var settings: AQIWidgetSetting
    @Binding var widgetFamily: WidgetSize
    
    @State var tutorialStep = 0
    let tutorialTexts = [
        Text("Long press on the widget that you want to\napply the theme on and select Edit Widget", tableName: "WidgetTab"),
        Text("Next apply the settings as shown\nin the above view", tableName: "WidgetTab")
    ]
    
    @State var editWidgetShown: Bool = false
    @State var mainEditWidgetShown: Bool = false
    @State var blurOpacity = 0.0
    @State var widgetOpacity = 1.0
    
    
    func getWidgetPreview() -> AnyView {
        switch widgetFamily{
        case .small:
            return AnyView(AQIWidgetFamily(weather: weatherData, aqiData: aqiData, setting: settings, widgetSize: .systemSmall, id: 1,
                                           isPreviewForAppWidgetTab: true)
                .frame(width: Constants.smallWidgetSize.width, height: Constants.smallWidgetSize.height)
                .cornerRadius(Constants.widgetRadius))
            
        default:
            return AnyView(AQIWidgetFamily(weather: weatherData, aqiData: aqiData, setting: settings, widgetSize: .systemMedium, id: 1,
                                           isPreviewForAppWidgetTab: true)
                .frame(width: Constants.mediumWidgetSize.width, height: Constants.mediumWidgetSize.height)
                .cornerRadius(Constants.widgetRadius))
        }
    }
    
    var topPadding: CGFloat {
        return Constants.screenHeight / 6
    }
    
    var body: some View {
        ZStack {
            Blur()
                .opacity(blurOpacity)
                .animation(Constants.isWidthCompact ? nil : .linear(duration: 0.2).delay(0.1), value: blurOpacity)
            
            VStack {
                
                getWidgetPreview()
                    .padding(.top, topPadding)
                    .slightShadow()
                    .opacity(widgetOpacity)
                
                TutorialEditPopupView(isShown: $editWidgetShown)
                    .padding(.top, 10)
                
                Spacer()
                
            }.zIndex(1)
            
            VStack {
                AQIMainEditView(
                    isShown: $mainEditWidgetShown,
                    settings: $settings
                )
                .padding(.top, topPadding)
                Spacer()
            }.zIndex(2)
            
            VStack {
                Spacer()
                VStack {
                    tutorialTexts[max(tutorialStep - 1, 0)]
                        .multilineTextAlignment(.center)
                        .fonted(.body, weight: .regular)
                        .padding(20)
                    Button {
                        if tutorialStep == 2 {
                            isParentShown = false
                            return
                        }
                        tutorialStep += 1
                    } label: {
                        HeyButton(title: tutorialStep <= 1 ? Text("Next", tableName: "General") : Text("Done", tableName: "General"))
                    }
                    .frame(maxWidth: .infinity)
                    .background(
                        RoundedRectangle(cornerRadius: 12).fill(Color.accentColor)
                    )
                    .padding(.horizontal, 20)
                    .padding(.bottom, 40)
                }.background(.background)
            }
            .onChange(of: tutorialStep, perform: { step in
                switch step {
                case 1:
                    editWidgetShown = true
                    blurOpacity = 1
                case 2:
                    widgetOpacity = 0
                    editWidgetShown = false
                    mainEditWidgetShown = true
                default:
                    tutorialStep = 0
                }
            }).onChange(of: isShown) { shown in
                if shown {
                    tutorialStep += 1
                }
            }
        }
        .dynamicTypeSize(...DynamicTypeSize.large)
        .opacity(isShown ? 1 : 0)
        .animation(Constants.isWidthCompact ? nil : .linear(duration: 0.2), value: isShown)
        .edgesIgnoringSafeArea(.all)
    }
    
}



private struct AQIMainEditView: View {
    @Binding var isShown: Bool
    @State var myHighlightOpacity = 0.0
    @State var myOpacity = 0.0
    @Binding var settings: AQIWidgetSetting
    @State var isShowCityToggled = false
    @State var isShowAddressToggled = false
    
    var body: some View {
        VStack(alignment: .leading){
            HStack {
                Image(uiImage: UIImage(named: "AppIcon-0-preview") ?? UIImage())
                    .resizable()
                    .frame(width: 30, height: 30)
                    .cornerRadius(6)
                
                VStack(alignment: .leading){
                    Text("AQI Widgets", tableName: "Widgets")
                        .fonted(.title3, weight: .regular)
                    Spacer(minLength: 2)
                    Text("HeyWeather")
                        .fonted(.caption2, weight: .regular)
                        .foregroundColor(.secondary)
                }.frame(maxHeight: 40).clipped()
                Spacer()
            }
            ScrollView(showsIndicators: false) {
                VStack{
                    Text("Protect yourself from pollution with AQI Forecast Widgets", tableName: "Widgets")
                        .fonted(.caption, weight: .regular)
                        .foregroundColor(.gray)
                        .padding(.top, 8)
                    
                    VStack {
                        VStack(spacing: 8){
                            HStack {
                                Text("City", tableName: "WidgetTutorials").fonted(.callout, weight: .regular)
                                Spacer()
                                Text(CityAgent.getMainCity().name)
                                    .foregroundColor(.accentColor)
                                    .fonted(.body, weight: .regular)
                            }
                            Divider().padding(.leading, 4).padding(.trailing, -12)
                        }
                        VStack(spacing: 8){
                            HStack {
                                Text("Widget Style", tableName: "WidgetTutorials").fonted(.callout, weight: .regular)
                                Spacer()
                                Text(settings.widgetStyle.title())
                                    .fonted(.body, weight: .regular)
                                    .foregroundColor(.accentColor)
                                    .opacity(myHighlightOpacity)
                                    .animation(Constants.isWidthCompact ? nil : .linear(duration: 1).repeatForever(), value: myHighlightOpacity)
                            }
                            Divider().padding(.leading, 4).padding(.trailing, -12)
                        }

                        VStack(spacing: 8){
                            HStack {
                                Text("Show City Name", tableName: "WidgetTutorials").fonted(.callout, weight: .regular)
                                Spacer()
                                Toggle(isOn: $isShowCityToggled) {
                                    
                                }.allowsHitTesting(false)
                            }
                            Divider().padding(.leading, 4).padding(.trailing, -12)
                        }
                        VStack(spacing: 8){
                            HStack {
                                Text("Show Address If Available", tableName: "WidgetTutorials").fonted(.callout, weight: .regular)
                                
                                Spacer(minLength: 0)
                                Toggle(isOn: $isShowAddressToggled) {
                                    
                                }.allowsHitTesting(false)
                            }
                        }
                    }
                    .padding(12)
                    .background(.gray.opacity(0.1))
                    .cornerRadius(12)
                    Spacer(minLength: 20)
                }
            }
        }
        .dynamicTypeSize(...DynamicTypeSize.large)
        .padding(.top, 20)
        .padding(.horizontal, 20)
        .frame(width: Constants.largeWidgetSize.width, height: Constants.largeWidgetSize.height)
        .background(.background)
        .cornerRadius(20)
        .shadow(radius: 3)
        .opacity(myOpacity)
        .animation(Constants.isWidthCompact ? nil : .linear(duration: 0.2), value: myOpacity)
        .onChange(of: isShown) { shown in
            if shown {
                myHighlightOpacity = 1
                myOpacity = 1
                isShowCityToggled = settings.showCityName
                isShowAddressToggled = settings.showAddress
            }
        }
        
        
    }
}
