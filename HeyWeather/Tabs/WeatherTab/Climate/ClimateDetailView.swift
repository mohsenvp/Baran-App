//
//  ClimateDetailView.swift
//  HeyWeather
//
//  Created by Mohammad Yeganeh on 6/24/23.
//

import SwiftUI

struct ClimateDetailView: View {
    @StateObject var viewModel: ClimateDetailViewModel
    @Binding var isPresented: Bool
    @EnvironmentObject var premium: Premium

    @Environment(\.colorScheme) var colorScheme: ColorScheme
    
    var body: some View {
        ZStack {
            Color(colorScheme == .light ? .secondarySystemBackground : .systemBackground).ignoresSafeArea()
         
            ScrollView(showsIndicators: false){
                VStack(spacing: 14){
                    ZStack {
                        HStack {
                            Spacer()
                            Text("Climate Data", tableName: "Climate")
                                .fonted(.headline)
                            Spacer()
                        }
                        HStack {
                            Spacer()
                            Button {
                                isPresented.toggle()
                            } label: {
                                Image(systemName: Constants.SystemIcons.xmark)
                            }
                            .padding(20)
                            .accentColor(.init(.label))
                            .accessibilityLabel(Text("Dismiss", tableName: "Accessibility"))
                        }
                    }
                    .unredacted()
                    
                    
                    
                    if premium.isPremium {
                        HStack {
                            Text(viewModel.city.placeMarkCityName)
                                .fonted(.title, weight: .semibold)
                                .padding(.leading, 4)
                            Spacer()
                        }
                        Group {
                            ClimateSummaryView(climateData: viewModel.climateData)
                            
                            ClimateTemperatureView(viewModel: viewModel)
                            
                            ClimateRainFallView(viewModel: viewModel)
                            
                            ClimateSnowFallView(viewModel: viewModel)
                            
                            ClimateDaylightView(viewModel: viewModel)
                        }
                        .weatherTabShape()
                        
                    }else {
                        Image(Constants.Icons.premium)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 80)
                            .padding(.vertical, 20)
                            .accessibilityHidden(true)

                        Text("This is a\nPremium Feature", tableName: "Premium")
                            .fonted(.title2, weight: .semibold)
                            .multilineTextAlignment(.center)
                        
                        Text("Subscribe to HeyWeather\nPremium to view\nClimate Data", tableName: "Climate")
                            .fonted(.subheadline, weight: .semibold)
                            .foregroundStyle(.secondary)
                            .multilineTextAlignment(.center)
                            .padding(.vertical, 30)
                        
                        Button(action: {
                            viewModel.isSubscriptionViewPresented.toggle()
                        }, label: {
                            HeyButton(title: Text("GO PREMIUM!", tableName: "Widgets"))
                        })
                    }
                    
                }.padding()
            }
//            .redacted(isRedacted: $viewModel.isRedacted)
        }
        .sheet(isPresented: $viewModel.isSubscriptionViewPresented, content: {
            SubscriptionView(viewModel: .init(premium: premium), isPresented: $viewModel.isSubscriptionViewPresented)
                .environmentObject(premium)
        })
        .environment(\.layoutDirection, LocalizeHelper.shared.currentLanguage.isRTL ? .rightToLeft : .leftToRight)
        .dynamicTypeSize(...Constants.maxDynamicType)
        
    }
}
