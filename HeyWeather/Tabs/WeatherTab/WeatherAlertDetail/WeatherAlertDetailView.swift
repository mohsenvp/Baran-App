//
//  WeatherAlertView.swift
//  HeyWeather
//
//  Created by Mohammad Yeganeh on 10/7/23.
//

import Foundation
import SwiftUI

struct WeatherAlertDetailView: View {
    @State var alerts: [WeatherAlert]
    @Environment(\.presentationMode) var presentationMode
    @Environment(\.colorScheme) var colorScheme: ColorScheme

    var body: some View {
        ScrollView(showsIndicators: false){
            VStack(spacing: 12){

                ForEach(0..<alerts.count, id: \.self) { i in
                    Button {
                        withAnimation(.linear(duration: Constants.motionReduced ? 0.0 : 0.35)) {
                            alerts[i].toggleExpantion()
                        }
                    } label: {
                        AlertItem(alert: alerts[i])
                    }
                    .buttonStyle(.plain)
                }
                Spacer()
            }
            .padding(.vertical)
        }
        .background(Color(colorScheme == .light ? .secondarySystemBackground : .systemBackground))
        .navigationTitle(Text("Alerts", tableName: "WeatherAlerts"))
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
                withAnimation(.linear(duration: Constants.motionReduced ? 0.0 : 0.35)) {
                    alerts[0].toggleExpantion()
                }
            })
        }
    }
}

private struct AlertItem: View {
    let alert: WeatherAlert
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0){
            
            HStack {
                Image(systemName: Constants.SystemIcons.chevronDown)
                    .rotationEffect(.degrees(alert.expanded ? 180 : 0))
                    .animation(.linear(duration: 0.2), value: alert.expanded)
                    .padding(.horizontal, 8)
                    .accessibilityHidden(true)
                
                VStack(alignment: .leading, spacing: 2){
                    Text(alert.event ?? "")
                        .fonted(.callout, weight: .semibold)
                        .lineLimit(1)
                    
                    Text("\(alert.starts?.shortLocalizedString ?? ""), \(alert.starts?.toUserTimeFormatWithMinuets() ?? "") \(Constants.dash) \(alert.ends?.shortLocalizedString ?? ""), \(alert.ends?.toUserTimeFormatWithMinuets() ?? "")")
                        .fonted(.caption2, weight: .regular)
                        .foregroundStyle(.secondary)
                        .lineLimit(1)
                }
                
                Spacer()
                PulseView(pulseColor: Color(hex: alert.color ?? Constants.defaultAlertColorCode))
                    .frame(width: 40, height: 40)
                    .accessibilityHidden(true)
            }
            .padding(8)
            
            if alert.expanded {
                VStack(alignment: .leading, spacing: 12){
                    
                    HStack {
                        Text("Start:", tableName: "WeatherAlerts")
                            .fonted(.callout, weight: .bold)
                            .frame(width: 55, alignment: .leading)
                            .minimumScaleFactor(0.9)
                            .lineLimit(1)
                        
                        Text("\(alert.starts?.shortWeekday ?? "") \(alert.starts?.shortLocalizedString ?? "") \(Constants.dash) \(alert.starts?.toUserTimeFormatWithMinuets() ?? "")")
                            .fonted(.callout, weight: .bold)
                    }
                    
                    HStack {
                        Text("End:", tableName: "WeatherAlerts")
                            .fonted(.callout, weight: .bold)
                            .frame(width: 55, alignment: .leading)
                            .minimumScaleFactor(0.9)
                            .lineLimit(1)
                        Text("\(alert.ends?.shortWeekday ?? "") \(alert.ends?.shortLocalizedString ?? "") \(Constants.dash) \(alert.ends?.toUserTimeFormatWithMinuets() ?? "")")
                            .fonted(.callout, weight: .bold)
                    }
                    
                    if (alert.headline != nil || alert.description != nil) {
                        Divider()
                    }
                    
                    if alert.headline != nil  {
                        Text(alert.headline!)
                            .fonted(.callout, weight: .bold)
                    }
                    if alert.description != nil {
                        Text(alert.description!)
                            .fonted(.callout, weight: .regular)
                            .opacity(Constants.pointSevenOpacity)
                    }
                    
                    if alert.severity != nil {
                        Divider()
                        AlertPropertyItem(
                            title: Text("Severity:", tableName: "WeatherAlerts"),
                            value: alert.severity?.type ?? "",
                            description: alert.severity?.description ?? "",
                            color: Color(hex: alert.color ?? Constants.defaultAlertColorCode)
                        )
                    }
                    
    
                    if alert.urgency != nil {
                        Divider()
                        AlertPropertyItem(
                            title: Text("Urgency:", tableName: "WeatherAlerts"),
                            value: alert.urgency?.type ?? "",
                            description: alert.urgency?.description ?? ""
                        )
                    }
                    
                    
                    if alert.response != nil {
                        Divider()
                        AlertPropertyItem(
                            title: Text("Response:", tableName: "WeatherAlerts"),
                            value: alert.response?.type ?? "",
                            description: alert.response?.description ?? ""
                        )
                    }
                    
                    
                    if alert.instruction != nil {
                        Divider()
                        AlertSimplePropertyItem(title: Text("Instructions:", tableName: "WeatherAlerts"), description: alert.instruction!)
                    }
                    
                    
                    if alert.area != nil {
                        Divider()
                        AlertSimplePropertyItem(title: Text("Areas:", tableName: "WeatherAlerts"), description: alert.area!)
                    }
                    
                    if alert.senderName != nil {
                        Divider()
                        Text("Sender: \(alert.senderName!)", tableName: "WeatherAlerts")
                            .fonted(.body, weight: .regular)
                            .foregroundStyle(.secondary)
                    }
                    
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 20)
                
            }
        }
        .weatherTabShape(horizontalPadding: false, verticalPadding: false)
        .padding(.horizontal)
    }
    
}

private struct AlertPropertyItem: View {
    
    let title: Text
    let value: String
    let description: String
    var color: Color = Color(.label)
    
    var body: some View {
        VStack(alignment: .leading){
            
            HStack(alignment: .top) {
                title
                    .fonted(.callout, weight: .bold)
                
                Text(value)
                    .fonted(.callout, weight: .bold)
                    .foregroundStyle(color)
            }
            
            Text(description)
                .fonted(.body, weight: .regular)
                .foregroundStyle(.secondary)
        }
    }
}

private struct AlertSimplePropertyItem: View {
    
    let title: Text
    let description: String
    var body: some View {
        VStack(alignment: .leading) {
            title
                .fonted(.callout, weight: .bold)
            
            Text(description)
                .fonted(.body, weight: .regular)
                .foregroundStyle(.secondary)
        }
    }
}

