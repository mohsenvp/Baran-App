//
//  DottedLine.swift
//  HeyWeather
//
//  Created by Reza Ranjbaran on 08/05/2023.
//

import Foundation
import SwiftUI

struct DottedLine: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: 0, y: rect.height / 2))
        path.addLine(to: CGPoint(x: rect.width, y: rect.height / 2))
        return path
    }
}
