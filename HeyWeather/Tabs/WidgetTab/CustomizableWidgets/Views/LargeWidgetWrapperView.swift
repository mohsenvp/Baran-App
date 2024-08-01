//
//  LargeWidgetWrapperView.swift
//  HeyWeather
//
//  Created by mohamd yeganeh on 4/27/23.
//

import SwiftUI

struct LargeWidgetWrapperView: View {
    
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
            viewModel.customizingWidgetFamily = .large
            viewModel.isCustomizeActive = true
        } label: {
            VStack {
                ZStack {
                    switch widgetIndex {
                    case 0:
                        LargeWidgetView1(weather: viewModel.weatherData, theme: viewModel.largeWidgetTheme[widgetIndex],
                                         isPreviewForAppWidgetTab: true)
                    case 1:
                        LargeWidgetView2(weather: viewModel.weatherData, theme: viewModel.largeWidgetTheme[widgetIndex],
                                         isPreviewForAppWidgetTab: true).checkPremiumOverlay(premium)
                    case 2:
                        LargeWidgetView3(weather: viewModel.weatherData, theme: viewModel.largeWidgetTheme[widgetIndex],
                                         isPreviewForAppWidgetTab: true).checkPremiumOverlay(premium)
                    case 3:
                        LargeWidgetView4(weather: viewModel.weatherData, theme: viewModel.largeWidgetTheme[widgetIndex],
                                         isPreviewForAppWidgetTab: true).checkPremiumOverlay(premium)
                    case 4:
                        LargeWidgetView5(weather: viewModel.weatherData, theme: viewModel.largeWidgetTheme[widgetIndex],
                                         isPreviewForAppWidgetTab: true).checkPremiumOverlay(premium)
                    case 5:
                        LargeWidgetView6(weather: viewModel.weatherData, theme: viewModel.largeWidgetTheme[widgetIndex],
                                         isPreviewForAppWidgetTab: true).checkPremiumOverlay(premium)
                    default:
                        EmptyView()
                    }
                }
                .frame(width: Constants.largeWidgetSize.width, height: Constants.largeWidgetSize.height)
                .clipShape(RoundedRectangle(cornerRadius: 25, style: .continuous))
                
                HStack {
                    Text("Detailed Style", tableName: "WidgetTab")
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

