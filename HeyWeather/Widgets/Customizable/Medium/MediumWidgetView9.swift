//
//  MediumWidgetView9.swift
//  HeyWeather
//
//  Created by RezaRg on 9/23/20.
//

import SwiftUI
import WidgetKit

struct MediumWidgetView9: View {
    var weather : WeatherData = WeatherData()
    var aqi : AQI = AQI()
    var theme : WidgetTheme = WidgetTheme()
    var isPreviewForAppWidgetTab: Bool = false

    var body: some View {
        
        
        GeometryReader { geometry in
            let height = geometry.size.height - (isPreviewForAppWidgetTab || Constants.systemVersionIn4Digit < 17.0 ? 32 : 0)
            VStack(spacing: 0) {
                
                TopPartOfMediumWidgetView8(weather: weather, theme: theme)
                    .padding(10)
                    .frame(height: height * 0.5)
                    .frame(maxWidth : .infinity)
                    .padding(.horizontal, 16)
                
                HStack{
                    AQIWidgetsView(aqi : aqi, widgetWidth: Constants.mediumWidgetSize.width)
                        .padding(.vertical, 6)
                        .background(Color.black.opacity(0.3))
                        .cornerRadius(25)
                        .padding(.horizontal, 10)
                }
                .frame(height: height * 0.5)
                .frame(maxWidth : .infinity)
                
            }
            .dynamicTypeSize(...DynamicTypeSize.large)
            .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
            .widgetBackground(theme.getBackground(), isPreviewForAppWidgetTab)
        }
        
    }
    
}

#if DEBUG
struct MediumWidgetView9_Previews: PreviewProvider {
    static var previews: some View {
        MediumWidgetView9().previewContext(WidgetPreviewContext(family: .systemMedium))
    }
}
#endif
