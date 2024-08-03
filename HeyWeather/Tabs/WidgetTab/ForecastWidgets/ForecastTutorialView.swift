//
//  ForecastTutorialView.swift
//  HeyWeather
//
//  Created by Mohammad Yeganeh on 5/23/23.
//

import SwiftUI

protocol ForecastWidgetWrapper {
    associatedtype T: View
    var view: T { get }
}
struct ForecastTutorialView: View {
    
    @Binding var isShown: Bool
    @Binding var isParentShown: Bool
    @Binding var settings: ForecastWidgetSetting
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
            return AnyView(ForecastWidgetFamily(setting: settings, widgetSize: .systemSmall, isPreviewForAppWidgetTab: true).frameWidget(size: .small))
        case .medium:
            return AnyView(ForecastWidgetFamily(setting: settings, widgetSize: .systemMedium, isPreviewForAppWidgetTab: true).frameWidget(size: .medium))
        default:
            return AnyView(ForecastWidgetFamily(setting: settings, widgetSize: .systemLarge, isPreviewForAppWidgetTab: true).frameWidget(size: .large))
        }
    }
    
    var topPadding: CGFloat {
        if widgetFamily == .large {
            return 80
        }else {
            return Constants.screenHeight / 6
        }
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
                ForecastMainEditView(
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



private struct ForecastMainEditView: View {
    @Binding var isShown: Bool
    @State var myHighlightOpacity = 0.0
    @State var myOpacity = 0.0
    @Binding var settings: ForecastWidgetSetting
    @State var isShowCityToggled = false
    @State var isShowFeelsLikeToggled = false
    @State var isShowAddressToggled = false
    
    var body: some View {
        VStack(alignment: .leading){
            HStack {
                Image(uiImage: UIImage(named: "AppIcon-0-preview") ?? UIImage())
                    .resizable()
                    .frame(width: 30, height: 30)
                    .cornerRadius(6)
                
                VStack(alignment: .leading){
                    Text("Forecast Widgets", tableName: "Widgets")
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
                    Text("Forecast Widgets offering hourly and daily forecast, customizable by long-pressing the widget (PREMIUM)", tableName: "Widgets")
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
                                Text("Widget Look", tableName: "WidgetTutorials").fonted(.callout, weight: .regular)
                                Spacer()
                                Text(settings.widgetLook.title())
                                    .fonted(.body, weight: .regular)
                                    .foregroundColor(.accentColor)
                                    .opacity(myHighlightOpacity)
                                    .animation(Constants.isWidthCompact ? nil : .linear(duration: 1).repeatForever(), value: myHighlightOpacity)
                            }
                            Divider().padding(.leading, 4).padding(.trailing, -12)
                        }
                        VStack(spacing: 8){
                            HStack {
                                Text("Background", tableName: "WidgetTutorials").fonted(.callout, weight: .regular)
                                Spacer()
                                Text(settings.widgetBackground.title()).fonted(.body, weight: .regular)
                                    .foregroundColor(.accentColor)
                                    .opacity(myHighlightOpacity)
                                    .animation(Constants.isWidthCompact ? nil : .linear(duration: 1).repeatForever(), value: myHighlightOpacity)
                            }
                            Divider().padding(.leading, 4).padding(.trailing, -12)
                        }
                        VStack(spacing: 8){
                            HStack {
                                Text("Forecast Type", tableName: "WidgetTutorials").fonted(.callout, weight: .regular)
                                Spacer()
                                Text(settings.forecastType.title())
                                    .fonted(.body, weight: .regular)
                                    .foregroundColor(.blue)
                                    .opacity(myHighlightOpacity)
                                    .animation(Constants.isWidthCompact ? nil : .linear(duration: 1).repeatForever(), value: myHighlightOpacity)
                            }
                            Divider().padding(.leading, 4).padding(.trailing, -12)
                        }
                        VStack(spacing: 8){
                            HStack {
                                Text("Show Feels Like", tableName: "WidgetTutorials").fonted(.callout, weight: .regular)
                                Spacer()
                                Toggle(isOn: $isShowFeelsLikeToggled) {
                                    
                                }.allowsHitTesting(false)
                                
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
                isShowFeelsLikeToggled = settings.showFeelsLike
                isShowCityToggled = settings.showCityName
                isShowAddressToggled = settings.showAddress
            }
        }
        
        
    }
}

struct asdasd_Previews: PreviewProvider {
    @State static var isShown = true
    @State static var settings = ForecastWidgetSetting()

    static var previews: some View {
        ForecastMainEditView(isShown: $isShown, settings: $settings)
    }
}
