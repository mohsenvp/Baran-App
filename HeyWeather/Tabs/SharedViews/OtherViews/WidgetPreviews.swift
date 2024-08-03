//
//  WidgetPreviews.swift
//  HeyWeather
//
//  Created by Kamyar on 10/20/21.
//

import Foundation
import SwiftUI
import WidgetKit

struct WidgetsPreviewAllSizes<Content: View>: View {
    var widgetSize :WidgetFamily = .systemSmall
    let content: Content
    
    init(widgetSize : WidgetFamily, @ViewBuilder content: () -> Content) {
        self.content = content()
        self.widgetSize = widgetSize
    }
    
    var body: some View {
        content
            .previewContext(WidgetPreviewContext(family: widgetSize))
    }
}
