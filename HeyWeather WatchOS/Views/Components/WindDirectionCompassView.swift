//
//  WindDirectionCompassView.swift
//  HeyWeather
//
//  Created by Mohammad Yeganeh on 8/7/23.
//

import SwiftUI

struct WindDirectionCompassView: View {
    let windDegree: Int?
    var body: some View {
        ZStack {
            Circle().fill(.ultraThinMaterial)
            Image(systemName: Constants.SystemIcons.arrowUp)
                .fonted(size: 16, weight: .semibold)
                .rotationEffect(.degrees(Double((windDegree ?? 180) - 180))) // TODO: Handle This
            
            Circle()
                .stroke(Color.gray ,style: StrokeStyle(lineWidth: 2.5, lineCap: .round, dash: [15], dashPhase: 24))
                .padding(6)
                .opacity(0.5)
            
            VStack {
                Text("N")
                    .opacity(0.5)
                    .fonted(size: 10, weight: .regular)
                    .background(Color.clear)
                Spacer()
                Text("S")
                    .opacity(0.5)
                    .fonted(size: 10, weight: .regular)
                    .background(Color.clear)
            }
            .padding(.vertical, 2.5)
            
            HStack {
                Text("W")
                    .opacity(0.5)
                    .fonted(size: 10, weight: .regular)
                Spacer()
                Text("E")
                    .opacity(0.5)
                    .fonted(size: 10, weight: .regular)
            }
            .padding(.horizontal, 2.5)
            
        }
        .frame(width: 50, height: 50)
        
    }
}

#Preview {
    WindDirectionCompassView(windDegree: 20)
}
