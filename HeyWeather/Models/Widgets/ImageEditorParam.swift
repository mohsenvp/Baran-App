//
//  ImageEditorParam.swift
//  HeyWeather
//
//  Created by Mohammad Yeganeh on 10/16/23.
//

import Foundation
enum ImageEditorParam: String {
    case blur
    case contrast
    case saturation
    case brightness
    
    var min: CGFloat {
        switch self {
        case .blur:
            0.0
        case .contrast:
            0.0
        case .saturation:
            0.0
        case .brightness:
            -1.0
        }
    }
    
    var max: CGFloat {
        switch self {
        case .blur:
            100.0
        case .contrast:
            2.0
        case .saturation:
            2.0
        case .brightness:
            1.0
        }
    }
}
