//
//  DescriptionView.swift
//  HeyWeather
//
//  Created by Kamyar on 11/28/21.
//
import SwiftUI

struct DescriptionView: View {
    let description: WeatherDescription
    var body: some View {
        HStack {
            Image(Constants.Icons.compass)
                .resizable()
                .frame(width: 50, height: 50)
                .cornerRadius(Constants.weatherTabRadius)
                .padding(.trailing)
                .accessibilityHidden(true)
            VStack(alignment: .leading) {
                Text(description.shortDescription)
                    .fonted(.footnote, weight: .regular)
                    .opacity(Constants.primaryOpacity)
                    .padding(.bottom, 0.25)
                Text(description.longDescription)
                    .fonted(.body, weight: .regular)
                    .lineSpacing(-5)
            }.accessibilityElement(children: .combine)
            Spacer()
        }.weatherTabShape()
    }
}


#if DEBUG
struct DescriptionView_Previews: PreviewProvider {
    static var previews: some View {
        DescriptionView(description: WeatherDescription())
    }
}
#endif
