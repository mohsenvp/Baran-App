//
//  TimeTravelView.swift
//  HeyWeather
//
//  Created by Mohammad Yeganeh on 8/22/23.
//

import SwiftUI


struct TimeTravelView: View {
 
    @StateObject var viewModel: TimeTravelViewModel
    @Binding var isPresented: Bool
    @EnvironmentObject var premium: Premium

    var body: some View {
        VStack(spacing: 0){
            
            header
            
            if !premium.isPremium {
                premiumView
            }else if viewModel.isDatePickerVisible {
                TimeTravelDatePickerView(viewModel: viewModel)
                    .transition(.scale.combined(with: .opacity).animation(.linear(duration: 0.2)))
            }
            
            
            datePickerButton
            
            if !viewModel.isDatePickerVisible {
                TimeTravelWeatherView(viewModel: viewModel)
                    .transition(.asymmetric(
                        insertion: .move(edge: .bottom).combined(with: .opacity.animation(.linear(duration: 0.2).delay(0.2))),
                        removal: .move(edge: .bottom).combined(with: .opacity.animation(.linear(duration: 0.2))))
                    )
            }
            
            Spacer()
            
        }
        .background(
            Image(Constants.Patterns.timeTravelTile)
                .resizable(resizingMode: .tile)
                .accessibilityHidden(true)
        )
        .edgesIgnoringSafeArea(.all)
        .sheet(isPresented: $viewModel.isSubscriptionViewPresented, content: {
            SubscriptionView(viewModel: .init(premium: premium), isPresented: $viewModel.isSubscriptionViewPresented)
                .environmentObject(premium)
            
        })
    }
    
    @ViewBuilder var header: some View {
        HStack {
            Text("Time Travel", tableName: "TimeTravel")
                .font(.custom(Constants.AmericanTypewriteFontName, size: 30).weight(.bold))
                .lineLimit(1)
                .foregroundStyle(
                    Constants.TimeTravelPrimary.gradient
                        .shadow(.inner(color: .black.opacity(0.25), radius: 3, x: 1, y: 4))
                    )
            
            Spacer()
            
            Button {
                isPresented.toggle()
            } label: {
                Image(systemName: Constants.SystemIcons.xmark)
            }
            .tint(Constants.TimeTravelPrimary)
            .accessibilityLabel(Text("Dismiss", tableName: "Accessibility"))
            
        }
        .padding(.horizontal, 20)
        .padding(.top, 28)
        .padding(.bottom, 18)
    }
    
    var buttonTitle: Text {
        if !premium.isPremium {
            return Text("GO PREMIUM!", tableName: "Widgets")
        }else if viewModel.isDatePickerVisible {
            return Text("View Weather", tableName: "TimeTravel")
        }else {
            return Text(viewModel.selectedDate.localizedString)
        }
    }
    @ViewBuilder var datePickerButton: some View {
        
        ZStack {
            Line()
                .stroke(style: StrokeStyle(lineWidth: 0.5))
                .foregroundColor(Constants.TimeTravelPrimary)
                .frame(height: 1)
            
            Button {
                if !premium.isPremium {
                    viewModel.isSubscriptionViewPresented.toggle()
                }else if viewModel.isDatePickerVisible {
                    viewModel.getWeather()
                }else {
                    withAnimation(.linear(duration: Constants.motionReduced ? 0.0 : 0.35)) {
                        viewModel.isDatePickerVisible.toggle()
                    }
                }
            } label: {
                ZStack {
                    buttonTitle
                            .font(.custom(Constants.AmericanTypewriteFontName, size: 20))
                            .padding(.horizontal, 20)
                            .padding(.vertical, 6)
                            .opacity(viewModel.isLoading ? 0 : 1)
                    
                    if viewModel.isLoading {
                        ProgressView().accessibilityHidden(true)
                    }
                }
            }
            .tint(Constants.TimeTravelPrimary)
            .background(Constants.TimeTravelButtonBG)
            .background(
                Rectangle().stroke(Constants.TimeTravelPrimary, lineWidth: 0.5)
            )
        }
        .padding(.top)
    }
    
    @ViewBuilder var premiumView: some View {
        
        VStack {
            Line()
                .stroke(style: StrokeStyle(lineWidth: 0.5))
                .foregroundColor(Constants.TimeTravelPrimary)
                .frame(height: 1)
                .padding(.top, 8)
                .accessibilityHidden(true)
            
            Text("View the weather from past", tableName: "TimeTravel")
                .font(.custom(Constants.AmericanTypewriteFontName, size: 16))
                .foregroundColor(Constants.TimeTravelPrimary)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal)
                .padding(.bottom, 10)
                .padding(.top, 8)
            
            Line()
                .stroke(style: StrokeStyle(lineWidth: 0.5))
                .foregroundColor(Constants.TimeTravelPrimary)
                .frame(height: 1)
                .accessibilityHidden(true)
            
            Image(Constants.Icons.premium)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 80)
                .foregroundStyle(
                    Constants.TimeTravelPrimary.gradient
                        .shadow(.inner(color: .black.opacity(0.3), radius: 3, x: 1, y: 4))
                    )
                .padding(.top, 30)
                .accessibilityHidden(true)
            
            Text("This is a\nPremium Feature", tableName: "Premium")
                .font(.custom(Constants.AmericanTypewriteFontName, size: 30).weight(.bold))
                .multilineTextAlignment(.center)
                .foregroundStyle(
                    Constants.TimeTravelPrimary.gradient
                        .shadow(.inner(color: .black.opacity(0.25), radius: 2, x: 1, y: 1))
                    )
                .padding(.vertical, 12)
            
            
            Text("Subscribe to HeyWeather\nPremium to view\nPre Cast Weather Data", tableName: "TimeTravel")
                .font(.custom(Constants.AmericanTypewriteFontName, size: 18).weight(.semibold))
                .foregroundColor(Constants.TimeTravelPrimary)
                .multilineTextAlignment(.center)
                .padding(.vertical, 20)
        }
        .padding(.top)
    }
    
}


