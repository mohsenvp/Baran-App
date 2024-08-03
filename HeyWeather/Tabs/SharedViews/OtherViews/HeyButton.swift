//
//  HeyButton.swift
//  HeyWeather
//
//  Created by mohamd yeganeh on 4/29/23.
//

import SwiftUI

struct HeyButton: View {
    var title: Text = Text("")
    var isSecondary: Bool = false
    
    var body: some View {
        title.fonted(.body, weight: .medium)
            .foregroundColor(isSecondary ? .secondary : .white)
            .frame(maxWidth: .infinity)
            .padding()
            .background(RoundedRectangle(cornerRadius: Constants.weatherTabRadius)
                .stroke(isSecondary ? Color.secondary : Color.accentColor, lineWidth: 1)
                .background( RoundedRectangle(cornerRadius: Constants.weatherTabRadius)
                    .fill(isSecondary ? Color.clear : Color.accentColor))
            )
            .cornerRadius(Constants.weatherTabRadius)
    }
}
