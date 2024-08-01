////
////  SmallWidgetView9.swift
////  HeyWeather
////
////  Created by RezaRg on 9/23/20.
////
//
//import SwiftUI
//import WidgetKit
//
//struct SmallWidgetView9: View {
//    var weather : WeatherData = WeatherData()
//    var aqi : AQI = AQI()
//    var theme : WidgetTheme = WidgetTheme()
//    
//    var body: some View {
//        let todayWeather = weather.today
//        let updatedAt = todayWeather.updatedAt
//        
//        GeometryReader { geometry in
//            VStack(spacing: 0) {
//                
//                HStack(spacing : 0) {
//                    VStack (spacing : 0) {
//                        Text(todayWeather.temperature.now.localizedTemp)
//                            .font(.system(size: 60))
//                            .bold()
//                            .minimumScaleFactor(0.01)
//                            .foregroundColor(theme.fontColor)
//                        LocationView(theme: theme, weather: weather, id: id)
//                    }
//                    
//                    .frame(height: geometry.size.height * 0.35)
//                    
//                    
//                    VStack (spacing : 0) {
//                        ConditionIcon(iconSet: theme.iconSet, condition: todayWeather.condition)
//                            .padding(.bottom, 2)
//                            .accessibilityHidden(true)
//                        Text(todayWeather.description.shortDescription)
//                            .font(.caption)
//                            .foregroundColor(theme.fontColor)
//                            .minimumScaleFactor(0.01)
//                    }
//                    .frame(width: geometry.size.width * 0.35, height: geometry.size.height * 0.35)
//                }
//                .frame(height: geometry.size.height * 0.5)
//                .frame(maxWidth : .infinity)
//                
//                AQIWidgetsView(aqi : aqi, widgetWidth: Constants.smallWidgetSize.width - 30)
//                    .padding(.vertical, 6)
//                    .background(Color.black.opacity(0.3))
//                    .cornerRadius(16)
//                    .padding(.horizontal, 10)
//                    .frame(height: geometry.size.height * 0.5)
//                    .frame(maxWidth : .infinity)
//                
//            }.frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
//            .background(theme.getBackground())
//        }
//        .accessibilityElement(children: .combine)
//        
//    }
//}
//
//#if DEBUG
//struct SmallWidgetView9_Previews: PreviewProvider {
//    static var previews: some View {
//        
//        SmallWidgetView9().previewContext(WidgetPreviewContext(family: .systemSmall))
//        
//    }
//}
//#endif
