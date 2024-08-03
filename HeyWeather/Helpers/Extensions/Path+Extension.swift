//
//  Path+Extension.swift
//  HeyWeather
//
//  Created by Kamyar on 10/20/21.
//

import SwiftUI

extension Path {
    
    func drawPath(points: [CGPoint], smooth : Bool) -> Path {
        
        var path : Path = Path()
        var oldControlP: CGPoint?
        
        for i in 1..<points.count - 1 {
            if i == 1 {
                path.move(to: points[1])
            }else {
                let p1 = points[i - 1]
                let p2 = points[i]
                let p3 = points[i + 1]
                
                if (smooth) {
                    let newControlP = controlPointForPoints(p1: p1, p2: p2, next: p3)
                    path.addCurve(to: p2, control1: oldControlP ?? p1, control2: newControlP ?? p2)
                    oldControlP = antipodalFor(point: newControlP, center: p2)
                } else {
                    path.addLine(to: points[i])
                }
                
            }
            
        }
        return SecondLinePath(points: points, path: path)
    }
    
    
    func SecondLinePath(points: [CGPoint], path: Path) -> Path {
        var newPath : Path = Path()
        newPath.addPath(path)
        
        newPath.addLine(to: CGPoint(x: points[points.count-2].x, y: points[points.count-2].y))
        newPath.addLine(to: CGPoint(x: points[points.count-2].x + 1000, y: points[points.count-2].y))
        newPath.addLine(to: CGPoint(x: points[points.count-2].x + 1000, y: -10))
        newPath.addLine(to: CGPoint(x: -100, y: -10))
        newPath.closeSubpath()
        
        return newPath
    }
    
    private func controlPointForPoints(p1: CGPoint, p2: CGPoint, next p3: CGPoint?) -> CGPoint? {
        guard let p3 = p3 else {
            return nil
        }
        
        let leftMidPoint  = midPointForPoints(p1: p1, p2: p2)
        let rightMidPoint = midPointForPoints(p1: p2, p2: p3)
        
        var controlPoint = midPointForPoints(p1: leftMidPoint, p2: antipodalFor(point: rightMidPoint, center: p2)!)
        
        if p1.y.between(a: p2.y, b: controlPoint.y) {
            controlPoint.y = p1.y
        } else if p2.y.between(a: p1.y, b: controlPoint.y) {
            controlPoint.y = p2.y
        }
        
        let imaginContol = antipodalFor(point: controlPoint, center: p2)!
        
        if p2.y.between(a: p3.y, b: imaginContol.y) {
            controlPoint.y = p2.y
        }
        
        if p3.y.between(a: p2.y, b: imaginContol.y) {
            let diffY = abs(p2.y - p3.y)
            controlPoint.y = p2.y + diffY * (p3.y < p2.y ? 1 : -1)
        }
        
        controlPoint.x += (p2.x - p1.x) * 0.1
        
        return controlPoint
    }
    
    private func antipodalFor(point: CGPoint?, center: CGPoint?) -> CGPoint? {
        guard let point = point, let center = center else {
            return nil
        }
        let newX = 2 * center.x - point.x
        let diffY = abs(point.y - center.y)
        let newY = center.y + diffY * (point.y < center.y ? 1 : -1)
        
        return CGPoint(x: newX, y: newY)
    }
    
    private func midPointForPoints(p1: CGPoint, p2: CGPoint) -> CGPoint {
        return CGPoint(x: (p1.x + p2.x) / 2, y: (p1.y + p2.y) / 2)
    }
    
}
