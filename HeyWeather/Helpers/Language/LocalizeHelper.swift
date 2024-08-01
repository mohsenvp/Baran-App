//
//  LocalizeHelper.swift
//  HeyWeather
//
//  Created by Kamyar on 10/26/21.
//

import Foundation

class LocalizeHelper: ObservableObject {
    static var shared = LocalizeHelper()
    
    static func reset() {
        shared = LocalizeHelper()
    }
    
    @Published var currentLanguage: AppLanguage {
        didSet {
            UserDefaults.save(value: currentLanguage, for: .currentLanguage)
        }
    }
    @Published var isAlertPresented: Bool = false
    @Published var localeLang: String
    @Published var lastLocale: String = "" {
        didSet {
            UserDefaults.save(value: lastLocale, for: .lastLocale)
        }
    }
    
    func setLanguage(language: AppLanguage) {
        guard currentLanguage != language else { return }
        self.currentLanguage = language
        self.lastLocale = localeLang
        UserDefaults.standard.set([language.rawValue], forKey: "AppleLanguages")
        NetworkManager.reset()
    }
    
    
    init() {
        let currentLocaleIdentifer = Locale.current.identifier
        let currentLocaleId = currentLocaleIdentifer.components(separatedBy: "_").first ?? ""
        let lastLocaleId = UserDefaults.get(for: .lastLocale) ?? ""
        let currentLang: AppLanguage = UserDefaults.get(for: .currentLanguage) ?? .english
        let currentLangId = currentLang.rawValue
        
        self.localeLang = currentLocaleId
        
        if currentLocaleId != lastLocaleId {
            self.lastLocale = lastLocaleId
            if currentLocaleId != currentLangId && !currentLangId.isEmpty {
                self.isAlertPresented = true
            }
        }
        
        if let currentLanguage: AppLanguage = UserDefaults.get(for: .currentLanguage) {
            self.currentLanguage = currentLanguage
        } else {
            self.currentLanguage = .init(rawValue: currentLocaleId)
        }
    }
}
