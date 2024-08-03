//
//  SettingsRowLabel.swift
//  HeyWeather
//
//  Created by Kamyar on 11/16/21.
//

import SwiftUI

struct SettingsRowLabel: View {
    let rowType: SettingsRowType
    @State var currentLanguage: String = .init()
    @State var currentDataSource: String = .init()
    @State var appearance: LocalizedStringKey = .init(AppAppearance.auto.rawValue)
    @State var timeFormat: String = .init()
    @ObservedObject var localizeHelper = LocalizeHelper.shared

    var body: some View {
        HStack {
            
            // This is not very good, can be written better!
            Group {
                if (rowType == .twitter) {
                    Constants.Icon(for: rowType)
                        .resizable()
                }else if (rowType == .reddit) {
                    Constants.Icon(for: rowType)
                        .resizable()
                        .foregroundColor(Constants.redditColorCode)
                }else {
                    Constants.Icon(for: rowType)
                        .resizable()
                        .renderingMode(.original)
                }
            }
            .padding(5)
            .frame(width: 30, height: 30)
            .scaledToFit()
            .padding(.leading, 5)
            
            Strings.SettingsTab.getTitle(for: rowType)
                .fonted(.body, weight: .regular)
                .padding(.horizontal, 2.5).padding(.vertical)
            
            Spacer(minLength: 0)
            
            Group {
                switch rowType {
                case .dataSources:
                    EmptyView()
                case .timeFormat:
                    Text(timeFormat)
                case .language:
                    Text(currentLanguage)
                case .appearance:
                    Text(appearance)
                default:
                    EmptyView()
                }
            }
            .lineLimit(1)
            .minimumScaleFactor(0.8)
            .fonted(.callout, weight: .regular)
            .opacity(Constants.secondaryOpacity)
            if (rowType != .share && rowType != .review && rowType != .aboutUs && rowType != .contactUs && rowType != .reddit && rowType != .twitter) {
                Image(systemName: Constants.SystemIcons.chevronRight)
                    .foregroundColor(Constants.accentColor)
                    .padding(.trailing)
                    .flipsForRightToLeftLayoutDirection(true)
                    .fonted(.callout, weight: .semibold)
            }
        }
        .foregroundColor(Color(.label))
        .onReceive(Constants.shouldUpdateWeatherPublisher) { _ in
            self.currentLanguage = getCurrentLanguage()
        }
        .onAppear {
//            self.currentDataSource = DataSourceAgent.getCurrentDataSourceTitle()
            self.currentLanguage = getCurrentLanguage()
            self.appearance = getAppearance()
            self.timeFormat = getValue(for: .timeFormat)
        }
    }
    
    private func getValue(for rowType: SettingsRowType) -> String {
        switch rowType {
        case .timeFormat:
            return TimeFormat.getUserTimeFormat().rawValue
        default:
            return Constants.none
        }
    }
    
    private func getAppearance() -> LocalizedStringKey {
        if let appearance: AppAppearance = UserDefaults.get(for: .appAppearance) {
            return LocalizedStringKey(appearance.rawValue)
        } else { return LocalizedStringKey(AppAppearance.auto.rawValue) }
    }
    
    private func getCurrentLanguage() -> String {
        let locale = LocaleManager.shared.currentLocale
        let currentLanguageFull = locale.localizedString(forLanguageCode: locale.identifier)?.capitalized ?? ""
        return currentLanguageFull
    }
    
    
}

#if DEBUG
struct SettingsRowLabel_Previews: PreviewProvider {
    static var previews: some View {
        let rowType: SettingsRowType = .contactUs
        SettingsRowLabel(rowType: rowType)
    }
}
#endif
