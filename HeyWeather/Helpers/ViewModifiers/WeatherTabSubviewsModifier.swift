//
//  WeatherTabSubviewsModifier.swift
//  HeyWeather
//
//  Created by Kamyar on 11/28/21.
//

import Foundation
import SwiftUI

struct WeatherTabSubviewsModifier: ViewModifier {
    @Environment(\.colorScheme) var colorScheme: ColorScheme
    var background: [Color]? = nil
    var horizontalPadding: Bool = true
    var verticalPadding: Bool = true
    func body(content: Content) -> some View {
        let defaultBackground: Color = .init(colorScheme == .light ? .systemBackground : .secondarySystemBackground)
        let background: LinearGradient = .init(colors: background ?? [defaultBackground], startPoint: .top, endPoint: .bottom)
        content
            .padding(EdgeInsets(top: verticalPadding ? 16 : 0, leading: horizontalPadding ? 16 : 0, bottom: verticalPadding ? 16 : 0, trailing: horizontalPadding ? 16 : 0))
            .background(background)
            .cornerRadius(Constants.weatherTabRadius)
    }
}

extension View {
    func weatherTabShape(background: [Color]? = nil, horizontalPadding: Bool = true, verticalPadding: Bool = true) -> some View {
        return self.modifier(WeatherTabSubviewsModifier(background: background, horizontalPadding: horizontalPadding, verticalPadding: verticalPadding))
    }
}
