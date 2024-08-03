//
//  UIApplication+Extension.swift
//  HeyWeather
//
//  Created by Mohammad Yeganeh on 7/11/23.
//

import UIKit
extension UIApplication {
    var statusBarHeight: CGFloat {
        connectedScenes
            .compactMap {
                $0 as? UIWindowScene
            }
            .compactMap {
                $0.statusBarManager
            }
            .map {
                $0.statusBarFrame
            }
            .map(\.height)
            .max() ?? 0
    }
}
