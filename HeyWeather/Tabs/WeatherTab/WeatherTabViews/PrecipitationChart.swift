//
//  PrecipitationNewChart.swift
//  HeyWeather
//
//  Created by mohamd yeganeh on 5/14/23.
//

import SwiftUI



struct PrecipitationChart: View {
    let data: [PrecipitationChartData]
    @State var touchPoint: CGPoint = .zero
    @State var touch: Bool = false
    @State var hoveredChartItem: PrecipitationChartData = .init()
    @AppStorage(Constants.precipitationUnitString, store: Constants.groupUserDefaults) var unit: PrecipitationUnit = Constants.defaultPrecipitationUnit
    let yAxisWidth: CGFloat = 24.0
    let chartTrailingPadding = 12.0
    let items = [String(localized: "Now", table: "General"), "10'", "20'", "30'", "40'", "50'", "60'"]
    
    var body: some View {
        VStack(spacing: 0){
            ZStack(alignment: .topTrailing){
                Grids(unit: unit).padding(.trailing, chartTrailingPadding)
                Text(unit.rawValue)
                    .fonted(.caption2, weight: .thin)
                    .padding(.top, -16)
                    .padding(.trailing, 10)
                HStack {
                    Spacer(minLength: yAxisWidth)
                    GeometryReader { chartGeo in
                        let barWidth = chartGeo.size.width / CGFloat(Double(data.count) * 1.8)
                        let barGap = chartGeo.size.width / CGFloat(Double(data.count) * 2.2)
                        HStack(alignment: .bottom, spacing: barGap){
                            ForEach(0..<data.count, id: \.self) { index in
                                GeometryReader { barGeo in
                                    let x = CGFloat(index) * barWidth + CGFloat(index) * barGap
                                    let barFrame = CGRect(x: x, y: barGeo.frame(in: .local).origin.y, width: barGeo.size.width, height: barGeo.size.height)
                                    
                                    Bar(
                                        percent: data[index].percentValue,
                                        touched: barFrame.contains(touchPoint) && touch
                                    )
                                    .frame(width: barWidth, height: chartGeo.size.height)
                                    .opacity((barFrame.contains(touchPoint) && touch) ? 1.0 : 0.7)
                                    .onChange(of: touchPoint) { _ in
                                        DispatchQueue.main.async {
                                            if barFrame.contains(touchPoint) && touch {
                                                hoveredChartItem = data[index]
                                            }
                                        }
                                    }
                                    
                                }
                            }
                        }
                        .onChange(of: hoveredChartItem, perform: { _ in
                            UIImpactFeedbackGenerator(style: .light).impactOccurred()
                        })
                        .gesture(DragGesture(minimumDistance: 0).onChanged({ value in
                            DispatchQueue.main.async {
                                touch = true
                                touchPoint = value.location
                            }
                        }).onEnded({ _ in
                            touch = false
                        }))
                    }
                    .border(width: 1, edges: [.leading, .bottom], color: .init(.label).opacity(Constants.smallOpacity))
                    .padding(.trailing, chartTrailingPadding)
                    
                }
                
                
                
                
                ToolTip(item: hoveredChartItem, unit: unit)
                    .opacity(touch ? 1 : 0)
                    .position(x: touchPoint.x + yAxisWidth, y: touchPoint.y - 60)
                
            }
            
            
            HStack {
                ForEach(0..<items.count, id: \.self) { index in
                    Text(items[index])
                        .lineLimit(1)
                        .minimumScaleFactor(0.8)
                        .fonted(.footnote, weight: .regular)
                    if index != items.count - 1 {
                        Spacer()
                    }
                }
            }
            .padding(.leading, 10)
            .padding(.top, 4)
        }
        .environment(\.layoutDirection, .leftToRight)
    }
    
    
    
    struct Bar: View {
        let percent: Int
        let touched: Bool
        
        var body: some View {
            
            Rectangle()
                .fill(touched ? Constants.accentGradient : Constants.precipitationChartBarGradient)
                .clipShape(BarClipShape(percent: percent))
            
        }
        
        private struct BarClipShape : Shape {
            let percent: Int
            
            func path(in rect: CGRect) -> Path {
                var path = Path()
                let height = rect.height  * CGFloat(percent) / 100
                let heightDiff = rect.height  - height
                
                path.move(to: CGPoint(x: rect.minX, y: rect.height))
                path.addLine(to: CGPoint(x: rect.minX, y: heightDiff + 2))
                path.addCurve(to: CGPoint(x: rect.midX, y: heightDiff), control1:  CGPoint(x: rect.minX, y:  heightDiff + 1), control2:  CGPoint(x: rect.midX - 1, y: heightDiff))
                path.addCurve(to: CGPoint(x: rect.maxX, y: heightDiff + 2), control1:  CGPoint(x: rect.midX + 1, y: heightDiff), control2:  CGPoint(x: rect.maxX, y: heightDiff + 1))
                path.addLine(to: CGPoint(x: rect.maxX, y: rect.height))
                path.addLine(to: CGPoint(x: rect.minX, y: rect.height))
                path.closeSubpath()
                return path
                
            }
        }
    }
    
    private struct ToolTip: View{
        var item: PrecipitationChartData
        var unit: PrecipitationUnit
        
        var body: some View {
            ZStack {
                Blur().cornerRadius(4)
                    .slightShadow()
                VStack(alignment: .leading){
                    Text(item.date.toUserTimeFormatWithMinuets(forceCurrentTimezone: true))
                        .fonted(.caption, weight: .medium)
                        .opacity(Constants.primaryOpacity)
                    Text(String(format: "%.3f", item.rate)).foregroundColor(.accentColor)
                        .fonted(.footnote, weight: .semibold)
                    Text(item.intensity.rawValue.capitalized)
                        .fonted(.footnote, weight: .ultraLight)
                }.padding(4)
            }.frame(width: 64, height: 32)
        }
    }
    
    
    
    private struct Grids: View {
        var unit: PrecipitationUnit
        let mmhValues: [String] = [">10", "5.0", "2.0", "1.0"]
        let inphValues: [String] = [">0.4", "0.2", "0.08", "0.04"]
        
        var body: some View {
            VStack(spacing: 0){
                ForEach(0..<4, id: \.self) { index in
                    GridLine(label: unit == .mm ? mmhValues[index] : inphValues[index])
                    Spacer()
                }
            }
            .opacity(Constants.pointThreeOpacity)
        }
        
        
        private struct GridLine: View {
            var label: String
            
            var body: some View {
                HStack(spacing: 12){
                    Text(label)
                        .fonted(.caption2, weight: .regular)
                        .padding(.top, -1)
                    Line()
                        .stroke(style: StrokeStyle(lineWidth: 1, dash: [5]))
                        .frame(height: 1)
                }
                .padding(.top, -6)
            }
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


struct PrecipitationNewChart_Previews: PreviewProvider {
    static var previews: some View {
        PrecipitationChart(data: [])
    }
}
