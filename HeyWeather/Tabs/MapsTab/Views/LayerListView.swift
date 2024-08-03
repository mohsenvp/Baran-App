//
//  LayerListView.swift
//  HeyWeather
//
//  Created by mohamd yeganeh on 5/5/23.
//

import SwiftUI

struct LayerListView: View {
    @ObservedObject var viewModel: MapViewModel
    @State var opacity = 0.0
    @EnvironmentObject var premium : Premium
    @Environment(\.isSubscriptionViewPresented) var isSubscriptionViewPresented


    var body: some View {
        ScrollView(showsIndicators: false) {
            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())]) {
                ForEach(0..<viewModel.mapData.layers.count, id: \.self) { i in
                    Button {
                        if !premium.isPremium && viewModel.mapData.layers[i].isLayerLocked {
                            isSubscriptionViewPresented.wrappedValue.toggle()
                            return
                        }
                        viewModel.selectLayer(layer: viewModel.mapData.layers[i])
                    } label: {
                        LayerItemView(layer: viewModel.mapData.layers[i])
                    }
                    .opacity(opacity)
                    .animation(Constants.isWidthCompact ? nil : .linear(duration: 0.1).delay(viewModel.isLayersViewOpen ? (0.05 * Double(i + 1)) : 0), value: opacity)
                }
                Spacer()
                Spacer()
                
            }
        }
        .padding(.horizontal, 12)
        .allowsHitTesting(viewModel.isLayersViewOpen)
        .onChange(of: viewModel.isLayersViewOpen) { isShown in
            opacity = isShown ? 1 : 0
        }
    }
    
    
    
    private struct LayerItemView: View {
        
        var layer: MapLayer
        @Environment(\.colorScheme) var colorScheme
        @EnvironmentObject var premium : Premium
        @Environment(\.isSubscriptionViewPresented) var isSubscriptionViewPresented

        let imageWidth = Constants.screenWidth / 2 - 52
        var body: some View {
            ZStack {
 
                RoundedRectangle(cornerRadius: 14)
                    .strokeBorder(Color.init(.label).opacity(0.2), lineWidth: 1)
                    .background(RoundedRectangle(cornerRadius: 14).fill(Color.init(.systemBackground).opacity(Constants.primaryOpacity)))
                
                VStack(alignment: .leading, spacing: 0) {
                    
                    AsyncImage(url: URL(string: colorScheme == .dark ? layer.imageDark : layer.imageLight),
                               content: { image in
                        image.resizable()
                            .aspectRatio(contentMode: .fill)
                    },placeholder: {
                        ZStack {
                            ProgressView()
                        }
                    }
                    )
                    .frame(width: imageWidth, height: imageWidth * 0.8)
                    .cornerRadius(12)
                    .isLocked((layer.isLayerLocked && !premium.isPremium), cornerRadius: 12, isSubscriptionViewPresented: isSubscriptionViewPresented)
                    
                    
                    
                    Spacer(minLength: 10)
                    
                    Text(layer.title)
                        .fonted(.footnote, weight: .semibold)
                        .foregroundColor(.init(.secondaryLabel))
                        .lineLimit(2)
                        .multilineTextAlignment(.leading)
                    
                    Spacer()
                    
                    Rectangle()
                        .fill(
                            .linearGradient(Gradient(colors: layer.getLayerGuides().map({$0.color})), startPoint: .leading, endPoint: .trailing)
                        ).cornerRadius(3)
                        .frame(width: .infinity, height: 6)
                    
                }
                .padding(12)
            }

        }
    }
}

