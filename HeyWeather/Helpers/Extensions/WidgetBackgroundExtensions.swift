//
//  WidgetBackgroundExtensions.swift
//  HeyWeather
//
//  Created by Mohammad Yeganeh on 9/23/23.
//

import SwiftUI

extension View {
    func widgetBackground(_ backgroundView: some View, _ isPreview: Bool = false, hasPadding: Bool = true) -> some View {
        if isPreview {
            return AnyView(padding(hasPadding ? 16 : 0).background(backgroundView))
        }
        if #available(iOS 17.0, *) {
            return AnyView(containerBackground(for: .widget) {
                backgroundView
            })
        } else {
            return AnyView(padding(hasPadding ? 16 : 0).background(backgroundView))
        }
    }
}

extension VStack {
    func VStackWidgetBackground(_ backgroundView: some View, _ isPreview: Bool = false, hasPadding: Bool = true) -> some View {
        return self.widgetBackground(backgroundView, isPreview, hasPadding: hasPadding)
    }
}
extension ZStack {
    func ZStackWidgetBackground(_ backgroundView: some View, _ isPreview: Bool = false, hasPadding: Bool = true) -> some View {
        return self.widgetBackground(backgroundView, isPreview, hasPadding: hasPadding)
    }
}
