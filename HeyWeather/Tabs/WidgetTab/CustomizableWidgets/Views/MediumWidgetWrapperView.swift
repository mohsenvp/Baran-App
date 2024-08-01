//
//  MediumWidgetWrapperView.swift
//  HeyWeather
//
//  Created by mohamd yeganeh on 4/27/23.
//

import SwiftUI

struct MediumWidgetWrapperView: View {
    
    var widgetIndex: Int
    @ObservedObject var viewModel: CustomizableWidgetsViewModel
    @EnvironmentObject var premium : Premium
    @Environment(\.isSubscriptionViewPresented) var isSubscriptionViewPresented

    var body: some View {
        Button {
            if !premium.isPremium && widgetIndex > 0 {
                isSubscriptionViewPresented.wrappedValue = true
                return
            }
            viewModel.customizingWidgetIndex = widgetIndex
            viewModel.customizingWidgetFamily = .medium
            viewModel.isCustomizeActive = true
        } label: {
            VStack {
                ZStack {
                    switch widgetIndex {
                    case 0:
                        MediumWidgetView1(weather: viewModel.weatherData, theme: viewModel.mediumWidgetTheme[widgetIndex],
                                          isPreviewForAppWidgetTab: true)
                    case 1:
                        MediumWidgetView2(weather: viewModel.weatherData, theme: viewModel.mediumWidgetTheme[widgetIndex],
                                          isPreviewForAppWidgetTab: true).checkPremiumOverlay(premium)
                    case 2:
                        MediumWidgetView3(weather: viewModel.weatherData, theme: viewModel.mediumWidgetTheme[widgetIndex],
                                          isPreviewForAppWidgetTab: true).checkPremiumOverlay(premium)
                    case 3:
                        MediumWidgetView4(weather: viewModel.weatherData, theme: viewModel.mediumWidgetTheme[widgetIndex],
                                          isPreviewForAppWidgetTab: true).checkPremiumOverlay(premium)
                    case 4:
                        MediumWidgetView5(weather: viewModel.weatherData, theme: viewModel.mediumWidgetTheme[widgetIndex],
                                          isPreviewForAppWidgetTab: true).checkPremiumOverlay(premium)
                    case 5:
                        MediumWidgetView6(weather: viewModel.weatherData, theme: viewModel.mediumWidgetTheme[widgetIndex],
                                          isPreviewForAppWidgetTab: true).checkPremiumOverlay(premium)
                    case 6:
                        MediumWidgetView7(weather: viewModel.weatherData, theme: viewModel.mediumWidgetTheme[widgetIndex],
                                          isPreviewForAppWidgetTab: true).checkPremiumOverlay(premium)
                    case 7:
                        MediumWidgetView8(weather: viewModel.weatherData, theme: viewModel.mediumWidgetTheme[widgetIndex],
                                          isPreviewForAppWidgetTab: true).checkPremiumOverlay(premium)
                    default:
                        EmptyView()
                    }
                }
                .frame(width: Constants.mediumWidgetSize.width, height: Constants.mediumWidgetSize.height)
                .clipShape(RoundedRectangle(cornerRadius: 25, style: .continuous))
                
                HStack {
                    Text("Medium Style", tableName: "WidgetTab")
                        .accentColor(.init(.label))
                        .fonted(.body, weight: .regular)
                    Text("\(widgetIndex + 1)")
                        .accentColor(.init(.label))
                        .fonted(.body, weight: .regular)
                }
                
            }
            
        }
    }
}

