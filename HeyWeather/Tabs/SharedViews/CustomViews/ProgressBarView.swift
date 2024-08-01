//
//  ProgressBarView.swift
//  HeyWeather
//
//  Created by Reza Ranjbaran on 08/05/2023.
//

import Foundation
import SwiftUI

struct ProgressBarView: View {
    let alignment: Alignment
    let progress: Int

    var body: some View {
        GeometryReader { proxy in
            ZStack(alignment: alignment) {
                DottedLine()
                    .stroke(style: .init(lineWidth: 1, lineJoin: .round, dash: [2.5]))
                    .fill(Color.white)
                                .frame(width: proxy.size.width)
                Constants.precipitationProgress
                    .clipShape(Capsule())
                    .frame(width: CGFloat(progress * Int(proxy.size.width + 2) / 100))
                    .shadow(radius: 0.1)
                    .opacity(0.85)
            }
        }
    }
}
