//
//  FloatingPoint+Extension.swift
//  HeyWeather
//
//  Created by Mohammad Yeganeh on 7/12/23.
//

import Foundation

extension FloatingPoint {
    /// Allows mapping between reverse ranges, which are illegal to construct (e.g. `10..<0`).
    func interpolated(
        fromLowerBound: Self,
        fromUpperBound: Self,
        toLowerBound: Self,
        toUpperBound: Self) -> Self
    {
        let positionInRange = (self - fromLowerBound) / (fromUpperBound - fromLowerBound)
        return (positionInRange * (toUpperBound - toLowerBound)) + toLowerBound
    }
    
    func interpolated(from: ClosedRange<Self>, to: ClosedRange<Self>) -> Self {
        interpolated(
            fromLowerBound: from.lowerBound,
            fromUpperBound: from.upperBound,
            toLowerBound: to.lowerBound,
            toUpperBound: to.upperBound)
    }
    
}
extension Comparable {
    func clamped(to limits: ClosedRange<Self>) -> Self {
        return min(max(self, limits.lowerBound), limits.upperBound)
    }
}
