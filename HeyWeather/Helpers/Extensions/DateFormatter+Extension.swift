//
//  DateFormatter+Extension.swift
//  HeyWeather
//
//  Created by Reza Ranjbaran on 16/06/2023.
//

import Foundation

extension DateFormatter {
    var utc: DateFormatter {
        self.timeZone = TimeZone(identifier: "UTC")
        return self
    }
}

extension Calendar {
    var utc : Calendar {
        var cal = self
        cal.timeZone = TimeZone(identifier: "UTC")!
        return cal
    }
}

extension Date {
    func convertToTimeZone(timeZone: TimeZone) -> Date {
        let targetOffset = timeZone.secondsFromGMT(for: self)
        return addingTimeInterval(TimeInterval(targetOffset))
    }
}
