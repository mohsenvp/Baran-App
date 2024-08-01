//
//  CGFloat+Extension.swift
//  HeyWeather
//
//  Created by Kamyar on 10/10/21.
//

import Foundation
import UIKit
import WidgetKit


extension CGFloat {
    
    func getWidgetSize(for widgetType:WidgetFamily) -> CGSize {
        switch widgetType {
        case .systemSmall:
            switch self {
            case 932:   return CGSize(width:170, height: 170)
            case 926:   return CGSize(width:170, height: 170)
            case 896:   return CGSize(width:169, height: 169)
            case 736:   return CGSize(width:159, height: 159)
            case 852:   return CGSize(width:158, height: 158)
            case 844:   return CGSize(width:158, height: 158)
            case 812:   return CGSize(width:155, height: 155)
            case 667:   return CGSize(width:148, height: 148)
            case 780:   return CGSize(width:155, height: 155)
            case 568:   return CGSize(width:141, height: 141)
            default:    return CGSize(width:170, height: 170)
            }
        case .systemMedium:
            switch self {
            case 932:   return CGSize(width:364, height: 170)
            case 926:   return CGSize(width:364, height: 170)
            case 896:   return CGSize(width:360, height: 169)
            case 736:   return CGSize(width:348, height: 159)
            case 852:   return CGSize(width:338, height: 158)
            case 844:   return CGSize(width:338, height: 158)
            case 812:   return CGSize(width:329, height: 155)
            case 667:   return CGSize(width:321, height: 148)
            case 780:   return CGSize(width:329, height: 155)
            case 568:   return CGSize(width:292, height: 141)
            default:    return CGSize(width:364, height: 170)
            }
        case .systemLarge:
            switch self {
            case 932:   return CGSize(width:364, height: 382)
            case 926:   return CGSize(width:364, height: 382)
            case 896:   return CGSize(width:360, height: 379)
            case 736:   return CGSize(width:348, height: 357)
            case 852:   return CGSize(width:338, height: 354)
            case 844:   return CGSize(width:338, height: 354)
            case 812:   return CGSize(width:329, height: 345)
            case 667:   return CGSize(width:321, height: 324)
            case 780:   return CGSize(width:329, height: 345)
            case 568:   return CGSize(width:292, height: 311)
            default:    return CGSize(width:364, height: 382)
            }
            
        default:
            return CGSize(width:329, height: 345)
        }
    }
    
   
    
    func between(a: CGFloat, b: CGFloat) -> Bool {
        return self >= Swift.min(a, b) && self <= Swift.max(a, b)
    }
}
