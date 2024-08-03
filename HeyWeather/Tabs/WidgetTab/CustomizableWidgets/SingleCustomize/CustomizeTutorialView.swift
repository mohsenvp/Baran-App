//
//  TutorialWidgetView.swift
//  HeyWeather
//
//  Created by Mohammad Yeganeh on 5/23/23.
//

import SwiftUI

struct CustomizeTutorialView<Content: View>: View {
    @Binding var availableSpace: CGFloat
    let topPadding: Double
    let widgetFamily: WidgetSize
    let widgetIndex: Int

    @Binding var isShown: Bool
    @Binding var isParentShown: Bool
    
    @ViewBuilder var widgetPreview: Content
    
    @State var tutorialStep = 0
    
    let tutorialTexts = [
        Text("Long press on the widget that you want to\napply the theme on and select Edit Widget", tableName: "WidgetTab"),
        Text("Next select Widget Style\nfrom Customizable Widgets", tableName: "WidgetTab")
    ]
    
    private var topPaddingCalculated: CGFloat {
        get {
            if widgetFamily == .small {
                return ((availableSpace - Constants.smallWidgetSize.height) / 2) + topPadding
            }else if widgetFamily == .medium {
                return ((availableSpace - Constants.mediumWidgetSize.height) / 2) + topPadding
            }else {
                return availableSpace > Constants.largeWidgetSize.height ? (availableSpace - Constants.largeWidgetSize.height) / 2 + topPadding : topPadding
            }
        }
    }
    private var widgetScaleCalculated: CGFloat {
        get {
            if widgetFamily == .large && availableSpace < Constants.largeWidgetSize.height {
                return (availableSpace - (topPadding)) / Constants.largeWidgetSize.height
            }else {
                return 1
            }
        }
    }
    
    
    @State var editWidgetShown: Bool = false
    @State var mainEditWidgetShown: Bool = false
    @State var blurOpacity = 0.0
    @State var widgetOpacity = 1.0
    @State var widgetAnimatableScale = 1.0

    var body: some View {
        ZStack {
            Blur()
                .opacity(blurOpacity)
                .animation(Constants.isWidthCompact ? nil : .linear(duration: 0.2).delay(0.1), value: blurOpacity)
            
            VStack(spacing: 0){
                widgetPreview
                    .padding(.top, topPaddingCalculated)
                    .scaleEffect(widgetScaleCalculated, anchor: .top)
                    .scaleEffect(widgetAnimatableScale)
                    .slightShadow()
                    .opacity(widgetOpacity)
                    .animation(Constants.isWidthCompact ? nil : .easeOut(duration: 0.2), value: widgetAnimatableScale)
                    .animation(Constants.isWidthCompact ? nil : .linear(duration: 0.1).delay(0.1), value: widgetOpacity)

                TutorialEditPopupView(isShown: $editWidgetShown)
                    .padding(.top, 10)
                
                Spacer()
                
            }.zIndex(1)
            
            VStack {
                CustomizableMainEditView(
                    isShown: $mainEditWidgetShown,
                    widgetIndex: widgetIndex
                )
                .padding(.top, topPaddingCalculated)
                .scaleEffect(widgetScaleCalculated, anchor: .top)
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
                        HeyButton(title: tutorialStep <= 1 ? Text("Next", tableName: "General") : Text("Next", tableName: "General"))
                    }
                    .frame(maxWidth: .infinity)
                    .background(
                        RoundedRectangle(cornerRadius: 12).fill(Color.accentColor)
                    )
                    .padding(.horizontal, 20)
                    .padding(.bottom, 40)
                }.background(.background)
            }
            .opacity(isShown ? 1 : 0)
            .onChange(of: tutorialStep, perform: { step in
                switch step {
                case 1:
                    widgetAnimatableScale = 1.02
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
        .animation(Constants.isWidthCompact ? nil : .linear(duration: 0.2), value: isShown)
    }
    
}


private struct CustomizableMainEditView: View {
    @Binding var isShown: Bool
    @State var myHighlightOpacity = 0.0
    @State var myOpacity = 0.0
    let widgetIndex: Int
    var body: some View {
        VStack(alignment: .leading){
            HStack {
                Image(uiImage: UIImage(named: "AppIcon-0-preview") ?? UIImage())
                    .resizable()
                    .frame(width: 30, height: 30)
                    .cornerRadius(6)
                    
                VStack(alignment: .leading){
                    Text("Customizable Widgets", tableName: "Widgets")
                        .fonted(.title3, weight: .regular)
                    Spacer(minLength: 2)
                    Text("HeyWeather")
                        .fonted(.caption2, weight: .regular)
                        .foregroundColor(.secondary)
                }.frame(maxHeight: 40).clipped()
                Spacer()
            }
            
            Text("Customizable widgets: Personalize every aspect as desired in the app.", tableName: "Widgets")
                .fonted(.caption, weight: .regular)
                .foregroundColor(.gray)
                .padding(.top, 8)
            
            VStack {
                HStack {
                    Text("City", tableName: "WidgetTutorials").fonted(.callout, weight: .regular)
                    Spacer()
                    Text(CityAgent.getMainCity().name)
                        .foregroundColor(.accentColor)
                        .fonted(.body, weight: .regular)
                }
                Divider().padding(.leading, 4).padding(.trailing, -12)
                HStack {
                    Text("Widget Style", tableName: "WidgetTutorials").fonted(.callout, weight: .regular)
                    Spacer()
                    
                    Text("Style \(widgetIndex + 1)", tableName: "WidgetTab")
                    .fonted(.body, weight: .regular)
                    .foregroundColor(.accentColor)
                    .opacity(myHighlightOpacity)
                    .animation(Constants.isWidthCompact ? nil : .linear(duration: 1).repeatForever(), value: myHighlightOpacity)
                }
                
            }
            .padding(12)
            .background(.gray.opacity(0.1))
            .cornerRadius(12)
            
            Spacer()
        }
        .dynamicTypeSize(...DynamicTypeSize.large)
        .padding(20)
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
            }
        }

        
    }
}

struct TutorialWidgetView_Previews: PreviewProvider {
    @State static var edittingTheme: WidgetTheme = .init()
    @State static var isShown: Bool = false
    @State static var isParentShown: Bool = false
    @State static var availabeSpace: CGFloat = Constants.screenHeight
    static var previews: some View {
        CustomizeTutorialView(
            availableSpace: $availabeSpace,
            topPadding: 0,
            widgetFamily: .large,
            widgetIndex: 1,
            isShown: $isShown,
            isParentShown: $isParentShown
        ) {
            CustomizableWidgetPreview(
                theme: edittingTheme,
                widgetFamily: .large,
                widgetIndex: 1,
                weatherData: .init(),
                previewBackgroundImage: {}
            )
        }
    }
}
