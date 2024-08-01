//
//  Guage.swift
//  HeyWeather
//
//  Created by Kamyar on 10/20/21.
//
//
//import SwiftUI
//
//fileprivate struct GaugeElement: View {
//    var section: GaugeViewSection
//    var startAngle: Double
//    var trim: ClosedRange<CGFloat>
//    var lineCap: CGLineCap = .butt
//
//    var body: some View {
//        GeometryReader { geometry in
//            let lineWidth = geometry.size.width / 10
//
//            section.color
//                .mask(Circle()
//                        .trim(from: trim.lowerBound, to: trim.upperBound)
//                        .stroke(style: StrokeStyle(lineWidth: lineWidth, lineCap: lineCap))
//                        .rotationEffect(Angle(degrees: startAngle))
//                        .padding(lineWidth/2)
//                )
//        }
//    }
//}
//
//fileprivate struct NeedleView: View {
//    var angle: Double
//    var value: Double = 0.0
//    @State var backColor: Color
//    @State var color: Color
//
//    var body: some View {
//        // 90 to start in south orientation, then add offset to keep gauge symetric
//        let startAngle = 90 + (360.0 - angle) / 2.0
//        let needleAngle = startAngle + value * angle
//
//        GeometryReader { geometry in
//            ZStack
//            {
//                let rectWidth = geometry.size.width / 2.52
//                let rectHeight = geometry.size.width / 20
//
//                HStack {
//                    Rectangle()
//                        .fill(Color.clear)
//                        .frame(width: rectWidth, height: rectHeight)
//                    ZStack {
//                        Circle()
//                            .fill(backColor)
//                            .frame(width: rectHeight * 2.2, height: rectHeight * 2.2)
//                        Circle()
//                            .fill(color)
//                            .shadow(radius: 2)
//                            .frame(width: rectHeight * 1.5, height: rectHeight * 1.5)
//                    }
//
//                }.offset(x: rectWidth / 2)
//            }
//            .position(x: geometry.size.width / 2, y: geometry.size.height / 2)
//        }
//        .rotationEffect(.degrees(needleAngle))
//    }
//}
//
//
//public struct Gauge: View {
//    var angle: Double
//    var sections: [GaugeViewSection]
//    var value: Double
//    var valueDescription: String?
//    var gaugeDescription: String?
//    var backColor: Color
//    var colorStage: Int
//    var fromApp = false
//
//    public var body: some View {
//        // 90 to start in south orientation, then add offset to keep gauge symetric
//        let startAngle = 90 + (360.0-angle) / 2.0
//
//        ZStack {
//            ForEach(sections) { section in
//                // Find index of current section to sum up already covered areas in percent
//                if let index = sections.firstIndex(where: {$0.id == section.id}) {
//                    let alreadyCovered = sections[0..<index].reduce(0) { $0 + $1.size}
//
//                    // 0.001 is a small offset to fill a gap
//                    let sectionSize = section.size * (angle / 360.0) // + 0.001
//                    let sectionStartAngle = startAngle + alreadyCovered * angle
//
//                    GaugeElement(section: section, startAngle: sectionStartAngle, trim:  0...CGFloat(sectionSize))
//
//                    // Add round caps at start and end
//                    if index == 0 || index == sections.count - 1{
//                        let capSize: CGFloat = 0.001
//                        let startAngle: Double = index == 0 ? sectionStartAngle : startAngle + angle
//
//                        GaugeElement(section: section,
//                                     startAngle: startAngle,
//                                     trim: 0...capSize,
//                                     lineCap: .round)
//                    }
//                }
//            }
//
//            NeedleView(angle: angle, value: value,backColor: backColor, color: Color(Constants.aqiColors[Int(colorStage)]))
//
//            VStack{
//                if let valueDescription = valueDescription {
//                    Text(valueDescription)
//                        .fonted(.title, weight: .bold)
//                        .foregroundColor(fromApp ? Color(Constants.primaryRowBgReversed) : .white)
//                }
//                if let gaugeDescription = gaugeDescription {
//                    Text(gaugeDescription)
//                        .fonted(.caption2, weight: .regular)
//                        .foregroundColor(.white)
//                        .accessibilitySortPriority(1)
//                        .lineLimit(2)
//                        .frame(maxWidth: 80)
//                        .multilineTextAlignment(.center)
//                }
//            }
//        }
//    }
//}
//
//
//public struct GaugeViewSection: Identifiable {
//    public var id = UUID()
//    var color: Color
//    var size: Double
//
//    public init(color: Color, size: Double) {
//        self.color = color
//        self.size = size
//    }
//}
