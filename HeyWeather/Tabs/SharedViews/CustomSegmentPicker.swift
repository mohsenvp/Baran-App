//
//  CustomSegmentPicker.swift
//  HeyWeather
//
//  Created by Mohammad Yeganeh on 10/16/23.
//

import Foundation
import SwiftUI

struct SegmentItem: Identifiable, Equatable {
    var id: UUID = .init()
    var title: Text
    var image: String
}
struct CustomSegmentPicker: View {
    let items: [SegmentItem]
    @State var selectedIndex: Int
    
    var background: Color = .init(.systemBackground)
    var selectedBackground: Color = .init(.secondarySystemBackground)
    
    @State var offset: CGFloat = 0
    var onSegmentChanged: ((Int) -> Void)?

    var body: some View {
        GeometryReader { geo in
            let itemWidth = (geo.size.width / CGFloat(items.count)) - 5
            RoundedRectangle(cornerRadius: Constants.weatherTabRadius)
                .fill(selectedBackground)
                .frame(width: itemWidth)
                .frame(height: geo.size.height - 10)
                .offset(x: offset, y: 5)
                .animation(.easeInOut, value: offset)
                .onAppear {
                    let index = CGFloat(selectedIndex)
                    offset = (index * itemWidth) + (5 * (index == 0 ? 1 : index))
                }
            
            HStack {
                ForEach(0..<items.count, id: \.self) { index in
                    
                    Button {
                        selectedIndex = index
                        offset = (CGFloat(index) * itemWidth) + (5 * (CGFloat(index) == 0 ? 1 : CGFloat(index)))
                        onSegmentChanged?(selectedIndex)
                    } label: {
                        VStack(spacing: 6) {
                            Spacer(minLength: 0)
                            Image(items[index].image)
                            items[index].title
                                .lineLimit(1)
                                .minimumScaleFactor(0.6)
                            Spacer(minLength: 0)
                        }
                        .fonted(.footnote, weight: .regular)
                        .frame(maxWidth: .infinity)
                        .opacity(selectedIndex == index ? 1 : Constants.secondaryOpacity)
                        .cornerRadius(Constants.weatherTabRadius)
                        .foregroundStyle(Color(.label))
                    }
                    
                    
                }
            }
            .padding(.horizontal, 5)
        }
        .background(
            RoundedRectangle(cornerRadius: Constants.weatherTabRadius).fill(background)
        )
        
    }
}
