//
//  LocaleManager.swift
//  HeyWeather
//
//  Created by Kamyar on 2/13/22.
//

import Foundation

class LocaleManager {
    static let shared: LocaleManager = .init()
    
    var currentLocale: Locale {
        let currentLocaleId = LocalizeHelper.shared.currentLanguage.rawValue
        let currentLocale = Locale(identifier: currentLocaleId)
        return currentLocale
    }
    
    var englishLocale: Locale {
        let locale: Locale = .init(identifier: "en")
        return locale
    }
}
