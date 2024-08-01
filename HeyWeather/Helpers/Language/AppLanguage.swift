//
//  AppLanguage.swift
//  HeyWeather
//
//  Created by Kamyar on 10/26/21.
//

import Foundation

enum AppLanguage: String, Identifiable, CaseIterable, Codable {
    var id: String { return UUID().uuidString }
    case english = "en"
    case french = "fr"
    case spanish = "es"
    case german = "de"
    case dutch = "nl"
    case italian = "it"
    case portuguese = "pt"
    case russian = "ru"
    case chinese = "zh-Hans"
    case chinese_t = "zh-Hant"
    case japanese = "ja"
    case korean = "ko"
    case hindi = "hi"
    case turkish = "tr"
    case arabic = "ar"
    case greek = "el"
    case hebrew = "he"
    case persian = "fa"
    case thai = "th"
    
    var displayName: String {
        if let identifier = (Locale.init(identifier: "en_US") as NSLocale).displayName(forKey: .identifier, value: self.rawValue) {
            return identifier
        }
        return self.rawValue
    }
    
    var isRTL: Bool {
        switch self {
        case .arabic,.persian,.hebrew:
            return true
        default:
            return false
        }
    }
    
    var toServerName: String {
        switch self {
        case .chinese:
            return "zh_cn"
        case .chinese_t:
            return "zh_tw"
        case .korean:
            return "kr"
        default: return self.rawValue
        }
    }
    
    init(rawValue: String) {
        switch rawValue {
        case "en": self = .english
        case "fr": self = .french
        case "es": self = .spanish
        case "de": self = .german
        case "nl": self = .dutch
        case "it": self = .italian
        case "pt": self = .portuguese
        case "ru": self = .russian
        case "zh_cn":
            UserDefaults.save(value: AppLanguage.chinese, for: .currentLanguage)
            self = .chinese
        case "zh-Hans": self = .chinese
        case "zh-Hant": self = .chinese_t
        case "ja": self = .japanese
        case "ko": self = .korean
        case "hi": self = .hindi
        case "tr": self = .turkish
        case "ar": self = .arabic
        case "el": self = .greek
        case "he": self = .hebrew
        case "fa": self = .persian
        case "th": self = .thai
            
        default: self = .english
        }
    }
}
