//
//  LargeWidgetView2.swift
//  WeatherApp
//
//  Created by Alfredo Uzumaki on 8/30/20.
//

import SwiftUI
import WidgetKit

struct LargeWidgetView2: View {
    var weather : WeatherData = WeatherData()
    var theme : WidgetTheme = WidgetTheme()
    var id = 0
    var isPreviewForAppWidgetTab: Bool = false

    var body :some View {
        let todayWeather = weather.today
        ZStack {
            HStack{
                GeometryReader { geo in
                    Color.white.opacity(0.05)
                        .frame(width: geo.size.width*1.7, height: geo.size.width/1.5)
                        .rotationEffect(.degrees(45))
                        .padding([.trailing], geo.size.width)
                }
            }
            .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .center)
            
            
            VStack(alignment: .center, spacing : 5) {
                Spacer()
                HStack(alignment: .center) {
                    ConditionIcon(iconSet: theme.iconSet, condition: todayWeather.condition)
                        .frame(width: 70, height: 70)
                        .padding(.top, 20)
                        .accessibilityHidden(true)
                }
                Spacer()
                
                VStack {
                    Group {
                        Text(todayWeather.temperature.now.localizedTemp)
                            .fonted(size: 34, weight: .semibold, custom: theme.font)
                            .contentTransition(.numericText())
                        
                        Text(todayWeather.description.shortDescription)
                            .fonted(size: 22, weight: .regular, custom: theme.font)
                            .transition(.push(from: .leading))
                    }
                    .lineLimit(1)
                    .foregroundColor(theme.fontColor)
                }.padding(3)
                
                
                Spacer()
                VStack {
                    let max = todayWeather.temperature.max.localizedTemp
                    let min = todayWeather.temperature.min.localizedTemp
                    Text("\(min) /  \(max)")
                        .fonted(size: 12, weight: .regular, custom: theme.font)
                        .minimumScaleFactor(0.1)
                        .accessibilityLabel(Text("\(max)° \("at.max".localized), \(min)° \("at.min".localized)"))
                        .contentTransition(.numericText())
                    LocationView(theme: theme, weather: weather, id: id)
                        .padding(.top, 2)
                }.foregroundColor(theme.fontColor)
                .padding()
                
            }.frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .center)
            
            
        }
        .dynamicTypeSize(...DynamicTypeSize.large)
        .widgetBackground(theme.getBackground(), isPreviewForAppWidgetTab)
        .accessibilityElement(children: .combine)
        
    }
}

#if DEBUG
struct LargeWidgetView2_Previews: PreviewProvider {
    static var previews: some View {
        LargeWidgetView2()
            .previewContext(WidgetPreviewContext(family: .systemLarge))
    }
}
#endif
