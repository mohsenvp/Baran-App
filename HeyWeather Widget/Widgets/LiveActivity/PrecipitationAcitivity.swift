//
//  PrecipitationAcitivity.swift
//  HeyWeather
//
//  Created by Reza Ranjbaran on 21/06/2023.
//

import ActivityKit
import WidgetKit
import SwiftUI

struct LivePrecipitationAttributes: ActivityAttributes {
    public typealias PrecipitationState = ContentState
    
    public struct ContentState: Codable, Hashable {
        var currentIntensity : Double
        var relativeTime: Int
        var startTime: Double
        var endTime: Double
        var currentTime: Double
        var values: [Double]
    }
}

@available(iOS 16.1, *)
struct PrecipitationActivityLiveActivity: Widget {
   
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: LivePrecipitationAttributes.self) { context in
            VStack {
                HStack {
                    LeadingExpandedView(context: context)
                    Spacer()
                    TrailingExpandedView(context: context)
                }
                .padding(.bottom, 14)
                
                ExpandedChartView(context: context)
            }
            .padding()
            .accessibilityLabel(
                describeTimeAccessibility(relativeTime: context.state.relativeTime) +
                describeIntensityAccessibility(intensity: context.state.currentIntensity)
            )
            
        } dynamicIsland: { context in
            DynamicIsland {
                DynamicIslandExpandedRegion(.leading) {
                    LeadingExpandedView(context: context)
                        .accessibilityLabel(describeTimeAccessibility(relativeTime: context.state.relativeTime))
                }
                
                DynamicIslandExpandedRegion(.trailing) {
                    TrailingExpandedView(context: context)
                        .accessibilityLabel(describeIntensityAccessibility(intensity: context.state.currentIntensity))
                }
                
                DynamicIslandExpandedRegion(.bottom) {
                    ExpandedChartView(context: context)
                        .accessibility(hidden: true)
                }
                
            } compactLeading: {
                LeadingCompactView(context: context)
                    .accessibilityLabel(describeTimeAccessibility(relativeTime: context.state.relativeTime))
            } compactTrailing: {
                TrailingCompactView(context: context)
                    .accessibilityLabel(describeIntensityAccessibility(intensity: context.state.currentIntensity))
            } minimal: {
                MinimalView(context: context)
                    .accessibilityLabel(
                        describeTimeAccessibility(relativeTime: context.state.relativeTime)
                    )
            }
        }
    }
    
    
    func describeTimeAccessibility(relativeTime: Int) -> Text {
        if relativeTime == 0 {
            return Text("Steady rain continues", tableName: "Accessibility")
        }else if relativeTime > 0 {
            return Text("Rain starts in \(abs(relativeTime)) minutes", tableName: "Accessibility")
        }else {
            return Text("Rain ends in \(abs(relativeTime)) minutes", tableName: "Accessibility")
        }
    }
    
    func describeIntensityAccessibility(intensity: Double) -> Text {
        @AppStorage(Constants.precipitationUnitString, store: Constants.groupUserDefaults) var unit: String = Constants.defaultPrecipitationUnit.rawValue
        if unit == PrecipitationUnit.mm.rawValue {
            return Text("Rain intensity is \(intensity.localizedPrecipitation) millimeters per hour", tableName: "Accessibility")
        }else{
            return Text("Rain intensity is \(intensity.localizedPrecipitation) inches per hour", tableName: "Accessibility")
        }
    }
    
    private struct LeadingExpandedView: View {
        var context: ActivityViewContext<LivePrecipitationAttributes>
        var body: some View {
            HStack(){
                Image(Constants.Icons.umbrella).foregroundColor(Constants.accentColor)
                Strings.LiveActivity.getTitle(for: context.state.relativeTime)
                    .fonted(.subheadline, weight: .semibold)
                    .foregroundColor(Constants.accentColor)
                if context.state.relativeTime != 0 {
                    Text("\(abs(context.state.relativeTime))'")
                        .fonted(size: 17, weight: .semibold)
                        .foregroundColor(Constants.accentColor)
                }
            }
            .padding(.leading, 8)
            .padding(.top, -4)
        }
    }
    
    private struct TrailingExpandedView: View {
        @AppStorage(Constants.precipitationUnitString, store: Constants.groupUserDefaults) var unit: String = Constants.defaultPrecipitationUnit.rawValue
        var context: ActivityViewContext<LivePrecipitationAttributes>
        var body: some View {
            HStack(alignment: .bottom, spacing: 0){
                Text("\(context.state.currentIntensity.localizedPrecipitation, specifier: "%.1f")")
                    .fonted(size: 17, weight: .semibold)
                    .foregroundColor(Constants.accentColor)
                Text(unit)
                    .fonted(.subheadline, weight: .semibold)
                    .foregroundColor(Constants.accentColor)
            }
            .padding(.trailing, 6)
            .padding(.top, -5)
        }
    }
    
    private struct ExpandedChartView: View {
        var context: ActivityViewContext<LivePrecipitationAttributes>
        
        @State var startTimeWidth: CGFloat = 0
        
        var body: some View {
            
            
            VStack(alignment: .leading, spacing : 0){
                PrecipitationLiveActivityChart(data: context.state.values, context: context)
                    .frame(height: 70)
                    .padding(.trailing, 4)
                    .padding(.leading, 6)
                    .frame(height: 82)
                
                HStack(spacing: 0){
                    Text(startTimeWidth > 40 ? Date(timeIntervalSince1970: context.state.startTime).localizedHourAndMinutes(forceCurrentTimezone: true) : "")
                        .fonted(size: 11, weight: .bold)
                        .foregroundColor(.white)
                        .padding(.leading, startTimeWidth > 40 ? 6 : 0)
                        .frame(width: startTimeWidth, alignment: .leading)
                    
                    HStack {
                        Text("Now", tableName: "General")
                            .fonted(size: 11, weight: .bold)
                            .foregroundColor(.white)
                            .padding(.leading, 6)
                        
                        Spacer()
                        Text(Date(timeIntervalSince1970: context.state.endTime).localizedHourAndMinutes(forceCurrentTimezone: true))
                            .fonted(size: 11, weight: .bold)
                            .foregroundColor(.white)
                            .padding(.trailing, 6)
                    }
                    .frame(height: 20)
                    .background(Capsule().fill(Constants.accentColor.opacity(0.4)))
                    
                }
                .frame(height: 20)
                .background(
                    GeometryReader { proxy in
                        Capsule()
                            .fill(Constants.accentColor.opacity(0.4))
                            .onAppear {
                                let diff = Int(context.state.currentTime - context.state.startTime)
                                let progress = CGFloat(diff / 60 / 2 * 100 / 30)
                                startTimeWidth = proxy.size.width * (progress / 100) - 6
                            }
                    }
                )
                .padding([.top, .horizontal], 3)
                .padding([.bottom], 8)
                
            }
            .padding(.top , -16)
        }
        
    }
    
    private struct LeadingCompactView: View {
        var context: ActivityViewContext<LivePrecipitationAttributes>
        var body: some View {
            if context.state.relativeTime > 0 {
                startView
            }else if context.state.relativeTime < 0 {
                endView
            }else if context.state.relativeTime == 0 {
                rainingView
            }
        }
        var startView: some View {
            HStack(spacing: 2){
                Image(Constants.Icons.umbrella).foregroundColor(Constants.accentColor)
                Text("\(abs(context.state.relativeTime))'").fonted(.title, weight: .heavy).foregroundColor(Constants.accentColor)
            }.padding(.leading, 4)
        }
        var endView: some View {
            HStack(spacing: 2){
                Text("\(abs(context.state.relativeTime))'").fonted(.title, weight: .heavy).foregroundColor(Constants.accentColor)
                Image(Constants.Icons.umbrellaDeactive).foregroundColor(Constants.accentColor)
            }.padding(.leading, 4)
        }
        var rainingView: some View {
            Image(Constants.Icons.umbrella).foregroundColor(Constants.accentColor)
        }
    }
    
    private struct TrailingCompactView: View {
        var context: ActivityViewContext<LivePrecipitationAttributes>
        var body: some View {
            
            HStack(alignment: .bottom, spacing: 0){
                Text("\(context.state.currentIntensity.localizedPrecipitation, specifier: "%.1f")")
                    .fonted(.headline, weight: .heavy)
                    .foregroundColor(Constants.accentColor.opacity(0.8))
            }
        }
    }
    
    private struct MinimalView: View {
        var context: ActivityViewContext<LivePrecipitationAttributes>
        var timeProgress: CGFloat {
            let diff = Int(context.state.currentTime - context.state.startTime)
            return CGFloat(diff / 60 * 100 / 60)
        }
        var body: some View {
            ZStack {
                Circle()
                    .stroke(
                        Constants.accentColor.opacity(0.4),
                        lineWidth: 2
                    )
                Circle()
                    .trim(from: 0, to: timeProgress / 100)
                    .stroke(
                        Constants.accentColor,
                        style: StrokeStyle(
                            lineWidth: 2,
                            lineCap: .round
                        )
                    )
                    .rotationEffect(.degrees(-90))
                
                Image(Constants.Icons.umbrella)
                    .resizable()
                    .foregroundColor(Constants.accentColor)
                    .frame(width: 14, height: 14)
            }
        }
    }
}
