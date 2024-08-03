//
//  UIColor+Extension.swift
//  HeyWeather
//
//  Created by Kamyar on 10/11/21.
//

import Foundation
import UIKit

extension UIColor {
    func toHexString() -> String {
        let color = self
        let components = color.cgColor.components
        let r: CGFloat = components?[0] ?? 0.0
        let g: CGFloat = components?[1] ?? 0.0
        let b: CGFloat = components?[2] ?? 0.0
        
        let hexString = String.init(format: "#%02lX%02lX%02lX", lroundf(Float(r * 255)), lroundf(Float(g * 255)), lroundf(Float(b * 255)))
        return hexString
    }
    
    var hexString: String? {
            var red: CGFloat = 0
            var green: CGFloat = 0
            var blue: CGFloat = 0
            var alpha: CGFloat = 0

            let multiplier = CGFloat(255.999999)

            guard self.getRed(&red, green: &green, blue: &blue, alpha: &alpha) else {
                return nil
            }

            if alpha == 1.0 {
                return String(
                    format: "#%02lX%02lX%02lX",
                    Int(red * multiplier),
                    Int(green * multiplier),
                    Int(blue * multiplier)
                )
            }
            else {
                return String(
                    format: "#%02lX%02lX%02lX%02lX",
                    Int(red * multiplier),
                    Int(green * multiplier),
                    Int(blue * multiplier),
                    Int(alpha * multiplier)
                )
            }
        }
    
    
    func isDark() -> Bool {
            var red: CGFloat = 0, green: CGFloat = 0, blue: CGFloat = 0
            guard getRed(&red, green: &green, blue: &blue, alpha: nil) else {
                return false
            }
            
            let lum = 0.2126 * red + 0.7152 * green + 0.0722 * blue
            return lum < 0.5
        }
}
