//
//  Double+Extension+2.swift
//  HeyWeather
//
//  Created by Reza Ranjbaran on 24/11/2023.
//

import Foundation
import SwiftUI


extension Double {
    func maxFractionDigit(to fractionDigits: Int) -> Double {
        let divisor = pow(10.0, Double(fractionDigits))
        return (self * divisor).rounded() / divisor
    }
}
