//
//  PageDottedIndicatorView.swift
//  HeyWeather
//
//  Created by Mojtaba on 10/22/23.
//

import SwiftUI

struct PageDottedIndicatorView: View {
    var pageNumber: Int = 4
    var selectedPage: Int
    var color: Color
    
    var selectedOpacity: Double = 0.8
    var defaultOpacity: Double = 0.2
    
    var minScale: CGFloat = 0.5
    var maxScale: CGFloat = 1
    
    var body: some View {
        HStack {
            ForEach(0..<pageNumber, id: \.self) { i in
                Circle().fill()
                    .opacity(i+1 == selectedPage ? selectedOpacity : defaultOpacity)
                    .scaleEffect(i+1 == selectedPage ? maxScale : minScale)
                    .foregroundStyle(i+1 == selectedPage ? color : Color.secondary)
            }
        }
    }
}

