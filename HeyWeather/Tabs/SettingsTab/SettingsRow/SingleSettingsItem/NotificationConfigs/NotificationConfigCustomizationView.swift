//
//  NotificationConfigCustomizationView.swift
//  HeyWeather
//
//  Created by Mojtaba on 11/20/23.
//

import SwiftUI

struct NotificationConfigCustomizationView: View {
    @Environment(\.colorScheme) var colorScheme: ColorScheme
    @Binding var config: NotificationConfigItem
    @State var time: Date = Date.now
    @State var isShowingAlert: Bool = false
    @State var isNotifyAtExactTime: Bool
    @State var relatedTimeOfAstronomy: RelatedTimeOfAstronomyNotif
    var currentAppIcon: Int = UserDefaults.get(for: .appIcon) ?? 0
    let tagViewItems: [TagViewItem] = NotificationWeatherConfigExtra.allCases.map {
        TagViewItem(value: $0.rawValue, title: $0.name, image: $0.icon)
    }
    
    
    var body: some View {
        let isTodaySummary = config.type == .todaySummary
        let isTomorrowSummary = config.type == .tomorrowOutlook
        let paddingAmount: CGFloat = 16
        var dateRange: ClosedRange<Date> {
            let calendar = Calendar.current
            var startHour = 0
            var endHour = 24
            if isTodaySummary {
                startHour = 5
                endHour = 11
            } else if isTomorrowSummary {
                startHour = 17
                endHour = 23
            } else {
                startHour = 4
                endHour = 24
            }
            let startComponents = DateComponents(hour: startHour, minute: 0)
            let endComponents = DateComponents(hour: endHour, minute: 0)
            return calendar.date(from:startComponents)!
            ...
            calendar.date(from:endComponents)!
        }
        ScrollView {
            VStack {
                if config.type == .sunrise || config.type == .sunset || config.type == .fullMoon {
                    VStack {
                        Toggle(isOn: $isNotifyAtExactTime.animation()) {
                            Text("Exact time of " + config.type.name)
                                .foregroundStyle(isNotifyAtExactTime ? Color.primary : Color.gray)
                        }
                        .tint(Constants.accentColor)
                        .onChange(of: isNotifyAtExactTime) { selected in
                            if selected {
                                config.relative_seconds = 0
                            } else {
                                return
                            }
                        }
                        if !isNotifyAtExactTime {
                            VStack {
                                HStack {
                                    Text("Before: ")
                                    Spacer()
                                }
                                
                                SegmentedPicker(
                                    items: RelatedTimeOfAstronomyNotif.allCases,
                                    titles: [
                                        Text("15 Minutes"),
                                        Text("30 Minutes"),
                                        Text("1 Hour")
                                    ],
                                    selected: $relatedTimeOfAstronomy,
                                    background: colorScheme == .light ? Color(.secondarySystemBackground):Color(.systemBackground),
                                    selectedBackground: colorScheme == .light ? Color(.systemBackground):Color(.secondarySystemBackground)) {
                                        config.relative_seconds = relatedTimeOfAstronomy.inSecond
                                    }
                            }
                        }
                    }
                    .padding(.horizontal, paddingAmount)
                    
                } else {
                    HStack {
                        Group{
                            #if DEBUG
                            DatePicker("Time", selection: $time ,displayedComponents: .hourAndMinute)
                            #else
                            if isTodaySummary || isTomorrowSummary {
                                DatePicker("Time", selection: $time ,in: dateRange ,displayedComponents: .hourAndMinute)
                            }else {
                                DatePicker("Time", selection: $time ,displayedComponents: .hourAndMinute)
                            }
                            #endif
                        }
                        .padding(.horizontal, paddingAmount)
                        .onAppear {
                            time = createDate(hour: config.at_hour, minute: config.at_min) ?? Date.now
                        }
                        .onChange(of: time) { time in
                            let components = Calendar.current.dateComponents([.hour, .minute], from: time)
                            config.at_hour = components.hour ?? 0
                            config.at_min = components.minute ?? 0
                        }
                    }
                }
                if config.type != .fullMoon && config.type != .severeWeather {
                    Divider()
                        .padding(.leading, paddingAmount)
                    VStack {
                        HStack(alignment: .center) {
                            ForEach(0..<7) { i in
                                let shortDay = i.numberToWeekday()
                                let firstLetterOfDay = String(shortDay.prefix(1))
                                Button {
                                    if var days = config.days {
                                        if days.contains(i) {
                                            if let index = days.firstIndex(of: i) {
                                                days.remove(at: index)
                                                config.days = days.sorted()
                                            }
                                        } else {
                                            days.append(i)
                                            config.days = days.sorted()
                                        }
                                    }
                                } label: {
                                    Circle()
                                        .foregroundStyle(Constants.accentColor.opacity(config.days?.contains(i) ?? false ? 1 : 0.1))
                                        .overlay {
                                            Text(firstLetterOfDay)
                                                .foregroundStyle(config.days?.contains(i) ?? false ? .white : .secondary)
                                        }
                                }
                            }
                        }
                    }
                    .padding(.horizontal, paddingAmount)
                    
                    HStack(spacing: 0) {
                        Text(daysString(days: config.days ?? [] ))
                            .foregroundStyle(.secondary)
                            .lineLimit(1)
                            .minimumScaleFactor(0.6)
                            .fonted(size: 14)
                            .padding(.horizontal, paddingAmount)
                        Spacer()
                    }
                    if isTodaySummary || isTomorrowSummary {
                        Divider()
                            .padding(.leading, paddingAmount)
                        HStack {
                            Text("Extra Info")
                                .fonted()
                            Spacer()
                        }
                        .padding(.horizontal, paddingAmount)
                        TagView(tags: tagViewItems , extraDetails: config.details ?? []){ value in
                            if config.details?.contains(value) ?? false {
                                if let index = self.config.details?.firstIndex(of: value) {
                                    config.details?.remove(at: index)
                                }
                            } else {
                                if config.details?.count ?? 0 > 3 {
                                    isShowingAlert.toggle()
                                    return
                                }
                                config.details?.append(value)
                            }
                        }
                        .padding(.horizontal, paddingAmount)
                        
                    }
                    
                }
            }
            .weatherTabShape(horizontalPadding: false)
            .padding([.horizontal])
            .padding(.bottom)
            /* MARK: - Notification Preview Section */
            VStack(alignment: .leading) {
                Text("Notification Preview")
                    .padding(.leading, 30)
                    .foregroundStyle(.secondary)
                    .fonted()
                VStack {
                    HStack(alignment: .center, spacing: 10) {
                        Image("AppIcon-\(currentAppIcon)-preview")
                            .resizable()
                            .frame(width: 35, height: 35)
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                        
                        VStack (alignment: .leading, spacing: 0){
                            HStack {
                                Text("Rainy")
                                Spacer()
                                Text("20m ago")
                                    .foregroundStyle(.secondary)
                                    .fonted(size: 14)
                            }
                            .padding(.bottom, 5)
                            Text(CityAgent.getMainCity().name + ": ")
                                .foregroundStyle(.secondary)
                                .fonted(size: 13)
                        }
                        .frame(maxWidth: .infinity)
                    }
                }
                .weatherTabShape()
                .padding([.horizontal])
            }
            
        }
        .snackbar(isShowing: $isShowingAlert, title: Text("You can select up to 3 extra information"), actionText: Text(""), isShowingYesButton: false)
        .background(Color(.systemGroupedBackground).ignoresSafeArea())
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
    func daysString(days: [Int]) -> String {
        var string = ""
        if days.isEmpty {
            return "Never"
        } else {
            if days.count > 6 {
                string = "Every Day"
                return string
            }else if days.count > 4 && !days.contains(6) && !days.contains(5) {
                string = "Every Weekday"
                return string
            } else if days.count < 3 && days.contains([5,6]) {
                string = "Every Weekend"
                return string
            } else {
                string = "Every "
                (0..<days.count).forEach { i in
                    let day = days[i]
                    string += day.numberToWeekday()
                    if i < days.count - 2 {
                        string += ", "
                    }
                    if i == days.count - 2 {
                        string += " & "
                    }
                    if i == days.count - 1 {
                        string += "."
                    }
                }
                return string
            }
        }
        
    }
    func previewText(details: [String], weather: WeatherData, aqi: AQIData, astronomy: Astronomy, type: NotificationConfigType) -> String {
        var TodayOrTomorrowString: String {
            if type == .todaySummary {
                return "For Today; "
            } else if type == .tomorrowOutlook{
                return "For Tommorrow; "
            } else {
                return ""
            }
        }
        var tempString = ""
        var conditionString = ""
        var windString = ""
        var uvString = ""
        var humidityString = ""
        var popString = ""
        var precpString = ""
        var aqiString = ""
        var pressureString = ""
        var dewString = ""
        var visString = ""
        var cloudString = ""
        var sunsetString = ""
        var sunriseString = ""
        var dayTimeString = ""
        var moonString = ""
        var nightTimeString = ""
        (0..<details.count).forEach { i in
            let detail = details[i]
            switch detail {
            case "temp":
                tempString = " Average temperature is : \(weather.today.temperature.now.localizedTemp)" + ","
            case "condition":
                conditionString += " " + weather.today.condition.description.localized + ","
            case "wind":
                windString += " WindSpeed: \(weather.dailyForecast[0].details.windSpeed?.localizedWindSpeed ?? 0.localizedWindSpeed)"  + ","
            case "uv":
                uvString += " Uv index is: \(weather.today.details.uvIndex?.localizedNumber() ?? 0.localizedNumber )" + ","
            case "rh":
                humidityString += " Humidity is : \(weather.today.details.humidity?.localizedNumber ?? 0.localizedNumber)" + ","
            case "pop":
                popString += " Chance of Precipitation is: \(weather.today.details.pop?.localizedNumber ?? 0.localizedNumber)" + "%" + ","
            case "precp":
                precpString += " Precipitation amount is: \(weather.today.details.precipitation?.localizedPrecipitation ?? 0.localizedPrecipitation/*data.dailyForecast.details.precipitation?.localizedPrecipitation ?? 0.localizedPrecipitation*/)" + ","
            case "aqi":
                aqiString += " Air quality index is: \(aqi.current.value.localizedNumber)" + ", "
            case "pressure":
                pressureString += " Pressure is: \(weather.today.details.pressure?.localizedPressure ?? 0.localizedPressure)" + ","
            case "dew":
                dewString += " Dew Point is: \(weather.today.details.dewPoint?.localizedTemp ?? 0.localizedTemp)" + ","
            case "vis":
                visString += " Visibility is: \(weather.today.details.visibility?.localizedVisibility ?? 0.localizedVisibility)" + ","
            case "cloud":
                cloudString += " Cloudiness is: \(weather.today.details.cloudsDescription ?? "")" + ","
            case "sunset":
                sunsetString += " Sunset is: \(astronomy.sun.sunset?.toUserTimeFormatWithMinuets() ?? "")" + ","
            case "sunrise":
                sunriseString += " Sunrise is: \(astronomy.sun.sunrise?.toUserTimeFormatWithMinuets() ?? "")" + ","
            case "daytime":
                dayTimeString += " Daytime is: \(astronomy.sun.getDayDurationHours() )" + ":" + "\(astronomy.sun.getDayDurationMinutes() )" + ","
            case "moon":
                moonString += " Moon Phase is: \(astronomy.moon.phase)" + ","
            case "nighttime":
                nightTimeString += "" + ","
            default:
                break
            }
        }
        var finalString = TodayOrTomorrowString + tempString + conditionString + windString + uvString + humidityString + popString + precpString + aqiString + pressureString + dewString + visString + cloudString + sunsetString + sunriseString + dayTimeString + moonString + nightTimeString
        
        if !finalString.isEmpty {
            finalString.removeLast()
            finalString += "."
        }
        
        return finalString
    }
}

#Preview {
    BindingNotificationConfigCustomizationViewContainer()
}

#if DEBUG
struct BindingNotificationConfigCustomizationViewContainer: View {
    @State var vm = UserNotificationConfigViewData()
    
    var body: some View {
        NotificationConfigCustomizationView(config: $vm.notificationData[0].config, isNotifyAtExactTime: true, relatedTimeOfAstronomy: .halfHour)
    }
}
#endif
