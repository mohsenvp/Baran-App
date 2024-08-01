//
//  LighteningEffect.swift
//  HeyWeather
//
//  Created by Reza Ranjbaran on 03/06/2023.
//

import Foundation
import SwiftUI

struct StormView : View {
    var intensity: WeatherCondition.Intensity
    var timer: Timer.TimerPublisher? = nil
    let feedbackGenerator = UIImpactFeedbackGenerator()

    @State var lightningCount = 0
    
    init(intensity: WeatherCondition.Intensity) {
        self.intensity = intensity
        var count : Int {
            switch intensity {
            case .light:
                return 10
            case .normal:
                return 5
            case .heavy:
                return 3
            }
        }
        timer = Timer.publish(every: TimeInterval(count), on: .main, in: .common)
        _ = timer?.connect()
    }
    
    var body : some View {
        GeometryReader { geo in
            let w = geo.size.width
            let h = geo.size.height
            SingleStormView(w: w, h: h, counter: $lightningCount)
        }
        .onReceive(timer!) { _ in
            lightningCount += 1
            switch(intensity) {
            case .heavy:
                feedbackGenerator.impactOccurred(intensity: 1.0)
            case .normal:
                feedbackGenerator.impactOccurred(intensity: 6.0)
            case .light:
                feedbackGenerator.impactOccurred(intensity: 3.0)
            }
        }
        .clipped()
    }
    
    struct SingleStormView : View {
        let w : CGFloat
        let h : CGFloat
        @Binding var counter: Int

        @State var opacity: CGFloat = 0.0
        
        @State var lightningWidth: CGFloat = 0
        @State var lightningOffset: CGFloat = 0.0
        @State var lightningName = "lightening_particle_1"
        @State var maskHeight: CGFloat = 0.0
        
        var body: some View {
            
            Image(lightningName)
                .resizable()
                .scaledToFit()
                .frame(width: lightningWidth)
                .offset(x: lightningOffset)
                .foregroundColor(Color.white)
                .opacity(opacity)
                .mask(alignment: .top, {
                    Rectangle()
                        .frame(width: lightningWidth, height: maskHeight)
                        .offset(x: lightningOffset)

                })
                .onChange(of: counter) { _ in
                    lightningWidth = CGFloat(Int.random(in: 100..<160))
                    lightningOffset = CGFloat.random(in: w * 0.2 ..< w * 0.8)
                    lightningName = "lightening_particle_\(Int.random(in: 1...7))"
              
                    opacity = 1
                    withAnimation(.linear(duration: Constants.motionReduced ? 0 : 0.3)) {
                        maskHeight = h
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.2, execute: {
                        withAnimation(.linear(duration: Constants.motionReduced ? 0 : 0.3)){
                            self.opacity = 0
                        }
                    })
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
                        self.maskHeight = 0
                    })
                    
                }
            
        }
    }
}

#if DEBUG
struct StormView_Previews: PreviewProvider {
    static var previews: some View {
        StormView(intensity: .heavy).background(.black)

    }
}
#endif
