//
//  SmoothChart.swift
//  HeyWeather
//
//  Created by Kamyar on 10/20/21.
//

import Foundation

import SwiftUI



struct ChartSettings {
    var smoothLine = true
    var showXValues = true
    var xValuesColor = Color.white
    var showYValues = true
    var yValuesColor = Color.white
    var lineWidth : CGFloat = 4
    var lineColor = Color.red
    var chartBackground = Color.yellow
    var lineBackground = LinearGradient(gradient: Gradient(colors: [Color(#colorLiteral(red: 0.3647058904, green: 0.06666667014, blue: 0.9686274529, alpha: 0.2729559075)), Color(#colorLiteral(red: 0.7672902942, green: 0.1229064241, blue: 0.225025624, alpha: 1))]), startPoint: .top, endPoint: .bottom)
}


struct SmoothChart: View {
    var chartData : [ChartData]
    var chartSettings = ChartSettings()
    
    var body: some View {
        HStack {
            
            GeometryReader { geometry in
                
                ZStack {
                    MainChartView(geometry: geometry, chartData: chartData, chartSettings : chartSettings)
                        .frame(width : geometry.size.width, height : geometry.size.height)
                        .accessibilityHidden(true)
                }
                Spacer()
                
                VStack {
                    Spacer()
                    if (chartSettings.showXValues) {
                        HStack {
                            ForEach(chartData, id: \.self.id) { data in
                                Spacer()
                                Text(data.key)
                                    .fonted(size: 8, weight: .regular)
                                    .foregroundColor(chartSettings.yValuesColor)
                                    .padding(.horizontal, 2)
                                    .padding(.vertical, 2)
                                    .background(Color.gray.opacity(0.6))
                                    .cornerRadius(8)
                                    .padding(.bottom, 2)
                                    .minimumScaleFactor(0.01)
                                    .lineLimit(1)
                                    .accessibilityLabel("\(String(data.value))° \(data.accessibleKey != nil ? "on" : "at") \(data.accessibleKey != nil ? data.accessibleKey! : data.key)")
                                
                                Spacer()
                            }
                        }
                        .frame(width: geometry.size.width, height: 50, alignment: .bottom)
                    }
                }
                
            }
        }.background(chartSettings.chartBackground)
    }
    
}


struct MainChartView: View {
    let geometry : GeometryProxy
    var chartData : [ChartData]
    var chartSettings = ChartSettings()
    
    var body: some View {
        let viewHolderWidth = geometry.size.width
        let viewHolderHeight = geometry.size.height
        
        ZStack {
            
            let roughPoints = convertDataToPoints(roughData: chartData)
            let softPoints = normalizePoint(width: viewHolderWidth, height: viewHolderHeight, points : roughPoints)
            
            let linePath = Path().drawPath(points: softPoints, smooth: chartSettings.smoothLine)
            
            Group {
                linePath
                    .fill(chartSettings.lineBackground)
                    .clipped()
                
                linePath
                    .stroke(chartSettings.lineColor, lineWidth: chartSettings.lineWidth)
                    .clipped()
                
            }.rotationEffect(.degrees(180), anchor: .center)
            .rotation3DEffect(.degrees(180), axis: (x: 0, y: 1, z: 0))
            
            ForEach((0...chartData.count - 1), id: \.self) {
                let data = chartData[$0]
                
                if (chartSettings.showYValues) {
                    
                    Text("\(Int(data.value))")
                        .fonted(.caption, weight: .regular)
                        .foregroundColor(chartSettings.xValuesColor)
                        .position(x: softPoints[$0 + 1].x, y: (-1 * (softPoints[$0 + 1].y)) + viewHolderHeight - 16)
                    
                }
                
                Circle().fill(chartSettings.lineColor)
                    .frame(width : 4, height : 4)
                    .padding(2).background(Color.white)
                    .clipShape(Circle())
                    .position(x: softPoints[$0 + 1].x, y: (-1 * (softPoints[$0 + 1].y)) + viewHolderHeight)
            }
            
        }.frame(width: viewHolderWidth, height: viewHolderHeight)
        .background(chartSettings.chartBackground)
    }
    
    
    func convertDataToPoints(roughData : [ChartData]) -> [CGPoint] {
        var points = [CGPoint]()
        points.removeAll()
        for i in 0..<roughData.count {
            points.append(CGPoint(x: i ,y: Int(roughData[i].value)))
        }
        return points
    }
    
    
    func normalizePoint(width : CGFloat, height : CGFloat, points : [CGPoint], xPadding : CGFloat = -1) -> [CGPoint] {
        
        var padding = xPadding
        if (xPadding == -1) {
            padding = width / CGFloat(points.count)
        }
        
        let minXPoint = points.min(by: {$0.x < $1.x})!.x
        let maxXPoint = (points.max(by: {$0.x < $1.x})!.x)
        
        var maxYPoint = points.max(by: {$0.y < $1.y})!.y
        var minYPoint = points.min(by: {$0.y < $1.y})!.y
        
        maxYPoint += minYPoint * 0.15
        minYPoint -= minYPoint * 0.15
        
        let stepSizeX = (width - padding) / (maxXPoint - minXPoint)
        let stepSizeY = height / (maxYPoint - minYPoint)
        
        var normalizedPoints = points
        
        normalizedPoints = normalizedPoints.map({
            (point: CGPoint) -> CGPoint in
            var xVal = ( point.x > 0 ? point.x - minXPoint : point.x + minXPoint ) * stepSizeX
            xVal = xVal + (padding / 2 )
            let yVal = ( point.y > 0 ? point.y - minYPoint : point.y + minYPoint ) * stepSizeY
            return CGPoint(x: xVal, y: yVal)
        })
        
        // Add extar points for control points
        normalizedPoints.insert(normalizedPoints[0], at: 0)
        normalizedPoints.append(normalizedPoints[normalizedPoints.count - 1])
        
        return normalizedPoints
    }
    
}
