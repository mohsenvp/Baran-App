//
//  MarqueeText.swift
//  HeyWeather
//
//  Created by Kamyar on 10/20/21.
//

import Foundation
import SwiftUI

struct MarqueeText: View {
    @State var text = ""
    @State private var animate = false
    
    var body : some View {
        let stringWidth = text.widthOfString(usingFont: UIFont.systemFont(ofSize: 15))
        return ZStack {
            GeometryReader { geometry in
                Text(self.text).lineLimit(1)
                    .fonted(.subheadline, weight: .regular)
                    .offset(x: self.animate ? -stringWidth * 2 : 0)
                    .animation(.linear(duration: 8.5).delay(1.5).repeatForever(autoreverses: false), value: animate)
                    .onAppear() {
                        if geometry.size.width < stringWidth {
                            self.animate = true
                        }
                    }
                    .fixedSize(horizontal: true, vertical: false)
                    .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .leading)
                
                Text(self.text).lineLimit(1)
                    .fonted(.subheadline, weight: .regular)
                    .offset(x: self.animate ? 0 : stringWidth * 2)
                    .animation(.linear(duration: 8.5).delay(1.5).repeatForever(autoreverses: false), value: animate)
                    .fixedSize(horizontal: true, vertical: false)
                    .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .leading)
            }
        }
    }
}
