//
//  SegmentedPicker.swift
//  HeyWeather
//
//  Created by Kamyar on 1/31/22.
//

import SwiftUI


struct SegmentedPicker<EnumWithStringRawValue>: View where EnumWithStringRawValue: (Equatable & Hashable & RawRepresentable) {
    let items: [EnumWithStringRawValue]
    let titles: [Text]
    @Binding var selected: EnumWithStringRawValue
    var suffix: LocalizedStringKey? = nil
    
    var font: Font = .footnote
    var background: Color = .init(.systemBackground)
    var selectedBackground: Color = .init(.secondarySystemBackground)
    
    @State var offset: CGFloat = 0
    var onSegmentChanged: (() -> Void)?
    
    var body: some View {
        GeometryReader { geo in
            let itemWidth = (geo.size.width / CGFloat(items.count)) - 5
            Capsule()
                .fill(selectedBackground)
                .frame(width: itemWidth)
                .frame(height: geo.size.height - 10)
                .offset(x: offset, y: 5)
                .animation(.easeInOut, value: offset)
                .onAppear {
                    let index: CGFloat = CGFloat(items.firstIndex(of: selected) ?? 0)
                    offset = (index * itemWidth) + (5 * (index == 0 ? 1 : index))
                }
            
            HStack {
                ForEach(0..<items.count, id: \.self) { index in
                    
                    Button {
                        selected = items[index]
                        offset = (CGFloat(index) * itemWidth) + (5 * (CGFloat(index) == 0 ? 1 : CGFloat(index)))
                        onSegmentChanged?()
                    } label: {
                        HStack {
                            titles[index]
                                .lineLimit(1)
                                .minimumScaleFactor(0.6)
                                .frame(maxHeight: .infinity)
                            
                            if let suffix = suffix { Text(suffix) }
                        }
                        .font(font)
                        .frame(maxWidth: .infinity)
                        .opacity(selected == items[index] ? 1 : Constants.secondaryOpacity)
                        .cornerRadius(Constants.weatherTabRadius)
                        .foregroundStyle(Color(.label))
                    }
                    
                    
                }
            }
            .padding(.horizontal, 5)
        }
        .frame(height: 40)
        .background(Capsule().fill(background))
        
    }
}

