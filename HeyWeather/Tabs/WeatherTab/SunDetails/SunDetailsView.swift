//
//  SunDetailsView.swift
//  HeyWeather
//
//  Created by Mohammad Yeganeh on 8/27/23.
//

import SwiftUI

struct SunDetailsView: View {
    @StateObject var viewModel: SunDetailsViewModel
    @Binding var isPresented: Bool
    @Environment(\.colorScheme) var colorScheme
    var body: some View {
        


        ScrollView(showsIndicators: false){
            LazyVStack{
                ZStack(alignment: .top){
                    HStack {
                        Spacer()
                        Button {
                            isPresented.toggle()
                        } label: {
                            Image(systemName: Constants.SystemIcons.xmark)
                        }.padding(20)
                            .tint(Constants.maxTempColor)
                    }
                    Image(Constants.Icons.radialSun)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 150, height: 150)
                        .accessibilityHidden(true)

                }
                
                if viewModel.suns.count > 1 {
                    TodayDetailsView(sun: viewModel.suns.first!)
                    
                    ForEach(1..<viewModel.suns.count, id: \.self) { i in
                        let date = Date().addingTimeInterval(.init(86400 * i))
                        AstronomyDetailsView(
                            type: .sun,
                            sun: viewModel.suns[i],
                            date: date
                        )
                    }
                }
            }
            .padding()
        }
        .background(Constants.sunBg.opacity(colorScheme == .dark ? 0 : 0.1))
    }
    
    
}

private struct TodayDetailsView: View {
    @Environment(\.colorScheme) var colorScheme
    let sun: SunDataModel
    var body: some View {
        VStack {
            HStack{
                Text("Today", tableName: "General")
                    .fonted(.title3, weight: .semibold)
                Text(Constants.openParen + Date.now.shortLocalizedString + Constants.closeParen)
                    .fonted(.body, weight: .regular)
                    .opacity(Constants.primaryOpacity)
                Spacer()
            }
            HStack {
                HStack(spacing:0) {
                    Image(Constants.Icons.sunrise)
                        .resizable()
                        .renderingMode(.template)
                        .frame(width: 24, height: 24)

                    Text((sun.sunrise ?? Date()).toUserTimeFormatWithMinuets())
                        .fonted(.body, weight: .semibold)
                        .frame(width: 74)
                        .lineLimit(1)
                        .minimumScaleFactor(0.8)
                }
                
                DottedLine()
                    .stroke(style: StrokeStyle(lineWidth: 1, dash: [5]))
                    .frame(height: 1)
                    .opacity(0.6)
                    .layoutPriority(-1)
                
                HStack(spacing:0) {
                    Text((sun.sunset ?? Date()).toUserTimeFormatWithMinuets())
                        .fonted(.body, weight: .semibold)
                        .frame(width: 74)
                        .lineLimit(1)
                        .minimumScaleFactor(0.8)
                    
                    Image(Constants.Icons.sunset)
                        .resizable()
                        .renderingMode(.template)
                        .frame(width: 24, height: 24)
                }
            }
            DetailsRow(title: Text("Sun Distance", tableName: "Sun"), value: Text(Int(sun.distance).localizedVisibility))
            DetailsRow(title: Text("Daylight Duration", tableName: "Climate"), value: Text("\(sun.getDayDurationHours()) hours", tableName: "General"))
            DetailsRow(title: Text("Altitude", tableName: "Sun"), value: Text(sun.altitude.localizedNumber() + Constants.degree))
            DetailsRow(title: Text("Direction", tableName: "Sun"), value: Text(sun.direction.localizedNumber() + Constants.degree))
        }
        .foregroundColor(.white)
        .padding(.horizontal)
        .padding(.vertical)
        .background(colorScheme == .dark ? Constants.sunBgDark : Constants.sunBg)
        .cornerRadius(Constants.weatherTabRadius)
    }
    
    struct DetailsRow: View {
        let title: Text
        let value: Text
        var body: some View {
            HStack {
                title
                    .opacity(Constants.primaryOpacity)
                    .fonted(.body, weight: .medium)
                Spacer()
                value.fonted(.body, weight: .medium)
            }.padding(.vertical, 5)
                .accessibilityElement(children: .combine)
        }
    }
}

struct SunDetailsView_Previews: PreviewProvider {
    @State static var isPresented: Bool = false
    static var previews: some View {
        SunDetailsView(viewModel: .init(suns: [SunDataModel(), SunDataModel(), SunDataModel(), SunDataModel(), SunDataModel(), SunDataModel(), SunDataModel()]), isPresented: $isPresented)
    }
}
