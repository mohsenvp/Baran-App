//
//  AnimatedWindView.swift
//  HeyWeather
//
//  Created by Mohammad Yeganeh on 11/25/23.
//

import Foundation
import SwiftUI
struct AnimatedWindView: View {
    
    @State private var pathProgress = 0.0
    var height: CGFloat = 50.0
    var windSpeed: CGFloat = 10
    var body: some View {
        VStack(spacing: 0){
            WindWave()
                .trim(from: -0.3 + pathProgress, to: pathProgress)
                .stroke(LinearGradient(colors: [.clear, .blue, .purple, .clear], startPoint: .leading, endPoint: .trailing), lineWidth: 3)
                .frame(width: 200, height: 30)
                .animation(.linear(duration: 1.1).delay(0).repeatForever(autoreverses: false), value: pathProgress)
            
            WindWave()
                .trim(from: -0.3 + pathProgress, to: pathProgress)
                .stroke(LinearGradient(colors: [.clear, .blue, .purple, .clear], startPoint: .leading, endPoint: .trailing), lineWidth: 3)
                .frame(width: 200, height: 30)
                .animation(.linear(duration: 1).delay(0.1).repeatForever(autoreverses: false), value: pathProgress)
            
            WindWave()
                .trim(from: -0.3 + pathProgress, to: pathProgress)
                .stroke(LinearGradient(colors: [.clear, .blue, .purple, .clear], startPoint: .leading, endPoint: .trailing), lineWidth: 3)
                .frame(width: 200, height: 30)
                .animation(.linear(duration: 0.8).delay(0.2).repeatForever(autoreverses: false), value: pathProgress)
            
            WindWave()
                .trim(from: -0.3 + pathProgress, to: pathProgress)
                .stroke(LinearGradient(colors: [.clear, .blue, .purple, .clear], startPoint: .leading, endPoint: .trailing), lineWidth: 3)
                .frame(width: 200, height: 30)
                .animation(.linear(duration: 0.9).delay(0.3).repeatForever(autoreverses: false), value: pathProgress)
        }
        .scaleEffect(height / 120)
        .frame(height: height)
        .clipped()
        .frame(width: height)
        .onAppear {
            pathProgress = 1.3
        }
        
    }
}
private struct WindWave: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
                let width = rect.size.width
                let height = rect.size.height
                path.move(to: CGPoint(x: 0.01053*width, y: 0.32947*height))
                path.addCurve(to: CGPoint(x: 0.32287*width, y: 0.94989*height), control1: CGPoint(x: 0.15097*width, y: 0.5196*height), control2: CGPoint(x: 0.18645*width, y: 0.95788*height))
                path.addCurve(to: CGPoint(x: 0.73373*width, y: 0.05928*height), control1: CGPoint(x: 0.50922*width, y: 0.93898*height), control2: CGPoint(x: 0.57022*width, y: 0.16934*height))
                path.addCurve(to: CGPoint(x: 0.98947*width, y: 0.41953*height), control1: CGPoint(x: 0.83678*width, y: -0.01009*height), control2: CGPoint(x: 0.88466*width, y: 0.32947*height))
                return path
      }

}


#Preview {
    AnimatedWindView()
}
