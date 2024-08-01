//
//  TextFontModifier.swift
//  HeyWeather
//
//  Created by Reza Ranjbaran on 28/05/2023.
//

import SwiftUI
// size   : CGFloat
// weight : Font.Weight
// style  : Font.TextStyle


//If there is no font() modifer in Text modifer,s no action required!
// Beacsue .environment(\.font, .system(.body, design: .rounded)) will do the job

// Text("")             --> No need to do anything
// .fontWeight(.bold)   --> No need to do anything
// .bold()              --> No need to do anything

//But if there was .font() modifer:
//These are 2 types:
//One with .system function inside
//One with TextStyle inside
//And each category has 2 types. Check Examples here to know what to do!

// .font(.system(size: 30))                      ---> .fonted(size: 36)
// .font(.system(size: 36, weight: .ultraLight)) ---> .fonted(size: 36, weight: .ultraLight)

// .font(.largeTitle)                            ---> .fonted(.largeTitle)
// .font(.largeTitle.weight(.heavy))             ---> .fonted(.largeTitle, weight: .heavy)

extension View {
    func fonted(size: CGFloat = 17, weight: Font.Weight = .regular, custom: String? = nil) -> some View {
        let nFont: Font = custom != nil && custom != "Default" ? Font.custom(custom!, size: size) : Font.system(size: size ,weight: weight, design: Constants.appFontDesign)
        let updatedView = self.font(nFont)
        return updatedView
    }
    
    func fonted(_ style: Font.TextStyle, weight: Font.Weight = .regular) -> some View {
        let nFont: Font = Font.system(style, design: Constants.appFontDesign)
                .weight(weight)
        let updatedView = self.font(nFont)
        return updatedView
    }
}

