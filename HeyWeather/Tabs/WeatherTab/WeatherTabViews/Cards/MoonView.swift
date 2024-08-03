//
//  MoonView.swift
//  HeyWeather
//
//  Created by Kamyar on 11/28/21.
//

import SwiftUI

struct MoonView: View {
    let moon: MoonDataModel
    var body: some View {
        HStack() {
            
            VStack(alignment: .leading) {
                Text(moon.phase)
                    .fonted(.title2, weight: .bold)
                    .lineSpacing(-5)
                    .padding(.bottom, -2.5)
                    .padding(.trailing)
                    .lineLimit(1)
                    .minimumScaleFactor(0.8)
                Text("Illumination : \(moon.illumination.localizedNumber(withFractionalDigits: 0))%", tableName: "Moon")
                    .fonted(.footnote, weight: .regular)
                    .opacity(Constants.primaryOpacity)
            }.accessibilityElement(children: .ignore)

            
            Spacer()
            MoonPhaseView(moon:moon)
                .frame(width: 45, height: 45)
                .cornerRadius(Constants.weatherTabRadius)
                .accessibilityHidden(true)


        }
        .foregroundColor(.white)
        .accessibilityLabel(Text("moon state is \(moon.phase)", tableName: "Accessibility"))
        .accessibility(value:  Text("Illumination : \(moon.illumination.localizedNumber(withFractionalDigits: 0))%", tableName: "Moon"))
        .weatherTabShape(background: Constants.moonViewColors)
    }
}

#if DEBUG
struct MoonView_Previews: PreviewProvider {
    static var previews: some View {
        MoonView(moon: .init())
    }
}
#endif

