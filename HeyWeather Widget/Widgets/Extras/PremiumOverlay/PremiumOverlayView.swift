//
//  PremiumOverlayView.swift
//  HeyWeather WidgetExtension
//
//  Created by Reza Ranjbaran on 18/05/2023.
//

import Foundation
import SwiftUI
import WidgetKit


struct PremiumOverlayView: View {
    
    @Environment(\.widgetRenderingMode) var widgetRenderingMode
    
    let kind: WidgetKind
    
    var title: Text {
        switch kind {
        case .customizable:
            Text("To use Customizable Widgets and unlock many more features", tableName: "Widgets")
        case .forecast:
            Text("To use Forecast Widgets and unlock many more features", tableName: "Widgets")
        case .aqi:
            Text("To use AQI Widgets and unlock many more features", tableName: "Widgets")
        }
    }
    var body: some View {
        
        HStack {
            Spacer()
            VStack{
                Spacer()
                Image(Constants.Icons.premium)
                    .resizable()
                    .renderingMode(.template)
                    .frame(width: 40, height: 40)
                    .foregroundStyle(.white)
                VStack(alignment: .center, spacing: 8){
                    
                    Text("GO PREMIUM!", tableName: "Widgets")
                        .foregroundStyle(.white)
                        .lineLimit(2)
                        .fonted(.headline, weight: .semibold)
                        .multilineTextAlignment(.center)
                        .minimumScaleFactor(0.5)
                    
                    title
                        .foregroundStyle(.white)
                        .lineLimit(3)
                        .fonted(.footnote, weight: .regular)
                        .multilineTextAlignment(.center)
                        .minimumScaleFactor(0.5)
                }
                
                Spacer()
            }
            Spacer()
        }
        .complexModifier { myView in
            if #available(iOS 17.0, *) {
                myView.containerBackground(LinearGradient(colors: [Constants.purpleTheme.gradientLightColor, Constants.purpleTheme.gradientDarkColor], startPoint: .topLeading, endPoint: .bottomTrailing), for: .widget)
            }else {
                myView.background(LinearGradient(colors: [Constants.purpleTheme.gradientLightColor, Constants.purpleTheme.gradientDarkColor], startPoint: .topLeading, endPoint: .bottomTrailing))
            }
        }
        
    }
}

#if DEBUG
struct PremiumOverlayView_Previews: PreviewProvider {
    static var previews: some View {
        PremiumOverlayView(kind: .forecast)
            .previewContext(WidgetPreviewContext(family: .systemLarge))
    }
}
#endif
