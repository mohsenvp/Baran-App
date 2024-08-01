//
//  View+Extension.swift
//  HeyWeather
//
//  Created by Kamyar on 10/20/21.
//

import Foundation
import SwiftUI
import WidgetKit

extension View {
    
    func slightShadow() -> some View {
        return self.shadow(radius: 1)
    }
    
    func mediumShadow() -> some View {
        return self.shadow(radius: 1.5)
    }
    
    func border(width: CGFloat, edges: [Edge], color: Color) -> some View {
        overlay(EdgeBorder(width: width, edges: edges).foregroundColor(color))
    }
    

        
    
    @ViewBuilder func drawLineOver(
        shouldDraw: Bool = true,
        angle: Angle = Angle(degrees: 45),
        lineColor: Color = .accentColor,
        strokeColor: Color = Color.init(.systemBackground),
        lineWidth: CGFloat = 4,
        strokeWidth: CGFloat = 1
    ) -> some View {
        if shouldDraw {
            self.overlay {
                Capsule()
                    .strokeBorder(strokeColor, lineWidth: strokeWidth)
                    .background(Capsule().fill(lineColor).padding(1))
                    .frame(height: lineWidth)
                    .rotationEffect(angle)
            }
        }else {
            self
        }
    }
    
    
    func otherWidgetsBackground() -> some View {
        @Environment(\.colorScheme) var colorScheme
        return self.background(LinearGradient(gradient: Gradient(colors: [colorScheme == .dark ? Constants.otherWidgetsColors[.appleDarkStart]! : Constants.otherWidgetsColors[.appleLightStart]!, colorScheme == .dark ? Constants.otherWidgetsColors[.appleDarkEnd]! : Constants.otherWidgetsColors[.appleLightEnd]!]), startPoint: .top, endPoint: .bottom))
    }
    @ViewBuilder func isLoading(_ isLoading: Binding<Bool>) -> some View {
        if isLoading.wrappedValue {
            self.overlay {
                LogoLoadingView()
            }
        }else {
            self
        }
    }
    
    @ViewBuilder func isIconloading(
        _ isLoading: Bool,
        progressColor: Color = Color.accentColor
    ) -> some View {
        if isLoading {
            self.opacity(0).overlay {
                ProgressView().tint(progressColor)
            }
        }else {
            self.opacity(1)
        }
    }
    
    @ViewBuilder func checkPremiumOverlay(_ premium: Premium) -> some View {
        if !premium.isPremium {
            self.overlay {
                ZStack {
                    Color(.black.withAlphaComponent(0.5))
                    Image(Constants.Icons.premium).foregroundColor(.white)
                        .imageScale(.large)
                        .accessibilityHidden(true)
                }.allowsHitTesting(false)
            }
        }else {
            self
        }
    }
    
    @ViewBuilder func isLocked(_ locked: Bool, cornerRadius: CGFloat = 0, isSubscriptionViewPresented: Binding<Bool>) -> some View {
        if locked {
            self.overlay {
                Button {
                    isSubscriptionViewPresented.wrappedValue.toggle()
                } label: {
                    ZStack {
                        Color(.black.withAlphaComponent(0.5)).cornerRadius(cornerRadius)
                        Image(Constants.Icons.premium).foregroundColor(.white)
                            .imageScale(.large)
                            .accessibilityHidden(true)
                    }
                }
            }
        }else {
            self
        }
    }
    
    @ViewBuilder func isPremium(
        _ isPremium: Bool,
        cornerRadius: CGFloat = 20,
        title: Text = Text("Get 168-hour forecast with Premium!", tableName: "WeatherTab"),
        subtitle: String?,
        isSubscriptionViewPresented: Binding<Bool>,
        shouldBlur: Bool = true,
        isVertical: Bool = false
    ) -> some View {
        
        if !isPremium {
            self.blur(radius: shouldBlur ? 4 : 0)
                .overlay {
                    
                    ZStack(alignment:.center) {
                        Rectangle().fill(Constants.accentRadialGradient)
                        Button {
                            isSubscriptionViewPresented.wrappedValue.toggle()
                        } label: {
                            if isVertical {
                                VStack{
                                    Spacer(minLength: 8)
                                    Image(Constants.Icons.premium)
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 30, height: 30)
                                        .foregroundColor(.white)
                                        .padding(.horizontal)
                                    Spacer(minLength: 0)
                                    
                                    VStack(alignment: .center, spacing: 12){
                                        title
                                            .foregroundColor(Color.white)
                                            .lineLimit(2)
                                            .minimumScaleFactor(0.8)
                                            .fonted(.caption2, weight: .light)
                                        if subtitle != nil {
                                            Text(subtitle!)
                                                .foregroundColor(Color.white)
                                                .lineLimit(2)
                                                .minimumScaleFactor(0.8)
                                                .fonted(.title3, weight: .bold)
                                        }else {
                                            VStack(spacing: 2){
                                                Text("Try Premium", tableName: "Premium")
                                                    .foregroundColor(Color.white)
                                                    .fonted(.body, weight: .light)
                                                Text("FREE!", tableName: "Premium")
                                                    .foregroundColor(Color.white)
                                                    .fonted(.title3, weight: .bold)
                                            }
                                        }
                                        
                                    }
                                    Spacer(minLength: 8)
                                }
                                .padding(.horizontal, 20)
                            }else {
                                HStack(spacing: 20){
                                    Spacer(minLength: 0)
                                    Image(Constants.Icons.premium)
                                        .resizable()
                                        .scaledToFit()
                                        .foregroundColor(.white)
                                        .frame(width: 30, height: 30)
                                    VStack(alignment: .leading){
                                        title
                                            .foregroundColor(Color.white)
                                            .lineLimit(2)
                                            .multilineTextAlignment(.leading)
                                            .fonted(.caption2, weight: .light)
                                        if subtitle != nil {
                                            Text(subtitle!)
                                                .foregroundColor(Color.white)
                                                .lineLimit(2)
                                                .fonted(.title3, weight: .bold)
                                        }else {
                                            HStack(spacing: 2){
                                                Text("Try Premium", tableName: "Premium")
                                                    .foregroundColor(Color.white)
                                                    .lineLimit(1)
                                                    .minimumScaleFactor(0.5)
                                                    .fonted(.callout, weight: .light)
                                                
                                                Text("FREE!", tableName: "Premium")
                                                    .foregroundColor(Color.white)
                                                    .fonted(.callout, weight: .bold)
                                                    .lineLimit(1)
                                                    .minimumScaleFactor(0.8)
                                            }
                                        }
                                        
                                        
                                    }
                                    Spacer(minLength: 0)
                                }
                            }
                        }
                        
                    }
                    .cornerRadius(cornerRadius)
                }
        }else {
            self
        }
    }
    
    
    
    
    @ViewBuilder func frameWidget(size : WidgetSize) -> some View {
        if (size == .small) {
            self
                .frame(width: Constants.smallWidgetSize.width, height: Constants.smallWidgetSize.height)
                .clipShape(RoundedRectangle(cornerRadius: 25, style: .continuous))
        }else if (size == .medium) {
            self
                .frame(width: Constants.mediumWidgetSize.width, height: Constants.mediumWidgetSize.height)
                .clipShape(RoundedRectangle(cornerRadius: 25, style: .continuous))
        }else if (size == .large) {
            self
                .frame(width: Constants.largeWidgetSize.width, height: Constants.largeWidgetSize.height)
                .clipShape(RoundedRectangle(cornerRadius: 25, style: .continuous))
        }
    }
    
}

extension View {
    func onTapGestureForced(count: Int = 1, perform action: @escaping () -> Void) -> some View {
        self
            .contentShape(Rectangle())
            .onTapGesture(count:count, perform:action)
    }
}
