//
//  TimeLineView.swift
//  HeyWeather
//
//  Created by mohamd yeganeh on 5/4/23.
//

import SwiftUI

struct TimeLineView: View {
    @ObservedObject var viewModel: MapViewModel
    @EnvironmentObject var premium : Premium
    @Environment(\.isSubscriptionViewPresented) var isSubscriptionViewPresented

    let timer = Timer.publish(every: 0.5, on: .main, in: .common).autoconnect()
    
    @State var progress: Float = 0.0
    var body: some View {
        ZStack {
            
            RoundedRectangle(cornerRadius: 14)
                .strokeBorder(Color.init(.label).opacity(0.2), lineWidth: 1)
                .background(RoundedRectangle(cornerRadius: 14).fill(Color.init(.systemBackground).opacity(Constants.primaryOpacity)))
            
            if viewModel.mapData.steps.count > 0 {
                HStack {
                    
                    Button {
                        viewModel.isPlayed.toggle()
                    } label: {
                        ZStack {
                            Image(systemName: viewModel.isPlayed ? Constants.SystemIcons.pause : Constants.SystemIcons.play)
                                .fonted(.title3, weight: .regular)
                        }
                        .frame(width: 24, height: 24)
                    }
                    .accentColor(.init(.secondaryLabel))
                    
                    Slider(value: $progress, in: 0...Float(viewModel.mapData.steps.count - 1), step: 1) {

                    } minimumValueLabel: {
                        Text(viewModel.mapData.from.shortLocalizedString)
                            .fonted(.footnote, weight: .semibold)
                            .foregroundColor(.init(.secondaryLabel))
                    } maximumValueLabel: {
                        Text(viewModel.mapData.to.shortLocalizedString)
                            .fonted(.footnote, weight: .semibold)
                            .foregroundColor(.init(.secondaryLabel))
                    }
                    
                }.padding(.horizontal, 12)
            }else {
                Button {
                    viewModel.loadTimeLineData()
                } label: {
                    Text("Tap to Load Timeline Data", tableName: "MapsTab")
                        .fonted(.footnote, weight: .semibold)
                        .foregroundColor(.init(.secondaryLabel))
                }

            }
            
            
            if !premium.isPremium && viewModel.selectedLayer.isPlayLocked {
                Button {
                    isSubscriptionViewPresented.wrappedValue.toggle()
                } label: {
                    TimeLinePremiumOverlay()
                }
            }
            
        }
        .onChange(of: progress, perform: { timestampIndex in
            viewModel.date = Date(timeIntervalSince1970: viewModel.mapData.steps[Int(progress)])
            viewModel.newTimeStampSelected = true
        })
        .onReceive(timer) { _ in
            if (viewModel.isPlayed) {
                if progress == Float(viewModel.mapData.steps.count - 1) {
                    progress = 0
                }else {
                    progress += 1
                }
            }
        }
        .frame(height: 50)
    }
}

private struct TimeLinePremiumOverlay: View {
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 14)
                .fill(Constants.accentRadialGradient)
            VStack(spacing: -4){
                Text("Forecasts are", tableName: "MapsTab")
                    .fonted(.caption, weight: .light)
                    .foregroundColor(.white)
                
                Text("Premium", tableName: "Premium")
                    .fonted(.title3, weight: .bold)
                    .foregroundColor(.white)
            }
            
        }
    }
}
