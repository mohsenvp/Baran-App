//
//  WatchChartView.swift
//  HeyWeather WatchOS
//
//  Created by Mohammad Yeganeh on 9/9/23.
//

import SwiftUI



struct WatchChartView: View {
    
    var selectedMode: WatchDataMode
    var chartData: [SimpleChartData] = []
    var isHourly: Bool
    var textColor: Color
    var maxValue: Double {
        switch selectedMode {
        case .uvIndex:
            return 11
        case .pressure:
            return 1080.convertedPressure()
        default:
            return 100
        }
    }
    var minValue: Double {
        switch selectedMode {
        case .pressure:
            return 960.convertedPressure()
        default:
            return 0
        }
    }
    var chartGradient: LinearGradient {
        switch selectedMode {
        case .clouds:
            return LinearGradient(colors: [.init(hex: "2CEFEF"), .init(hex: "2AC0B7")], startPoint: .top, endPoint: .bottom)
        case .pressure:
            return LinearGradient(colors: [.init(hex: "505257"), .init(hex: "878A90")], startPoint: .top, endPoint: .bottom)
        case .humidity:
            return LinearGradient(colors: [.init(hex: "63CE7A"), .init(hex: "66B6F5"), .init(hex: "5858BB")], startPoint: .top, endPoint: .bottom)
        case .uvIndex:
            return LinearGradient(colors: [.init(hex: "D129C0"), .init(hex: "F47E10"), .init(hex: "E2E521"), .init(hex: "14FF00")], startPoint: .top, endPoint: .bottom)
        default:
            return LinearGradient(colors: [.init(hex: "219DC5"), .init(hex: "2189AA")], startPoint: .top, endPoint: .bottom)
        }
    }

    
    var body: some View {
       
        HStack{
            VStack {
                Text("\(Int(maxValue))")
                    .fonted(size: 10)
                    .foregroundStyle(textColor)
                    .frame(width: 20)
                    .lineLimit(1)
                    .minimumScaleFactor(0.5)
                Spacer()
                Text("\(Int(minValue))").fonted(size: 10).foregroundStyle(textColor)
                    .padding(.bottom, 12)
                    .frame(width: 20)
                    .lineLimit(1)
                    .minimumScaleFactor(0.5)

            }
            
            ForEach(0..<chartData.count, id: \.self) { i in
                VStack {
                    Bar(
                        value: chartData[i].value,
                        min: minValue,
                        max: maxValue,
                        gradient: chartGradient,
                        textColor: textColor
                    )
                    .frame(width: 8)
                    Text(isHourly ? chartData[i].date.atHour : chartData[i].date.veryShortWeekday)
                        .fonted(size: 10)
                        .foregroundStyle(textColor)
                }
                Spacer(minLength: 0)
            }
        }
    }
}

private struct Bar: View {
    let value: Double
    let min: Double
    let max: Double
    let gradient: LinearGradient
    let textColor: Color
    
    var body: some View {
        ZStack{
            Capsule()
                .fill(textColor.opacity(0.2))
            
            Capsule()
                .fill(gradient)
                .clipShape(BarClipShape(value: value, min: min, max: max))
                .animation(.none, value: value)
        }
    }
    
    private struct BarClipShape : Shape {
        let value: Double
        let min: Double
        let max: Double
        
        func path(in rect: CGRect) -> Path {
            var path = Path()
            let height = value.interpolated(from: min...max, to: 0...rect.height)
            let heightDiff = rect.height - height
            
            path.move(to: CGPoint(x: rect.minX, y: rect.height))
            path.addLine(to: CGPoint(x: rect.minX, y: heightDiff + 4))
            path.addCurve(to: CGPoint(x: rect.midX, y: heightDiff), control1:  CGPoint(x: rect.minX, y:  heightDiff + 2), control2:  CGPoint(x: rect.midX - 2, y: heightDiff))
            path.addCurve(to: CGPoint(x: rect.maxX, y: heightDiff + 4), control1:  CGPoint(x: rect.midX + 2, y: heightDiff), control2:  CGPoint(x: rect.maxX, y: heightDiff + 2))
            path.addLine(to: CGPoint(x: rect.maxX, y: rect.height))
            path.addLine(to: CGPoint(x: rect.minX, y: rect.height))
            path.closeSubpath()
            return path
            
        }
    }
}
