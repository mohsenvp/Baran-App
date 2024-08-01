//
//  SettingsRow.swift
//  HeyWeather
//
//  Created by Kamyar on 11/10/21.
//

import SwiftUI

struct SettingsRow: View {
    var rowType: SettingsRowType
    var body: some View {
        let isButton: Bool = rowType == .share || rowType == .review || rowType == .aboutUs || rowType == .contactUs  || rowType == .reddit  || rowType == .twitter
        if isButton {
            ButtonSettingsRow(rowType: rowType)
        } else {
            NavigationLinkSettingsRow(rowType: rowType)
        }
        
    }
}

#if DEBUG
struct SettingsRow_Previews: PreviewProvider {
    static var previews: some View {
        let rowType: SettingsRowType = .contactUs
        SettingsRow(rowType: rowType)
    }
}
#endif
