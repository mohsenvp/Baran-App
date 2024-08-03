//
//  VerticalDivider.swift
//  HeyWeather WatchOS
//
//  Created by Mohammad Yeganeh on 9/11/23.
//

import SwiftUI

struct VerticalDivider: View {
    let color: Color
    
    var body: some View {
        Spacer(minLength: 0)
        Rectangle().fill(color.opacity(0.1))
            .frame(width: 0.5)
            .frame(maxHeight: .infinity)
            .padding(.vertical, 10)
        Spacer(minLength: 0)
    }
}

