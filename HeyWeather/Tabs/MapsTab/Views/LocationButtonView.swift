//
//  LocationButtonView.swift
//  HeyWeather
//
//  Created by mohamd yeganeh on 5/4/23.
//

import SwiftUI

struct LocationButtonView: View {
    @Binding var shouldCenterCity: Bool
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 14)
                .strokeBorder(Color.init(.label).opacity(0.2), lineWidth: 1)
                .background(RoundedRectangle(cornerRadius: 14).fill(Color.init(.systemBackground).opacity(Constants.primaryOpacity)))
            
            Button {
                shouldCenterCity.toggle()
            } label: {
                Image(Constants.Icons.location)
            }.accentColor(.init(.secondaryLabel))
        }
        .frame(width: 40, height: 40)
        .padding(.trailing, 10)
        
        
    }
}

