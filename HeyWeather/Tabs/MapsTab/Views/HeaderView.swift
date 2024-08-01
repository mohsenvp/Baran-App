//
//  HeaderView.swift
//  HeyWeather
//
//  Created by mohamd yeganeh on 5/4/23.
//

import SwiftUI

struct HeaderView: View {
    @ObservedObject var viewModel: MapViewModel
    @State var headerViewHeight = 50.0
    @State var arrowRotation = 0.0
    var body: some View {
        ZStack(alignment: .top){
            Button {
                viewModel.isLayersViewOpen.toggle()
            } label: {
                ZStack(alignment: .top){
                    RoundedRectangle(cornerRadius: 14)
                        .strokeBorder(Color.init(.label).opacity(0.2), lineWidth: 1)
                        .background(RoundedRectangle(cornerRadius: 14).fill(Color.init(.systemBackground).opacity(Constants.primaryOpacity)))
                        .frame(height: headerViewHeight)
                        .animation(Constants.motionReduced ? nil : .linear(duration: 0.3), value: headerViewHeight)
                        .onChange(of: viewModel.isLayersViewOpen) { isShown in
                            if isShown {
                                headerViewHeight = .infinity
                                arrowRotation = 180
                            } else {
                                headerViewHeight = 50.0
                                arrowRotation = 0
                            }
                        }
                    
                    HStack {
                        Image(systemName: Constants.SystemIcons.layers)
                        Text(viewModel.selectedLayer.title)
                            .fonted(.body, weight: .semibold)
                            .lineLimit(2)

                        
                        Spacer()
                        Text("Select Layer", tableName: "MapsTab")
                            .fonted(.callout, weight: .semibold)
                            .lineLimit(2)
                        Image(systemName: Constants.SystemIcons.chevronDown)
                            .rotationEffect(.degrees(arrowRotation))
                            .animation(Constants.motionReduced ? nil : .linear(duration: 0.3), value: arrowRotation)
                        
                    }
                    .dynamicTypeSize(...DynamicTypeSize.large)
                    .frame(height: 50)
                    .padding(.horizontal, 14)
                }
                
            }
            .buttonStyle(PlainButtonStyle())
           
            
            LayerListView(viewModel: viewModel)
                .padding(.top, 50)
            
        }
        
        
    }
}


struct PlainButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .foregroundColor(.init(.secondary))
    }
}
