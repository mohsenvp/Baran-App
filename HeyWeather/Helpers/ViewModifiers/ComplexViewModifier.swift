//
//  ComplexViewModifier.swift
//  HeyWeather
//
//  Created by Mohammad Yeganeh on 8/13/23.
//

import SwiftUI

extension View {
    func complexModifier<V: View>(@ViewBuilder _ closure: (Self) -> V) -> some View {
        closure(self)
    }
}
