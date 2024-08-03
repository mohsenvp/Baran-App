//
//  Date+Extension.swift
//  HeyWeather
//
//  Created by Kamyar on 10/11/21.
//

import Foundation

extension Date {
    
    var localizedString: String {
        let format = "EEEE, MMM d, yyyy"
        return self.getTimeInFormat(format: format).capitalized
    }
    
    var shortLocalizedString: String {
        let formatter = DateFormatter().utc
        formatter.dateFormat = "d MMM"
        formatter.locale = Locale.init(identifier: LocalizeHelper.shared.currentLanguage.rawValue)
        return formatter.string(from: self).capitalized
    }
    
    
    var relativeToNow: String {
        let formatter = RelativeDateTimeFormatter()
        formatter.unitsStyle = .full
        formatter.locale = Locale.init(identifier: LocalizeHelper.shared.currentLanguage.rawValue)
        return formatter.localizedString(for: self, relativeTo: Date.now).capitalized
    }
    
    
    var atHour: String {
        return self.localizedHour(withAmPm: false)
    }
    
    var atHourWithAmPm: String {
        return self.localizedHour(withAmPm: true)
    }
    
    var shortWeekday: String {
        if LocalizeHelper.shared.currentLanguage == .persian {
            let index = Calendar.current.component(.weekday, from: self)
            switch index {
            case 7:
                return "ش"
            case 6:
                return "ج"
            default:
                return "\(index.localizedNumber)ش"
            }
        }else {
            let formatter = DateFormatter().utc
            formatter.dateFormat = "EEE"
            formatter.locale = Locale.init(identifier: LocalizeHelper.shared.currentLanguage.rawValue)
            return formatter.string(from: self).capitalized
        }

    }
    
    var veryShortWeekday: String {
        if LocalizeHelper.shared.currentLanguage == .persian {
            let index = Calendar.current.component(.weekday, from: self)
            switch index {
            case 7:
                return "ش"
            case 6:
                return "ج"
            default:
                return "\(index.localizedNumber)ش"
            }
        }else {
            let formatter = DateFormatter().utc
            formatter.dateFormat = "EEEEE"
            formatter.locale = Locale.init(identifier: LocalizeHelper.shared.currentLanguage.rawValue)
            return formatter.string(from: self).capitalized
        }

    }
    
    var weekday: String {
        let formatter = DateFormatter().utc
        formatter.dateFormat = "EEEE"
        formatter.locale = Locale.init(identifier: LocalizeHelper.shared.currentLanguage.rawValue)
        return formatter.string(from: self).capitalized
    }
    
    func setTime(hour: Int, min: Int) -> Date? {
        let x: Set<Calendar.Component> = [.year, .month, .day, .hour, .minute, .second]
        let cal = Calendar.current
        var components = cal.dateComponents(x, from: self)
        components.hour = hour
        components.minute = min
        return cal.date(from: components)
    }
    
    func isEqual(to date: Date, accuracyTimeInterval: Int) -> Bool {
        if Int(abs(self.timeIntervalSince1970 - date.timeIntervalSince1970)) < accuracyTimeInterval {
            return true } else { return false }
    }
    
    func getTimeInFormat(format: String, forceCurrentTimezone: Bool = false) -> String {
        let date = self
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        dateFormatter.amSymbol = "AM"
        dateFormatter.pmSymbol = "PM"
        dateFormatter.timeZone = forceCurrentTimezone ? .current : .init(secondsFromGMT: 0)!
        dateFormatter.locale = Locale.init(identifier: LocalizeHelper.shared.currentLanguage.rawValue)
        let localDate = dateFormatter.string(from: date)
        return localDate
    }
    
    func localizedHour(withAmPm: Bool) -> String {
        let format = TimeFormat.getUserTimeFormat()
        return self.getTimeInFormat(format: format == .twelveHour ? withAmPm ? "h a" : "hh" : "HH")
    }
    
    func localizedHourAndMinutes(forceCurrentTimezone: Bool = false) -> String {
        let format = TimeFormat.getUserTimeFormat()
        return self.getTimeInFormat(format: format == .twelveHour ? "h:mm" : "H:mm" ,
                                    forceCurrentTimezone: forceCurrentTimezone)
    }
    
    func toUserTimeFormatWithMinuets(forceCurrentTimezone: Bool = false) -> String {
        let format = TimeFormat.getUserTimeFormat()
        return self.getTimeInFormat(format: format == .twelveHour ? "h:mm a" : "H:mm",
                                    forceCurrentTimezone: forceCurrentTimezone)
    }
    
    func timeInTimezone(timezone: TimeZone) -> String {
        let format = TimeFormat.getUserTimeFormat()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format == .twelveHour ? "h:mm a" : "H:mm"
        dateFormatter.amSymbol = "AM"
        dateFormatter.pmSymbol = "PM"
        dateFormatter.timeZone = timezone
        dateFormatter.locale = Locale.init(identifier: LocalizeHelper.shared.currentLanguage.rawValue)
        return dateFormatter.string(from: self)
    }
    
    func isOnSameDay(with date: Date, timezone: TimeZone = .current) -> Bool {
        let rDay = Calendar.current.component(.day,
                                              from: self.addingTimeInterval(TimeInterval(-timezone.secondsFromGMT())))
        let lDay = Calendar.current.component(.day,
                                              from: date.addingTimeInterval(TimeInterval(-timezone.secondsFromGMT())))
        return rDay == lDay
    }
    
    func isOnSameHour(with date: Date) -> Bool {
        let rDay = Calendar.current.component(.day, from: self)
        let lDay = Calendar.current.component(.day, from: date)
        let rHour = Calendar.current.component(.hour, from: self)
        let lHour = Calendar.current.component(.hour, from: date)
        return rDay == lDay && rHour == lHour
    }
    
    func isRealNow(timezone : TimeZone) -> Bool{
        let now = Date()
        var localSecondsFromGMT: TimeInterval = TimeInterval(timezone.secondsFromGMT())
        if (TimeZone.current.secondsFromGMT() % 3600 == 1800) {
            localSecondsFromGMT = localSecondsFromGMT - 1800
        }
        return self.isOnSameHour(with: now.addingTimeInterval(localSecondsFromGMT)) && self.isOnSameDay(with: now.addingTimeInterval(localSecondsFromGMT))
    }
    
    
    func isTodayReal(timezone : TimeZone = .current) -> Bool{
        let now = Date()
        var localSecondsFromGMT: TimeInterval = TimeInterval(timezone.secondsFromGMT())
        if (TimeZone.current.secondsFromGMT() % 3600 == 1800) {
            localSecondsFromGMT = localSecondsFromGMT - 1800
        }
        return self.isOnSameDay(with: now.addingTimeInterval(localSecondsFromGMT))
    }
   
    
    
    func at0(timezone: TimeZone) -> Date {
        var calendar = Calendar.current
        calendar.timeZone = timezone
        calendar.locale = Locale.init(identifier: LocalizeHelper.shared.currentLanguage.rawValue)
        var components = calendar.dateComponents([.day, .month, .year], from: self)
        components.hour = 0
        components.minute = 0
        components.second = 0
        let date = calendar.date(from: components)!
        return date
    }
    
    static func - (lhs: Date, rhs: Date) -> TimeInterval {
        return lhs.timeIntervalSinceReferenceDate - rhs.timeIntervalSinceReferenceDate
    }
    
   
}
