//
//  PrecipitationLiveActivityChart.swift
//  HeyWeather
//
//  Created by Mohammad Yeganeh on 6/26/23.
//

import SwiftUI
import WidgetKit

@available(iOS 16.1, *)
struct PrecipitationLiveActivityChart: View {
    var data: [Double]
    var context: ActivityViewContext<LivePrecipitationAttributes>
    
    var timeProgress: Int {
        let diff = Int(context.state.currentTime - context.state.startTime)
        return diff / 60 / 2
    }
    var body: some View {
        VStack(spacing: 0){
            ZStack{
                Grids()
                HStack {
                    GeometryReader { chartGeo in
                        let barWidth = chartGeo.size.width / CGFloat(Double(data.count) * 1.8)
                        let barGap = chartGeo.size.width / CGFloat(Double(data.count) * 2.2)
                        HStack(alignment: .bottom, spacing: barGap){
                            ForEach(0..<data.count, id: \.self) { index in
                                Bar(
                                    percent: PrecipitationChartData.precipitationToPercent(precip: data[index]),
                                    height: chartGeo.size.height,
                                    isPast: index < timeProgress
                                )
                                .frame(width: barWidth)
                            }
                        }
                    }
                }
            }
        }
    }
    
    struct Bar: View {
           let percent: Int
           let height: CGFloat
           let isPast: Bool
           var body: some View {
               ZStack(alignment: .bottom){
                   Capsule().fill(Color.clear)
                   Capsule()
                       .fill(isPast ? LinearGradient(colors: [Color.init(hex: "828282").opacity(0.5), Color.init(hex: "828282").opacity(0.5)], startPoint: .top, endPoint: .bottom) : LinearGradient(colors: [Color.init(hex: "3D74E0").opacity(0.9), Color.init(hex: "1EAECE").opacity(0.9)], startPoint: .top, endPoint: .bottom))
                       .frame(height:  height * CGFloat(percent) / 100)
               }
           }
           
       }
    private struct Grids: View {
        var body: some View {
            VStack(spacing: 0){
                Spacer()

                Line()
                .stroke(style: StrokeStyle(lineWidth: 1, dash: [3]))
                .frame(height: 1)
                Spacer()
                Line()
                    .stroke(style: StrokeStyle(lineWidth: 1, dash: [3]))
                    .frame(height: 1)
                Spacer()
                Line()
                    .stroke(style: StrokeStyle(lineWidth: 1, dash: [3]))
                    .frame(height: 1)
                Spacer()
                Line()
                    .stroke(style: StrokeStyle(lineWidth: 1, dash: [3]))
                    .frame(height: 1)
                
            }
            .opacity(Constants.tertiaryOpacity)
        }
        
        private struct Line: Shape {
            func path(in rect: CGRect) -> Path {
                var path = Path()
                path.move(to: CGPoint(x: rect.minX, y: rect.minY))
                path.addLine(to: CGPoint(x: rect.width, y: rect.minY))
                return path
            }
        }
    }
    
    
}

