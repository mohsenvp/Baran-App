//
//  MediumWidgetView3.swift
//  WeatherApp
//
//  Created by RezaRg on 8/2/20.
//

import SwiftUI
import WidgetKit

struct MediumWidgetView3: View {
    var weather : WeatherData = WeatherData()
    var theme : WidgetTheme = WidgetTheme()
    var id = 0
    var isPreviewForAppWidgetTab: Bool = false

    var body: some View {
        
        BodyOfMediumWidgetView3(weather: weather, theme: theme, id: id, isPreviewForAppWidgetTab: isPreviewForAppWidgetTab)
            .widgetBackground(theme.getBackground(), isPreviewForAppWidgetTab)
            .accessibilityElement(children: .combine)
    }
    
}

struct BodyOfMediumWidgetView3 : View {
    
    var weather : WeatherData = WeatherData()
    var theme : WidgetTheme = WidgetTheme()
    var id = 0
    var isPreviewForAppWidgetTab: Bool
    
    var body: some View {
        GeometryReader { geometry in
            let width = geometry.size.width - (isPreviewForAppWidgetTab || Constants.systemVersionIn4Digit < 17.0 ? 32 : 0)
            
            HStack {
                VStack(alignment: .leading) {
                    BodyOfSmallWidgetView3(weather: weather, theme: theme)
                        .frame(width: width * 0.5)

                    Spacer(minLength: 0)
                    LocationView(theme: theme, weather: weather, id: id)
                        .accessibilitySortPriority(-2)
                }
                .frame(width: width * 0.5)

                
                BodyOfSmallWidgetView4(weather: weather, theme: theme)
                    .accessibilitySortPriority(-1)
            }
            
        }
        .dynamicTypeSize(...DynamicTypeSize.large)
    }
}


#if DEBUG
struct MediumWidgetView3_Previews: PreviewProvider {
    static var previews: some View {
        
        //        MediumWidgetView3()
        //            .previewContext(WidgetPreviewContext(family: .systemMedium))
        
        ForEach(["iPhone SE", "iPhone 11 Pro Max"], id: \.self) { deviceName in
            MediumWidgetView3()
                .previewContext(WidgetPreviewContext(family: .systemMedium))
                .previewDisplayName(deviceName)
        }
    }
}
#endif
