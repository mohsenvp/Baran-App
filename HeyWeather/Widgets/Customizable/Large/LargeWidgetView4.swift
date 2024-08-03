//
//  LargeWidgetView6.swift
//  HeyWeather
//
//  Created by RezaRg on 9/19/20.
//

import SwiftUI
import WidgetKit

struct LargeWidgetView4: View {
    var weather : WeatherData = WeatherData()
    var theme : WidgetTheme = WidgetTheme()
    var id = 0
    var isPreviewForAppWidgetTab: Bool = false

    var body :some View {
        let daily = weather.dailyForecast
        
        GeometryReader { geometry in
            
            let height = geometry.size.height - (isPreviewForAppWidgetTab || Constants.systemVersionIn4Digit < 17.0 ? 32 : 0)
            
            VStack(spacing: 0) {
                
                
                BodyOfMediumWidgetView3(weather: weather, theme: theme, isPreviewForAppWidgetTab: isPreviewForAppWidgetTab)
                    .frame(height: height * 0.5)
                    .frame(maxWidth : .infinity)
                
                Spacer(minLength: 12)
                
                HStack{
                    ForEach(daily[0...4]) { daily in
                        SingleCapsuleDetailViewMedium(theme: theme, weather: daily)
                    }
                    
                }
                .frame(height: height * 0.5)
                .frame(maxWidth : .infinity)
                .accessibilitySortPriority(-1)
                
            }
            .dynamicTypeSize(...DynamicTypeSize.large)
            .widgetBackground(theme.getBackground(), isPreviewForAppWidgetTab)
            .accessibilityElement(children: .combine)
        }
        
    }
}

#if DEBUG
struct LargeWidgetView4_Previews: PreviewProvider {
    static var previews: some View {
        LargeWidgetView4()
            .previewContext(WidgetPreviewContext(family: .systemLarge))
    }
}
#endif
