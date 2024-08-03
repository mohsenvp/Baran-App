//
//  VerticalRotationModifier.swift
//  HeyWeather
//
//  Created by Reza Ranjbaran on 11/05/2023.
//

import Foundation
import SwiftUI

struct VerticalRotationModifier: ViewModifier {
    @State private var contentSize = CGSize.zero
    let rotation: VerticalRotationType

    // 1) Transparent overlay captures the view's size using `ContentSizePreferenceKey`
    // 2) Setting a `.preference` triggers `.onPreferenceChange` which sets the @State contentSize
    // 3) The frame size is set based on the @State contentSize with the height and width flipped
    func body(content: Content) -> some View {
        content
            .fixedSize()
            .overlay(GeometryReader { proxy in
                Color.clear.preference(key: ContentSizePreferenceKey.self, value: proxy.size)
            })
            .onPreferenceChange(ContentSizePreferenceKey.self, perform: { newSize in
                DispatchQueue.main.async {
                    contentSize = newSize
                }
            })
            .rotationEffect(rotation.asAngle)
            .frame(width: contentSize.height, height: contentSize.width)
    }

    enum VerticalRotationType {
        case clockwise
        case anticlockwise
        
        var asAngle: Angle {
            switch(self) {
            case .clockwise:
                return .degrees(90)
            case .anticlockwise:
                return .degrees(-90)
            }
        }
    }
    
    private struct ContentSizePreferenceKey: PreferenceKey {
        static var defaultValue: CGSize = .zero

        static func reduce(value: inout CGSize, nextValue: () -> CGSize) {
            value = nextValue()
        }
    }
}
