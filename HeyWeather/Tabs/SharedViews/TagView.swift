//
//  TagView.swift
//  HeyWeather
//
//  Created by Mojtaba on 11/26/23.
//

import SwiftUI

struct TagViewItem {
    var value: String
    var title: String
    var image: String
}

struct TagView: View {
    @State var tags: [TagViewItem]
    @State private var totalHeight = CGFloat.zero
    var extraDetails: [String]
    var onChange: ((String) -> Void)?
    var body: some View {
        VStack {
            GeometryReader { geometry in
                self.generateContent(in: geometry)
            }
        }
        .frame(height: totalHeight)
    }
    
    private func generateContent(in g: GeometryProxy) -> some View {
        var width = CGFloat.zero
        var height = CGFloat.zero
        return ZStack(alignment: .topLeading) {
            ForEach(tags.indices, id: \.self) { index in
                Button {
                    if tags[index].value != "temp" {
                        onChange?(tags[index].value)
                    }
                } label: {
                    item(for: tags[index].title, image: tags[index].image, value: tags[index].value)
                }
                .padding([.trailing, .vertical], 4)
                .alignmentGuide(.leading, computeValue: { d in
                    if (abs(width - d.width) > g.size.width) {
                        width = 0
                        height -= d.height
                    }
                    let result = width
                    if tags[index].title == self.tags.last!.title {
                        width = 0 //last item
                    } else {
                        width -= d.width
                    }
                    return result
                })
                .alignmentGuide(.top, computeValue: {d in
                    let result = height
                    if tags[index].title == self.tags.last!.title {
                        height = 0 // last item
                    }
                    return result
                })
            }
        }
        .background(viewHeightReader($totalHeight))
    }
    
    private func item(for text: String, image: String, value: String) -> some View {
        let isSelected = extraDetails.contains(value)
        return HStack(spacing: 5) {
            Image(image)
                .resizable()
                .renderingMode(.template)
                .frame(width: 15, height: 15)
                .foregroundStyle(isSelected ? .white : .secondary)
            Text(text)
                .foregroundColor(isSelected ? .white : .secondary)
                .fonted(size: 14)
                .lineLimit(1)
            
        }
        .padding(8)
        .background(isSelected ? Constants.accentColor : Constants.accentColor.opacity(0.1))
        .clipShape(RoundedRectangle(cornerRadius: 10))
        
    }
    
    private func viewHeightReader(_ binding: Binding<CGFloat>) -> some View {
        return GeometryReader { geometry -> Color in
            let rect = geometry.frame(in: .local)
            DispatchQueue.main.async {
                binding.wrappedValue = rect.size.height
            }
            return .clear
        }
    }
}


#Preview {
    TagView(tags: [TagViewItem(value: "temp", title: "temp", image: Constants.Icons.notifHighTemperature)], extraDetails: ["temp"])
}
