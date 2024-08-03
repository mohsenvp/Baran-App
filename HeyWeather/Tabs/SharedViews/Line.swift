//
//  Line.swift
//  HeyWeather
//
//  Created by Mohammad Yeganeh on 7/30/23.
//

import SwiftUI

struct Line: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: rect.minX, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.width, y: rect.minY))
        return path
    }
}
