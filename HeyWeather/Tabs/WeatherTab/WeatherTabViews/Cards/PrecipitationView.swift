//
//  PrecipitationView.swift
//  HeyWeather
//
//  Created by Kamyar on 1/17/22.
//

import SwiftUI

struct PrecipitationView: View {
    var precipitation: Precipitation
    var onTrackClicked: () -> Void
    @ObservedObject var liveActivity = LiveActivityAgent.shared
    @EnvironmentObject var premium: Premium
    @Environment(\.isSubscriptionViewPresented) var isSubscriptionViewPresented
    @AppStorage(Constants.precipitationUnitString, store: Constants.groupUserDefaults) var unit: PrecipitationUnit = Constants.defaultPrecipitationUnit

   
    var body: some View {
        VStack {
            Text(precipitation.description)
                .fonted(.footnote, weight: .medium)
                .opacity(Constants.primaryOpacity)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, 16)
                .padding(.top, 12)
            
            PrecipitationChart(data: precipitation.chartData)
                .frame(height: 120)
                .padding(.leading, 16)
                .padding(.trailing, 14)
                .padding(.top, 4)
                .accessibilityHidden(true)
            
            if #available(iOS 16.1, *) {
                Button {
                    if !premium.isPremium {
                        isSubscriptionViewPresented.wrappedValue.toggle()
                        return
                    }
                    onTrackClicked()
                } label: {
                    PrecipitationTrackView(
                        isTrackingCurrentCity: liveActivity.isTrackingCurrentCity(),
                        isLoading: liveActivity.activityPushTokenLoading
                    )
                }
            }else {
                Rectangle().fill(.clear).frame(height: 10)
            }
            
        }
        .dynamicTypeSize(...DynamicTypeSize.large)
        .weatherTabShape(horizontalPadding: false, verticalPadding: false)
        .accessibilityElement(children: .combine)
    }
}

private struct PrecipitationTrackView: View {
    
    var isTrackingCurrentCity: Bool = false
    var isLoading: Bool = false
    
    var body: some View {
        HStack(spacing: 4){
            Spacer(minLength: 12)
            
            Image(systemName: Constants.SystemIcons.clockLiveActivity)
                .fonted(.body, weight: .medium)
                .foregroundColor(.accentColor)
                .padding(2)
                .drawLineOver(shouldDraw: isTrackingCurrentCity)
                .isIconloading(isLoading)
            
            Group {
                if isTrackingCurrentCity {
                    Text("Stop Tracking Precipitation in Live Activty", tableName: "LiveActivty")
                }else{
                    Text("Track Precipitation in Live Activity", tableName: "LiveActivty")
                }
            }
            .fonted(.body, weight: .medium).foregroundColor(.accentColor)
            Spacer(minLength: 12)
        }
        .padding(EdgeInsets(top: 4, leading: 0, bottom: 12, trailing: 0))
    }
}

struct PrecipitationView_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            Image(systemName: Constants.SystemIcons.clockLiveActivity)
                .fonted(.body, weight: .medium)
                .foregroundColor(.accentColor)
            
                Capsule()
                .strokeBorder(.white, lineWidth: 1)
                .background(Capsule().fill(Color.accentColor).padding(1))
                .frame(width: 24, height: 4)
                .rotationEffect(Angle(degrees: 45))
        }
    }
}
