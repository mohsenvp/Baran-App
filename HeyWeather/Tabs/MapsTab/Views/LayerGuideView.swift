//
//  LayerGuideView.swift
//  HeyWeather
//
//  Created by mohamd yeganeh on 5/4/23.
//

import SwiftUI

struct LayerGuideView: View {
    @ObservedObject var viewModel: MapViewModel
    
    var body: some View {
        
        ZStack {
            RoundedRectangle(cornerRadius: 14)
                .strokeBorder(Color.init(.label).opacity(0.2), lineWidth: 1)
                .background(RoundedRectangle(cornerRadius: 14).fill(Color.init(.systemBackground).opacity(Constants.primaryOpacity)))
            
            VStack(spacing: 0) {
                
                HStack {
                    Text(viewModel.selectedLayer.getLayerGuides().first?.value ?? "")
                        .fonted(.footnote, weight: .regular)
                        .foregroundStyle(.secondary)

                    
                    Spacer()
                    
                    Text(viewModel.selectedLayer.title + " (\(viewModel.selectedLayer.unit))")
                        .fonted(.footnote, weight: .semibold)
                        .foregroundStyle(.primary)
                    
                    Spacer()
                    
                    Text(viewModel.selectedLayer.getLayerGuides().last?.value ?? "")
                        .fonted(.footnote, weight: .regular)
                        .foregroundStyle(.secondary)
                    
                    
                }
                
                Rectangle()
                    .fill(
                        .linearGradient(Gradient(colors: viewModel.selectedLayer.getLayerGuides().map({$0.color})), startPoint: .leading, endPoint: .trailing)
                    ).cornerRadius(3)
                    .frame(width: .infinity, height: 6)
                    .padding(.top, 8)

                
            }
            .padding(.horizontal, 12)
        }
        .frame(height: 50.0)
        
    }
}
