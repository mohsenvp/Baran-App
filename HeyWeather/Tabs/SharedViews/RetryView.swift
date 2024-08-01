//
//  RetryView.swift
//  HeyWeather
//
//  Created by Mohammad Yeganeh on 6/24/23.
//

import SwiftUI

struct RetryView: View {
    var latestCacheDate: Date?
    var networkFailResponse: NetworkFailResponse?
    var onRetry: () -> Void
    var onLoadFromCache: () -> Void
    var body: some View {
        ZStack {
            Blur().edgesIgnoringSafeArea(.all)
            
            VStack {
                Spacer()
                
                Image(systemName: Constants.SystemIcons.wifiSlash)
                    .font(.title)
                    .padding()
                
                
                Strings.NetworkAlerts.getNetworkMessage(for: networkFailResponse ?? .noInternet)
                    .fonted(.body, weight: .regular)
                    .multilineTextAlignment(.center)
                    .lineSpacing(6)
                    .padding(.horizontal)
                
                Spacer()
                
                Button {
                    onRetry()
                } label: {
                    Text("Tap to Retry", tableName: "Alerts")
                }.accentColor(.init(.label))
                
                
                Spacer()
                
                if latestCacheDate != nil {
                    HStack {
                        Image(systemName: Constants.SystemIcons.clockArrowCircle)
                        VStack(alignment: .leading){
                            Text("View Data from", tableName: "Alerts")
                                .fonted(.caption2, weight: .light)
                            Text(latestCacheDate?.relativeToNow ?? "")
                                .fonted(.subheadline, weight: .semibold)
                        }
                    }
                    .padding()
                    .overlay(
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(Color.init(.label), lineWidth: 1.5)
                    )
                    .onTapGesture {
                        onLoadFromCache()
                    }
                    Spacer()
                }
               
                
            }
            
        }
    }
}
