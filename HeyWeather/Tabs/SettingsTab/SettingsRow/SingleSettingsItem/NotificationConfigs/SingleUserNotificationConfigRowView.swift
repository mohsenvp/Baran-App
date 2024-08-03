//
//  SingleUserNotificationConfigRowView.swift
//  HeyWeather
//
//  Created by Mojtaba on 11/4/23.
//

import SwiftUI

struct SingleUserNotificationSettingRowView: View {
    
    @Binding var notificationItem: NotificationViewItem
    @State var goToCustomizeView: Bool = false
    @State var severeWeatherSupportedCountryList: Bool = false
    @State private var timeAndDaysShown: Bool = true
    
    var body: some View {
        let selectedDays: [Int] = notificationItem.config.days?.sorted() ?? []
        let time = createDate(hour: notificationItem.config.at_hour , minute: notificationItem.config.at_min)
        Button {
            if notificationItem.config.isSelected {
                if notificationItem.type != .severeWeather {
                    goToCustomizeView.toggle()
                } else {
                    severeWeatherSupportedCountryList.toggle()
                }
            }
        } label: {
            HStack(alignment: .top) {
                Image(notificationItem.icon)
                    .renderingMode(.template)
                    .resizable()
                    .foregroundColor(Constants.accentColor)
                    .scaledToFill()
                    .frame(width: 22, height: 22)
                    .padding(.top, 4)
                
                VStack (alignment: .leading, spacing: 5) {
                        Toggle(isOn: $notificationItem.config.isSelected.animation(), label: {
                                Text(notificationItem.name)
                                .foregroundStyle(Color.primary)
                        })
                        .tint(Constants.accentColor)
                        .onChange(of: notificationItem.config.isSelected) { value in
                            withAnimation {timeAndDaysShown = value}
                        }
                        .gesture(
                            TapGesture()
                                .onEnded { _ in }
                                .exclusively(before: TapGesture().onEnded {})
                        )
                    Text(notificationItem.description)
                        .minimumScaleFactor(0.6)
                        .foregroundStyle(Color.secondary)
                        .multilineTextAlignment(.leading)
                        .fonted(size: 14)
                    if timeAndDaysShown {
                        HStack(spacing: 0) {
                            if timeAndDaysString(days: selectedDays, time: time) != "" {
                                Text(timeAndDaysString(days: selectedDays, time: time))
                                    .foregroundColor(Constants.accentColor)
                                    .lineLimit(2)
                                    .multilineTextAlignment(.leading)
                                    .minimumScaleFactor(0.6)
                                    .fonted(size: 14)
                                    .transition(.scale)
                                    .underline(notificationItem.type == .severeWeather ? true : false )
                                Image(systemName: Constants.SystemIcons.chevronRight)
                                    .fonted(size:10,weight: .bold)
                                    .foregroundColor(Constants.accentColor)
                                    .transition(.scale)
                            }
                        }
                    }
                }
                .frame(maxWidth: .infinity)
            }
            .sheet(isPresented: $severeWeatherSupportedCountryList, content: {
                SevereWeatherSupportedCountriesSheet()
            })
            .navigationDestination(isPresented: $goToCustomizeView, destination: {
                NotificationConfigCustomizationView(
                    config: $notificationItem.config,
                    isNotifyAtExactTime: notificationItem.config.relative_seconds == 0 ? true : false,
                    relatedTimeOfAstronomy: RelatedTimeOfAstronomyNotif.getFromSeconds(second: notificationItem.config.relative_seconds ?? 0)
                )
                .navigationTitle(notificationItem.name)
            })
            .padding(.vertical, 6)
        }
        .onAppear() {
            timeAndDaysShown = notificationItem.config.isSelected
        }
    }
    
    func createDate(hour: Int?, minute: Int?) -> Date? {
        if hour == nil || minute == nil {
            return nil
        }
        let calendar = Calendar.current
        var components = DateComponents()
        components.hour = hour
        components.minute = minute
        
        return calendar.date(from: components)
    }
    func timeAndDaysString(days: [Int], time: Date?) -> String {
        var dayString = ""
        var timeString = ""
        if self.notificationItem.type == .sunrise || self.notificationItem.type == .sunset || self.notificationItem.type == .fullMoon {
            timeString = notificationItem.config.relative_seconds == 0 ? "At \(self.notificationItem.config.type.name)" : (RelatedTimeOfAstronomyNotif.getFromSeconds(second: notificationItem.config.relative_seconds ?? 0).shortName) + " before " + self.notificationItem.type.name
            if self.notificationItem.type == .fullMoon {
                return timeString
            }
            timeString += ", "
        } else if time != nil && !days.isEmpty {
            timeString = "At " + (time?.toUserTimeFormatWithMinuets(forceCurrentTimezone: true) ?? "")
            if self.notificationItem.type == .severeWeather {
                return "See supported countries."
            }
            timeString += ", "
        } else {
            timeString = ""
        }
        if days.isEmpty {
            dayString = "Never"
        } else {
            if days.count > 6 {
                dayString = "Every Day"
            } else if days.count > 4, !days.contains(6), !days.contains(5) {
                dayString = "Every Weekday"
            } else if days.count < 3, days.contains(where: [5, 6].contains) {
                dayString = "Every Weekend"
            } else {
                dayString = "Every "
                (0..<days.count).forEach { i in
                    let day = days[i]
                    dayString += day.numberToWeekday()
                    if i < days.count - 2 {
                        dayString += ", "
                    }
                    if i == days.count - 2 {
                        dayString += " & "
                    }
                    if i == days.count - 1 {
                        dayString += "."
                    }
                }
            }
        }
        
        return timeString + dayString
    }
}

#if DEBUG
struct BindingSingleUserNotificationSettingRowViewContainer: View {
    @State var vm = UserNotificationConfigViewData()
    
    var body: some View {
        SingleUserNotificationSettingRowView(notificationItem: $vm.notificationData[0],goToCustomizeView: false)
    }
}
#endif
#Preview {
    BindingSingleUserNotificationSettingRowViewContainer()
}


extension Int {
    func numberToWeekday() -> String {
        let dateFormatter = DateFormatter()
        guard let weekdaySymbols = dateFormatter.shortWeekdaySymbols, self >= 0, self < weekdaySymbols.count else {
            return "Invalid"
        }
        switch self {
        case 0:
            return weekdaySymbols[1]
        case 1:
            return weekdaySymbols[2]
        case 2:
            return weekdaySymbols[3]
        case 3:
            return weekdaySymbols[4]
        case 4:
            return weekdaySymbols[5]
        case 5:
            return weekdaySymbols[6]
        case 6:
            return weekdaySymbols[0]
        default:
            return ""
        }
    }
}







