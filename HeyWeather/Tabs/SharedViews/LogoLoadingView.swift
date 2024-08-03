//
//  LogoLoadingView.swift
//  HeyWeather
//
//  Created by Mohammad Yeganeh on 7/1/23.
//

import SwiftUI
struct LogoLoadingView: View {

    var logoSize: CGFloat {
        #if os(watchOS)
        return 100
        #else
        return 200
        #endif
    }
    var body: some View {
        ZStack {
            
            #if os(watchOS)
            Rectangle().fill(.thickMaterial)
                .edgesIgnoringSafeArea(.all)
            #else
            Blur()
                .edgesIgnoringSafeArea(.all)
            #endif
            
            VStack(spacing:0){
                AnimatedLogoView()
                    .frame(width: logoSize, height: logoSize)
            #if !os(watchOS)
                HStack(spacing: 0){
                    Text("Please wait", tableName: "General")
                        .fonted(.subheadline, weight: .heavy)
                        .frame(height: 30)
                        .transition(.slide)
                        .foregroundStyle(.primary)
                    
                }
            #endif
            }
            
        }
        .environment(\.layoutDirection, .leftToRight)
        .dynamicTypeSize(...DynamicTypeSize.large)
    }
}

struct AnimatedLogoView: View {
    @State var scale: CGFloat = 1
    @State var rotation: CGFloat = 0

    var body: some View {
        GeometryReader { geo in
            let width = geo.size.width
            ZStack {
                Image(Constants.Icons.logoSun)
                    .resizable()
                    .frame(width: width / 2, height: width / 2)
                    .rotationEffect(.degrees(rotation))
                    .animation(Constants.motionReduced ? nil : .linear(duration: 10).repeatForever(autoreverses: false), value: rotation)
                    .position(x: width / 1.6, y: width / 2.25)


                Image(Constants.Icons.logoCircle)
                    .resizable()
                    .frame(width: width / 3.5, height: width / 3.5)
                    .position(x: width / 3.76, y: width / 1.62)
                    .scaleEffect(scale, anchor: .trailing)
                    .animation(Constants.motionReduced ? nil : .linear(duration: 1.3).repeatForever(autoreverses: true), value: scale)

                Image(Constants.Icons.logoCircle)
                    .resizable()
                    .frame(width: width / 3.2, height: width / 3.2)
                    .position(x: width / 1.72, y: width / 1.54)
                    .scaleEffect(scale, anchor: .leading)
                    .animation(Constants.motionReduced ? nil : .linear(duration: 1.3).repeatForever(autoreverses: true), value: scale)

                Image(Constants.Icons.logoCircle)
                    .resizable()
                    .frame(width: width / 2.5, height: width / 2.5)
                    .position(x: width / 2.35, y: width / 1.85)
                    .scaleEffect(scale, anchor: .bottom)
                    .animation(Constants.motionReduced ? nil : .linear(duration: 1.3).repeatForever(autoreverses: true), value: scale)

            }
        }.onAppear {
            scale = 0.97
            rotation = 360
        }
    }
}
struct LogoLoadingView_Previews: PreviewProvider {
    static var previews: some View {
        AnimatedLogoView()
            .previewLayout(.fixed(width: 200, height: 200))
    }
}
