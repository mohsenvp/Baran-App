//
//  PulseView.swift
//  HeyWeather
//
//  Created by Mohammad Yeganeh on 10/9/23.
//

import SwiftUI

enum PulseViewType {
    case circle
    case capsule
}



struct PulseView: View {
    
    let pulseColor: Color
    var showImage: Bool = true
    var pulseShapeType: PulseViewType = .circle
    
    @State var scale1: CGFloat = 1.0
    @State var opacity1: CGFloat = 1.0
    
    @State var scale2: CGFloat = 1.0
    @State var opacity2: CGFloat = 1.0
    
    
    var body: some View {
        ZStack {
            
            switch pulseShapeType {
            case .circle:
                Circle().fill(pulseColor.opacity(0.4))
                    .scaleEffect(scale1, anchor: .center)
                    .opacity(opacity1)
                    .animation(.easeOut(duration: 2).repeatForever(autoreverses: false).delay(0.8), value: scale1)
                    .animation(.easeOut(duration: 1).repeatForever(autoreverses: false).delay(0.8), value: opacity1)
                
                Circle().fill(pulseColor.opacity(0.6))
                    .scaleEffect(scale2, anchor: .center)
                    .opacity(opacity2)
                    .animation(.easeOut(duration: 2).repeatForever(autoreverses: false), value: scale2)
                    .animation(.easeOut(duration: 1).repeatForever(autoreverses: false), value: opacity2)

                Circle().fill(pulseColor)
            case .capsule:
                Capsule().fill(pulseColor.opacity(0.4))
                    .scaleEffect(scale1, anchor: .center)
                    .opacity(opacity1)
                    .animation(.easeOut(duration: 2).repeatForever(autoreverses: false).delay(0.8), value: scale1)
                    .animation(.easeOut(duration: 1).repeatForever(autoreverses: false).delay(0.8), value: opacity1)
                
                Capsule().fill(pulseColor.opacity(0.6))
                    .scaleEffect(scale2, anchor: .center)
                    .opacity(opacity2)
                    .animation(.easeOut(duration: 2).repeatForever(autoreverses: false), value: scale2)
                    .animation(.easeOut(duration: 1).repeatForever(autoreverses: false), value: opacity2)

                Capsule().fill(pulseColor)
            }
            
            if showImage {
                Image(Constants.Icons.warning)
            }
        }
        .accessibilityHidden(true)
        .onAppear {
            scale1 = 2.2
            opacity1 = 0.0
            scale2 = 2.2
            opacity2 = 0.0
        }
    }
}

#Preview {
    ZStack{
        PulseView(pulseColor: .red)
    }
    .frame(width: 200, height: 200)
    .background(.white)
}
