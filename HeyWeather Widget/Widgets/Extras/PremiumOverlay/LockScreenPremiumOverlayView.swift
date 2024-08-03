//
//  LockScreenPremiumOverlayView.swift
//  HeyWeather WidgetExtension
//
//  Created by Reza Ranjbaran on 16/06/2023.
//

import Foundation
import SwiftUI
import WidgetKit

struct LockScreenPremiumOverlayView: View {
    
    let family: WidgetFamily
    var body: some View {

        switch family {
        case .accessoryRectangular:
            VStack(spacing: 0){
                Image(Constants.Icons.premium)
                    .renderingMode(.template)
                    .widgetAccentable()
                Text("GO PREMIUM!", tableName: "Widgets").fonted(.body, weight: .bold)
                    .widgetAccentable()
            }
            .complexModifier({ myView in
                if #available(iOS 17.0, *) {
                    myView.containerBackground(Constants.hexAccent, for: .widget)
                }
            })
        case .accessoryInline:
            HStack {
                Image(Constants.Icons.premium)
                    .renderingMode(.template)
                    .widgetAccentable()
                Text("Premium", tableName: "Premium").fonted(.body, weight: .bold)
                widgetAccentable()
            }
        case .accessoryCorner:
            Image(Constants.Icons.premium)
                .renderingMode(.template)
                .widgetAccentable()
                .widgetLabel {
                    Text("Premium", tableName: "Premium")
                }

        default:
            VStack(spacing: 0){
                Image(Constants.Icons.premium)
                    .renderingMode(.template)
                    .resizable()
                    .widgetAccentable()
                    .frame(width: 20, height: 20)
                Text("Premium", tableName: "Premium")
                    .fonted(size: 8, weight: .bold)
                    .widgetAccentable()
            }
            .complexModifier({ myView in
                if #available(iOS 17.0, *) {
                    myView.containerBackground(Constants.hexAccent, for: .widget)
                }
            })
        }
    }
}

#if DEBUG

struct LockScreenPremiumOverlayView_Previews: PreviewProvider {
    static var previews: some View {
        LockScreenPremiumOverlayView(family: .accessoryRectangular)
            .previewContext(WidgetPreviewContext(family: .accessoryRectangular))
    }
}
#endif

