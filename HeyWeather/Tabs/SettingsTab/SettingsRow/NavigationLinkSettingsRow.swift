//
//  NavigationLinkSettingsRow.swift
//  HeyWeather
//
//  Created by Kamyar on 11/16/21.
//

import SwiftUI

struct NavigationLinkSettingsRow: View {
    @EnvironmentObject var premium: Premium
    let rowType: SettingsRowType
    var body: some View {
        NavigationLink {
            SingleSettingsView(viewModel: SingleSettingsViewModel(type: rowType, isPremium: premium.isPremium))
        } label: {
            SettingsRowLabel(rowType: rowType)
        }
    }
}
