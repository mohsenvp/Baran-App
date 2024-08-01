//
//  ForecastBackgroundView.swift
//  HeyWeather
//
//  Created by Mohammad Yeganeh on 5/21/23.
//

import SwiftUI



struct ForecastBackgroundView: View {
    let widgetLook: WidgetLook
    let widgetBackground: WidgetBackground
    let widgetSize: WidgetSize
    let theme: ForecastTheme
    let compatibalityBGName: String
    let geo: GeometryProxy
    var clear: Bool = false
    
    var body: some View {
        if clear {
            return AnyView(Color.clear)
        }
        switch widgetLook {
        case .original, .neumorph, .simple:
            return AnyView(LinearBG(widgetBackground: widgetBackground, theme: theme))
        case .skeumorph:
            return AnyView(SkeuBG(widgetBackground: widgetBackground,widgetSize: widgetSize, theme: theme, geo: geo))
        }
    }
    
}


struct LinearBG: View {
    
    @Environment(\.colorScheme) var colorScheme
    
    var widgetBackground: WidgetBackground = .blue
    
    var theme: ForecastTheme
    
    var body: some View {
        
        Rectangle().fill(LinearGradient(colors: [theme.gradientLightColor, theme.gradientDarkColor], startPoint: .topLeading, endPoint: .bottomTrailing))
    }
}

struct SkeuBG: View {
    
    @Environment(\.colorScheme) var colorScheme
    
    var widgetBackground: WidgetBackground = .blue
    var widgetSize: WidgetSize
    
    var theme: ForecastTheme
    
    var circleScale: CGFloat
    var circleOffset: CGFloat
    var geo: GeometryProxy
    
    init(widgetBackground: WidgetBackground, widgetSize: WidgetSize, theme: ForecastTheme, geo: GeometryProxy) {
        self.widgetBackground = widgetBackground
        self.widgetSize = widgetSize
        self.theme = theme
        self.geo = geo
        switch widgetSize {
        case .small:
            circleScale = 3
            circleOffset = -(geo.size.height * 1.7)
        case .medium:
            circleScale = 7
            circleOffset = -(geo.size.height * 3.66)
        case .large:
            circleScale = 5
            circleOffset = -(geo.size.height * 2.75)
        default:
            circleScale = 3
            circleOffset = -(geo.size.height * 2.75)
        }
        
    }
    
    //This variable can not be moved to init because og colorScheme
    var circleWhiteOpacity: CGFloat {
        get {
            switch widgetBackground {
            case .def:
                return 0.14
            case .auto:
                return colorScheme == .dark ? 0.1 : 0.8
            case .light:
                return 0.8
            case .dark:
                return 0.08
            case .blue:
                return 0.14
            case .teal:
                return 0.19
            case .orange:
                return 0.28
            case .red:
                return 0.25
            }
        }
        
    }
    var body: some View {
        
        ZStack {
            GeometryReader{ geo in
                
                VStack(spacing: 0){
                    Rectangle().fill(.shadow(.inner(color: theme.darkInnerShadowColor, radius: 3, y: -3)))
                        .frame(maxHeight: geo.size.height * 0.45)
                        .foregroundStyle(LinearGradient(colors: [theme.gradientDarkColor, theme.gradientLightColor], startPoint: .bottom, endPoint: .top))
                    Rectangle().fill(.shadow(.inner(color: theme.lightInnerShadowColor, radius: 3, y: 3)))
                        .frame(maxHeight: geo.size.height * 0.55)
                        .foregroundStyle(LinearGradient(colors: [theme.gradientDarkColor, theme.gradientLightColor], startPoint: .top, endPoint: .bottom))
                }
            }
            
            Circle().fill(LinearGradient(colors: [.white.opacity(0.4), .white.opacity(circleWhiteOpacity)], startPoint: .top, endPoint: .bottom))
                .frame(height: geo.size.height)
                .edgesIgnoringSafeArea(.all)
                .scaleEffect(circleScale)
                .offset(y: circleOffset)
            RoundedRectangle(cornerRadius: 20)
                .fill(.shadow(.inner(color: theme.darkInnerShadowColor.darker(), radius: 14, x:0, y: 0)))
                .foregroundStyle(.radialGradient(colors: [.clear, theme.gradientLightColor], center: .center, startRadius: 0, endRadius: geo.size.height / 2).opacity(0.6))
        }
        
        
    }
}


