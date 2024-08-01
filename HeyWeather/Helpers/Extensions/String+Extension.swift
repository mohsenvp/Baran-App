//
//  String+Extension.swift
//  HeyWeather
//
//  Created by Kamyar on 10/10/21.
//

import Foundation
import CryptoSwift
import UIKit

extension String {
    
    //    var localized: String {
    //        return Text(LocalizedStringResource(stringLiteral: self))
    //    }
    //    static func localizedString(for key: String) -> String {
    //        return Text(LocalizedStringResource(stringLiteral: key))
    //    }
    
    var localized: String {
        var language: String = LocalizeHelper.shared.currentLanguage.rawValue
        if language == "pt" {
            language = "pt-PT"
        }
        guard let path = Bundle.main.path(forResource: language, ofType: "lproj") else {
            return Bundle.main.localizedString(forKey: self, value: "", table: nil)
        }
        
        return Bundle(path: path)!.localizedString(forKey: self, value: "", table: nil)
    }
    
    static func localizedString(for key: String) -> String {
        
        var language: String = LocalizeHelper.shared.currentLanguage.rawValue
        
        if language == "pt" {
            language = "pt-PT"
        }
        
        let path = Bundle.main.path(forResource: language, ofType: "lproj")!
        let bundle = Bundle(path: path)!
        let localizedString = NSLocalizedString(key, bundle: bundle, comment: "")
        
        return localizedString
    }
    
    var withoutLetters: String {
        
        return self.filter { !$0.isLetter && !$0.isWhitespace }.replacingOccurrences(of: "℃", with: "°").self.replacingOccurrences(of: "℉", with: "°")
    }
    
    var leadingWhiteSpaceIfOneCharacter: String {
        return self.replace("°", withString: "").count == 1 ? " \(self)" : self
    }
    var trailingWhiteSpaceIfOneCharacter: String {
        return self.replace("°", withString: "").count == 1 ? "\(self) " : self
    }
    
    var digits: String {
        return components(separatedBy: CharacterSet.decimalDigits.inverted)
            .joined()
    }
    
    func aesDecrypt(key: String, iv: String) -> String {
        let data = Data(base64Encoded: self)!
        do {
            let decrypted = try AES(key: key, iv: iv).decrypt([UInt8](data))
            let decryptedData = Data(decrypted)
            return String(bytes: decryptedData.bytes, encoding: .utf8) ?? "Could not decrypt"
        } catch {
            return String(data: data, encoding: .utf8) ?? ""
        }
    }
    
    func aesEncrypt(key: String, iv: String) throws -> String {
        let data = self.data(using: .utf8)!
        let encrypted = try AES(key: key, iv: iv).encrypt([UInt8](data))
        let encryptedData = Data(encrypted)
        return encryptedData.base64EncodedString()
    }
    
    func justChars()-> String {
        let allowedCharSet = NSCharacterSet.letters.union(.whitespaces)
        let filteredText = String(self.unicodeScalars.filter(allowedCharSet.contains))
        return filteredText
    }
    
    func replace(_ target: String, withString: String) -> String {
        return self.replacingOccurrences(of: target, with: withString, options: NSString.CompareOptions.literal, range: nil)
    }
    
    func widthOfString(usingFont font: UIFont) -> CGFloat {
        let fontAttributes = [NSAttributedString.Key.font: font]
        let size = self.size(withAttributes: fontAttributes)
        return size.width
    }
    
    func heightOfString(usingFont font: UIFont) -> CGFloat {
        let fontAttributes = [NSAttributedString.Key.font: font]
        let size = self.size(withAttributes: fontAttributes)
        return size.height
    }
    
    func sizeOfString(usingFont font: UIFont) -> CGSize {
        let fontAttributes = [NSAttributedString.Key.font: font]
        return self.size(withAttributes: fontAttributes)
    }

}
