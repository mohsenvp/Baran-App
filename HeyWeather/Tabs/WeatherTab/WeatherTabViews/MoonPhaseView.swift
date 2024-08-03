//
//  MoonPhaseView.swift
//  HeyWeather
//
//  Created by Reza Ranjbaran on 06/04/2023.
//

import SwiftUI

struct MoonPhaseView: View {
    let moon: MoonDataModel
    var body: some View {
        
        let stringAndAngle = moon.getMoonStringAndAngle()
        
        Image(stringAndAngle.0)
            .resizable()
            .scaledToFit()
            .rotationEffect(.degrees(-1 * stringAndAngle.1))
    }
}
