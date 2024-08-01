//
//  SettingsTab.swift
//  HeyWeather
//
//  Created by Kamyar on 10/27/21.
//

import SwiftUI

struct SettingsTab: View {
    @StateObject var viewModel = SettingsTabViewModel()
    @Environment(\.isSubscriptionViewPresented) var isSubscriptionViewPresented
    
    var body: some View {
        let sectionOneRows: [SettingsRowType] = [.dataSources, .userNotificationConfig]
        let sectionTwoRows: [SettingsRowType] = [.appUnits, .timeFormat, .appearance, .appIcon, .language]
        let sectionThreeRows: [SettingsRowType] = [.reddit, .twitter]
        let sectionTFourRows: [SettingsRowType] = [.aboutUs, .contactUs, .share, .review]
        NavigationStack {
            ZStack {
                Color(.systemGroupedBackground).edgesIgnoringSafeArea(.all)
                ScrollView(showsIndicators: false){
                    VStack {
                        TopSection(currentAppIcon: $viewModel.currentAppIcon)
                        Button {
                            isSubscriptionViewPresented.wrappedValue.toggle()
                        } label: {
                            PremiumRow()
                        }
                        .buttonStyle(.plain)
                        SettingsSection(rows: sectionOneRows)
                        SettingsSection(rows: sectionTwoRows)
                        SettingsSection(rows: sectionThreeRows)
                        SettingsSection(rows: sectionTFourRows)
                        AboutSection()
                    }.padding()
                }
                .navigationTitle(Text("Settings", tableName: "TabItems"))
                .navigationViewStyle(.automatic)
                .onAppear {
                    viewModel.logView()
                    viewModel.refreshAppIcon()
                }
            }
        }
        .navigationViewStyle(.stack)
    }
    
    private struct TopSection: View {
        private let shortVersion = Bundle.main.infoDictionary!["CFBundleShortVersionString"] as! String
        private let buildNumber = Bundle.main.infoDictionary!["CFBundleVersion"] as! String
        @Binding var currentAppIcon: Int
        
        var body: some View {
            HStack(spacing: 0) {
                Image("AppIcon-\(currentAppIcon)-preview")
                    .resizable()
                    .frame(width: 100, height: 100)
                    .cornerRadius(20)
                    .padding(.trailing)
                    .accessibilityHidden(true)
                VStack(alignment: .leading, spacing: 5) {
                    
                    Text("HeyWeather")
                        .fonted(.title3, weight: .bold)
                        .accessibilityHidden(true)
                    
                    Text("Version (\(shortVersion))", tableName: "SettingsTab")
                        .opacity(Constants.secondaryOpacity)
                        .fonted(.subheadline, weight: .regular)
                }
                Spacer()
            }.padding(.vertical)
        }
    }
    
    private struct PremiumRow: View {
        @Environment(\.dynamicTypeSize) var typeSize
        @EnvironmentObject var premium: Premium
        var body: some View {
            HStack {
                if typeSize < .xxLarge {
                    Image(Constants.Icons.premium)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 30, height: 30)
                        .padding()
                }
                
                VStack(alignment: .leading) {
                    if premium.isPremium {
                        
                        Text("You Are Premium", tableName: "Premium")
                            .fonted(.body, weight: .medium)
                        Group {
                            (premium.autoRenew ? Text("Renew at", tableName: "Premium") : Text("Expire at", tableName: "Premium")) +
                            Text(Constants.colonAndSpace) +
                            (premium.isLifetime ? Text("Never", tableName: "Premium") : Text(premium.expireAt).fontWeight(.medium))
                        }
                        .fonted(.callout)
                        .lineLimit(1)
                        .minimumScaleFactor(0.01)
                        .opacity(Constants.secondaryOpacity)
                    }else {
                        
                        Text("Premium Plan", tableName: "Premium")
                            .fonted(.body, weight: .medium)
                        
                        HStack(spacing: 2){
                            Text("Try Premium", tableName: "Premium")
                                .opacity(Constants.secondaryOpacity)
                                .fonted(.body, weight: .regular)
                                .lineLimit(1)
                                .minimumScaleFactor(0.8)
                            
                            Text("FREE!", tableName: "Premium")
                                .fonted(.body, weight: .bold)
                                .opacity(Constants.secondaryOpacity)
                                .lineLimit(1)
                                .minimumScaleFactor(0.8)
                        }
                        
                    }
                }
                Spacer()
                Image(systemName: Constants.SystemIcons.chevronRight)
                    .fonted(.headline, weight: .regular)
                    .flipsForRightToLeftLayoutDirection(true)

            }
            .foregroundColor(.white)
            .padding()
            .background(Constants.accentGradient)
            .cornerRadius(20)
        }
    }
    
    private struct SettingsSection: View {
        @Environment(\.colorScheme) var colorScheme: ColorScheme
        let rows: [SettingsRowType]
        var body: some View {
            VStack {
                ForEach(rows, id: \.self) { row in
                    if row.rawValue == rows.first?.rawValue {
                        Divider().opacity(0)
                    }
                    SettingsRow(rowType: row)
                        .padding(.horizontal, 2.5)
                        .padding(.vertical, -10)
                    if row.rawValue == rows.last?.rawValue {
                        Divider().opacity(0)
                    } else {
                        Divider().padding(.leading).padding(.leading, 45)
                    }
                }
            }
            .background(Color(colorScheme == .light ? .tertiarySystemBackground : .secondarySystemBackground))
            .cornerRadius(20)
            .padding(.top)
        }
    }
    
    private struct AboutSection: View {
        var body: some View {
            VStack(spacing: 4){
                Text("SETTINGS.FOOTER", tableName: "SettingsTab")
                    .multilineTextAlignment(.center)
                    .foregroundColor(.init(.secondaryLabel))
                    .fonted(.footnote, weight: .regular)
                Image(Constants.Icons.gcoLogo)
                    .resizable()
                    .frame(width: 12, height: 12)
                    .scaledToFit()
            }
            .padding(.top, 4)
        }
    }
}


#if DEBUG
struct SettingsTab_Previews: PreviewProvider {
    static let premium = Premium()
    static var previews: some View {
        SettingsTab()
            .environmentObject(premium)
    }
}
#endif

