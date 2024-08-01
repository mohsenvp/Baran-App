//
//  SmallWidgetWrapperView.swift
//  HeyWeather
//
//  Created by mohamd yeganeh on 4/27/23.
//

import SwiftUI

struct SmallWidgetWrapperView: View {
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
            viewModel.customizingWidgetFamily = .small
            viewModel.isCustomizeActive = true
        } label: {
            VStack {
                ZStack {
                    switch widgetIndex {
                    case 0:
                        SmallWidgetView1(weather: viewModel.weatherData, theme: viewModel.smallWidgetTheme[widgetIndex],
                                         isPreviewForAppWidgetTab: true)
                    case 1:
                        SmallWidgetView2(weather: viewModel.weatherData, theme: viewModel.smallWidgetTheme[widgetIndex],
                                         isPreviewForAppWidgetTab: true).checkPremiumOverlay(premium)
                    case 2:
                        SmallWidgetView3(weather: viewModel.weatherData, theme: viewModel.smallWidgetTheme[widgetIndex],
                                         isPreviewForAppWidgetTab: true).checkPremiumOverlay(premium)
                    case 3:
                        SmallWidgetView4(weather: viewModel.weatherData, theme: viewModel.smallWidgetTheme[widgetIndex],
                                         isPreviewForAppWidgetTab: true).checkPremiumOverlay(premium)
                    case 4:
                        SmallWidgetView5(weather: viewModel.weatherData, theme: viewModel.smallWidgetTheme[widgetIndex],
                                         isPreviewForAppWidgetTab: true).checkPremiumOverlay(premium)
                    case 5:
                        SmallWidgetView6(weather: viewModel.weatherData, theme: viewModel.smallWidgetTheme[widgetIndex],
                                         isPreviewForAppWidgetTab: true).checkPremiumOverlay(premium)
                    case 6:
                        SmallWidgetView7(weather: viewModel.weatherData, theme: viewModel.smallWidgetTheme[widgetIndex],
                                         isPreviewForAppWidgetTab: true).checkPremiumOverlay(premium)
                    case 7:
                        SmallWidgetView8(weather: viewModel.weatherData, theme: viewModel.smallWidgetTheme[widgetIndex],
                                         isPreviewForAppWidgetTab: true).checkPremiumOverlay(premium)
                    default:
                        EmptyView()
                    }
                }
                .frame(width: Constants.smallWidgetSize.width, height: Constants.smallWidgetSize.height)
                .clipShape(RoundedRectangle(cornerRadius: 25, style: .continuous))
                
                HStack {
                    Text("Mini Style", tableName: "WidgetTab")
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

