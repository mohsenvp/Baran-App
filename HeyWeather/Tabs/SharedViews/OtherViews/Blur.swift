//
//  Blur.swift
//  HeyWeather
//
//  Created by Kamyar on 11/28/21.
//

import SwiftUI

struct Blur: View {
    @Environment(\.colorScheme) var colorScheme: ColorScheme
    
    var body: some View {
        Rectangle()
            .background(.ultraThinMaterial)
            .environment(\.colorScheme, colorScheme == .dark ? .light : .dark)
    }
}
