//
//  AstronomyDetailsView.swift
//  HeyWeather
//
//  Created by Kamyar on 12/13/21.
//

import Foundation
import SwiftUI

struct MoonDetailsView: View {
    @StateObject var viewModel: MoonDetailsViewModel
    @Binding var isPresented: Bool
    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(alignment: .trailing) {
                Button {
                    isPresented.toggle()
                } label: {
                    Image(systemName: Constants.SystemIcons.xmark)
                }.padding(20)

                ScrollView(.horizontal, showsIndicators: false) {
                    HStack {
                        ForEach(viewModel.moons) { moon in
                            let index = viewModel.moons.firstIndex(of: moon)!
                            DailyMoonCell(moon: moon, index: index, selectedMoon: $viewModel.selectedMoon)
                        }
                    }.padding(.horizontal)
                }.padding(.bottom)
                VStack {
                    
                    MoonPhaseView(moon:viewModel.selectedMoon)
                        .frame(width: 150, height: 150)
                        .padding(.vertical)
                        .accessibilityHidden(true)
                    Text(viewModel.selectedMoon.phase)
                        .fonted(.largeTitle, weight: .regular)
                        .padding(.bottom, 7.5)
               
                    Text("Illumination : \(viewModel.selectedMoon.illumination.localizedNumber(withFractionalDigits: 0))%", tableName: "Moon")
                    .fonted(.body, weight: .regular)
                    .opacity(Constants.primaryOpacity)
                    
                    RiseAndSetView(moon: viewModel.selectedMoon)
                    DetailsView(moon: viewModel.selectedMoon, date: viewModel.selectedDate)
                }.padding(.horizontal)
            }.padding(.vertical)
        }
        .dynamicTypeSize(...Constants.maxDynamicType)
        .environment(\.layoutDirection, LocalizeHelper.shared.currentLanguage.isRTL ? .rightToLeft : .leftToRight)
        .background(Constants.nightBg.ignoresSafeArea())
        .foregroundColor(.white)
        .navigationBarTitle(Text("Moon", tableName: "Moon"))
        .navigationBarTitleDisplayMode(.inline)
    }
    
    struct DetailsView: View {
        let moon: MoonDataModel
        let date: Date
        var body: some View {
            let days = Constants.space + Constants.days.localized
            let timeInterval: Double = Double(date.timeIntervalSince1970)
            VStack {
                DetailsRow(title: Text("Moon Distance", tableName: "Moon"), value: Int(moon.distance).localizedVisibility)
                DetailsRow(title: Text("Moon Age", tableName: "Moon"), value: moon.age.localizedNumber + days)
                DetailsRow(title: Text("Parallactic Angle", tableName: "Moon"), value: moon.parallacticAngle.localizedNumber() + Constants.degree)
                DetailsRow(title: Text("From Last New Moon", tableName: "Moon"), value: "\(Int(moon.lastNewMoon))" + days)
                DetailsRow(title: Text("To next Full Moon", tableName: "Moon"), value: "\(Int(moon.nextFullMoon))" + days)
            }
            .padding(.horizontal)
            .padding(.vertical)
            .background(Color.white.opacity(0.05))
            .cornerRadius(Constants.weatherTabRadius)
        }
        
        struct DetailsRow: View {
            let title: Text
            let value: String
            var body: some View {
                HStack {
                    title
                        .opacity(Constants.primaryOpacity)
                        .fonted(.body, weight: .regular)
                    Spacer()
                    Text(value)
                        .fonted(.body, weight: .regular)
                }.padding(.vertical, 5)
                    .accessibilityElement(children: .combine)
            }
        }
    }
    
    struct RiseAndSetView: View {
        let moon: MoonDataModel
        var body: some View {
            HStack {
                Image(Constants.Icons.moonrise).accessibilityHidden(true)
                Text(moon.rise == nil ? "" : moon.rise.toUserTimeFormatWithMinuets())
                    .fonted(.body, weight: .regular)
                    .accessibilityLabel(Text("the moon rises at", tableName: "Accessibility"))
                    .accessibilityValue(moon.rise == nil ? "=" : moon.rise.toUserTimeFormatWithMinuets())
                if moon.rise == nil && moon.set == nil{
                    Spacer()
                    Group {
                        if moon.alwaysUp {
                            Text("Moon Always Up", tableName: "Moon")
                                .fonted(.body, weight: .regular)
                                .accessibilityLabel(Text("Moon Always Up", tableName: "Moon"))

                        }else {
                            Text("Moon Always Down", tableName: "Moon")
                                .fonted(.body, weight: .regular)
                                .accessibilityLabel(Text("Moon Always Down", tableName: "Moon"))
                        }
                    }
                    Spacer()
                }else{
                    GeometryReader { proxy in
                        Path { path in
                            let y = proxy.size.height/2
                            path.move(to: .init(x: 0, y: y))
                            path.addLine(to: .init(x: proxy.size.width, y: y))
                        }
                        .stroke(style: .init(lineWidth: 2, lineJoin: .round, dash: [5]))
                        .fill(.white.opacity(Constants.secondaryOpacity))
                    }.padding(.horizontal, 5)
                    
                }

                Text(moon.set == nil ? "" : moon.set.toUserTimeFormatWithMinuets())
                    .fonted(.body, weight: .regular)
                    .accessibilityLabel(Text("the moon sets at", tableName: "Accessibility"))
                    .accessibilityValue(moon.set == nil ? "=" : moon.set.toUserTimeFormatWithMinuets())
                Image(Constants.Icons.moonset).accessibilityHidden(true)

            }
            .padding().padding(.vertical)
        }
    }
    
    struct DailyMoonCell: View {
        let moon: MoonDataModel
        let index: Int
        @Binding var selectedMoon: MoonDataModel
        var body: some View {
            Button { selectedMoon = moon } label: {
                VStack {
                    Group {
                        index == 0 ? Text("Today", tableName: "General") : Text(getDay())
                    }
                    .foregroundColor(moon == selectedMoon ? .black : .white)
                    .fonted(.body, weight: .medium)
                    Text(getDateDay())
                        .fonted(.subheadline, weight: .thin)
                        .foregroundColor(moon == selectedMoon ? .black : .white)
                        .opacity(0.7)
                    
                    MoonPhaseView(moon:moon)
                        .foregroundColor(moon == selectedMoon ? Constants.accentColor : .white)
                        .frame(width: 42, height: 42)
                    
                    Text(Int(moon.illumination).localizedNumber + Constants.percent)
                        .fonted(.subheadline, weight: .medium)
                        .foregroundColor(Constants.accentColor)
                }
                .padding()
                .frame(minWidth: 70)
                .background(Color.white.opacity(moon == selectedMoon ? 1 : 0.05))
                .cornerRadius(20)
                .padding(.horizontal, 2)
            }.buttonStyle(.plain)
        }
        
        private func getDay() -> String {
            let date = Date().addingTimeInterval(.init(86400 * index))
            let weekDay = date.shortWeekday
            return weekDay
        }
        
        private func getDateDay() -> String {
            let date = Date().addingTimeInterval(.init(86400 * index))
            let weekDay = date.shortLocalizedString
            return weekDay
        }
    }
}

