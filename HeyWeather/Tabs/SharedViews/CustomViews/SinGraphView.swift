//
//  SinGraphView.swift
//  HeyWeather
//
//  Created by Mojtaba on 10/25/23.
//

import SwiftUI

struct SinGraphView: View {
    
    var daylightPercentage: Double
    var dayProgress: Double
    
    @State private var viewHeight: CGFloat = 100.0
    
    @State private var rotateSun : CGFloat = 0.0
    @State private var scaleSun : CGFloat = 1.0
    
    @State private var trimGraph: CGFloat = 0
    @State private var sunPosition: CGFloat = 0
    
    var body: some View {
        
            GeometryReader { geometry in
                
                let rectWidth = geometry.size.width
                let rectHeight = geometry.size.width
                
                let numberOfPoints = Int(rectWidth)
                
                let desiredCurve: Double = (1 - daylightPercentage).interpolated(from: 0.01...0.99, to: 3.0...15.0)
                
                let amplitude = rectHeight / desiredCurve
                
                let c: CGFloat = -0.5 * .pi
                let d: CGFloat = amplitude
                
                HStack {
                    Image(Constants.Icons.sun)
                        .frame(width: 15, height: 15)
                        .rotationEffect(.degrees(rotateSun), anchor:  .center)
                        .animation(Constants.motionReduced ? nil : .linear(duration: 90).repeatForever(autoreverses: false), value: rotateSun)
                        .scaleEffect(scaleSun, anchor: .center)
                        .animation(Constants.motionReduced ? nil : .linear(duration: 1).repeatForever(autoreverses: true), value: scaleSun)
                        .onAppear {
                            
                            scaleSun = 0.8
                            rotateSun = 360
                    }
                }
                .modifier(SinusModifier(progress: CGFloat(sunPosition),
                                    pathHeight: amplitude,
                                    pathWidth: rectWidth)
                )
                .animation(Constants.motionReduced ? nil : .easeInOut(duration: 5), value: sunPosition)
                .onAppear {
                    sunPosition = CGFloat(dayProgress)
                }
                .zIndex(1)
                
                Path { path in
                    for pointIndex in 0...(numberOfPoints) {
                        let x = CGFloat(pointIndex)
                        let angle = ((Double(x) / Double(rectWidth)) * .pi * 2 ) - c
                        let y = amplitude * sin(angle) + d
                        let point = CGPoint(x: x, y:  y)
                        if pointIndex == 0 {
                            path.move(to: point)
                        } else {
                            path.addLine(to: point)
                        }
                    }
                }
                .stroke(style: .init(lineWidth: 1, lineCap: .round, lineJoin: .round, dash: [2.5]))
                .fill(Color(.secondaryLabel))
                .frame(width: rectWidth, height: amplitude * 2)
                .opacity(Constants.secondaryOpacity)
                .onAppear {
                    viewHeight = amplitude * 2
                }
       
                Path { path in
                    for pointIndex in 0...numberOfPoints {
                        let x = CGFloat(pointIndex)
                        let angle = ((Double(x) / Double(rectWidth)) * .pi * 2 ) - c
                        let y = amplitude * sin(angle) + d
                        let point = CGPoint(x: x, y:  y)
                        if pointIndex == 0 {
                            path.move(to: point)
                        } else {
                            path.addLine(to: point)
                        }
                    }
                }
                .trim(from: 0.0, to: trimGraph)
                .stroke(Constants.accentColor.opacity(0.75), style: StrokeStyle(lineWidth: 4, lineCap: .round))
                .frame(width: rectWidth, height: amplitude * 2)
                .animation(Constants.motionReduced ? nil : .easeInOut(duration: 5), value: trimGraph)
                .onAppear {
                    trimGraph = CGFloat(dayProgress)
                }
            }
            .frame(height: viewHeight)
        
        
    }
}

#Preview {
    SinGraphView(daylightPercentage: 0.9, dayProgress: 0.9)
}

struct SinusModifier: AnimatableModifier {
    var progress: CGFloat
    var pathHeight: CGFloat
    var pathWidth: CGFloat
    var animatableData: CGFloat {
        get { progress }
        set { progress = newValue }
    }
    
    func body(content: Content) -> some View {
        content
            .position(x: progress * pathWidth,
                      y: sin( progress * 2 * .pi - CGFloat(-0.5 * .pi) ) * pathHeight + pathHeight
            )
    }
}

