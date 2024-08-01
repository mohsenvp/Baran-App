//
//  AstronomyDetailsView.swift
//  HeyWeather
//
//  Created by Mohammad Yeganeh on 8/27/23.
//

import SwiftUI

struct AstronomyDetailsView: View {
    let type: AstroType
    var moon: MoonDataModel = .init()
    var sun: SunDataModel = .init()
    var date: Date? = nil
    @Environment(\.dynamicTypeSize) var typeSize
    @Environment(\.colorScheme) var colorScheme
    var body: some View {
        HStack(spacing : 0) {
            
            if date != nil {
                VStack(spacing: 4){
                    Text(date?.shortWeekday ?? "")
                        .fonted(.body, weight: .semibold)
                
                    Text(date?.shortLocalizedString ?? "")
                        .fonted(.caption2, weight: .light)
                }
                .foregroundColor(Constants.sunTextColor)
                .frame(width: 80)
            }else if (type == .moon) {
                MoonPhaseView(moon: moon)
                    .frame(width: 60, height: 60)
                    .padding([.vertical, .leading])
                    .padding(.trailing, 10)
                    .accessibilityHidden(true)
                    .foregroundColor(Color.white)
            }else {
                Image(Constants.Icons.radialSun)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 60, height: 60)
                    .padding([.vertical, .leading])
                    .padding([ .trailing],10)
                    .accessibilityHidden(true)
            }
            
            VStack(alignment: .leading, spacing: 10) {
                AdaptiveStack(horizontalAlignment: .leading,horizontalSpacing: 0, verticalSpacing: 0) { sizeClass, typeSize in
                    sizeClass == .compact && typeSize > .large
                } content: {
                    Group {
                        if type == .moon {
                            Text("Moon Phase", tableName: "Moon") + Text(":")
                        }else{
                            Text("Daylight", tableName: "Climate") + Text(":")
                        }
                    }
                    .fonted(.footnote, weight: .regular)
                    .opacity(Constants.primaryOpacity)
                    .padding([.trailing], 2)
                    if type == .moon {
                        Text(moon.phase)
                            .fonted(.headline, weight: .bold)
                    }else {
                        Text("\(sun.getDayDurationHours()) hours and \(sun.getDayDurationMinutes()) minutes", tableName: "General")
                            .fonted(.headline, weight: .bold)
                            .padding(.trailing, 4)
                            .lineLimit(1)
                            .minimumScaleFactor(0.6)
                    }
                }
                
                
                HStack {
                    HStack(spacing:0) {
                        Image(type == .moon ? Constants.Icons.moonrise : Constants.Icons.sunrise)
                            .resizable()
                            .renderingMode(.template)
                            .frame(width: 24, height: 24)
                        Text(type == .moon ? moon.rise.toUserTimeFormatWithMinuets() : (sun.sunrise ?? Date()).toUserTimeFormatWithMinuets())
                            .fonted(.body, weight: .semibold)
                            .frame(width: 74)
                            .lineLimit(1)
                            .minimumScaleFactor(0.8)
                    }
                    
                    DottedLine()
                        .stroke(style: StrokeStyle(lineWidth: 1, dash: [5]))
                        .frame(height: 1)
                        .opacity(Constants.primaryOpacity)
                        .layoutPriority(-1)
                    
                    HStack(spacing:0) {
                        Text(type == .moon ? moon.set.toUserTimeFormatWithMinuets() : (sun.sunset ?? Date()).toUserTimeFormatWithMinuets())
                            .fonted(.body, weight: .semibold)
                            .frame(width: 74)
                            .lineLimit(1)
                            .minimumScaleFactor(0.8)
                        
                        Image(type == .moon ? Constants.Icons.moonset : Constants.Icons.sunset)
                            .resizable()
                            .renderingMode(.template)
                            .frame(width: 24, height: 24)
                    }
                }
                .accessibilityElement(children: .combine)
                .accessibilityLabel(type == .moon ? Text("moon state is \(moon.phase), Illumination \(moon.illumination.localizedNumber(withFractionalDigits: 0))%", tableName: "Accessibility") : Text("the sun rises at \((sun.sunrise ?? Date()).toUserTimeFormatWithMinuets()), the sun sets at \((sun.sunset ?? Date()).toUserTimeFormatWithMinuets())", tableName: "Accessibility"))
                .padding(.trailing)
                .dynamicTypeSize(...DynamicTypeSize.large)
                
            }
            .foregroundColor(date != nil ? Constants.sunTextColor : .white)
            .padding(.vertical, 12)
            .padding([.trailing], 4)
        }
        .padding(.vertical, typeSize > .large ? 12 : 0)
        .background(type == .moon ? Constants.nightBg.opacity(1.0) : (colorScheme == .dark ? Constants.sunBgDark.opacity(0.5) : Constants.sunBg.opacity(date != nil ? 0.3 : 1.0)))
        .cornerRadius(Constants.weatherTabRadius)
        
    }
}
