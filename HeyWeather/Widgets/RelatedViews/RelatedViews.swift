//
//  RelatedView.swift
//  NeonWeather
//
//  Created by RezaRg on 7/18/20.
//

import SwiftUI
import WidgetKit


struct NextHourVertical: View {
    var weather: Weather
    var theme : WidgetTheme = WidgetTheme()
    
    var body: some View {
        let fontColor : Color = theme.fontColor
        
        VStack(spacing:0){
            Text(weather.date.atHour)
                .fonted(size: 12, weight: .regular, custom: theme.font)
                .foregroundColor(fontColor)
                .contentTransition(.numericText())
            ConditionIcon(iconSet: theme.iconSet, condition: weather.condition)
                .frame(width: 18, height: 18, alignment: .leading)
                .padding([.top, .bottom], 4)
            Text(weather.temperature.now.localizedTemp)
                .fonted(size: 12, weight: .semibold, custom: theme.font)
                .foregroundColor(fontColor)
                .contentTransition(.numericText())
        }
        .accessibilityElement(children: .ignore)
        .accessibilityLabel(Text(weather.temperature.now.localizedTemp + Constants.space + weather.description.shortDescription) + Text("at".localized + weather.date.atHour))
    }
}

struct NextDayHorizontal: View {
    var weather: Weather
    var theme : WidgetTheme = WidgetTheme()
    var isVertical: Bool = false
    var body: some View {
        let fontColor : Color = theme.fontColor
        let max = weather.temperature.max.localizedTemp
        let min = weather.temperature.min.localizedTemp
        let weekDay = weather.date.weekday.localized.capitalized
        
        if isVertical {
            VStack(spacing: 0) {
                ConditionIcon(iconSet: theme.iconSet, condition: weather.condition)
                    .frame(width: 22, height: 22)
                    .accessibilityHidden(true)
                    .padding(6)
                
                VStack(alignment: .leading, spacing: 2) {
                    Text(weekDay)
                        .fonted(size: 11, weight: .semibold, custom: theme.font)
                        .foregroundColor(fontColor)
                        .lineLimit(1)
                        .frame(maxWidth: .infinity)
                        .accessibilityHidden(true)

                    MaxMinView(maxTemp: max, minTemp: min, fontColor: fontColor, fontSize: 12, font: theme.font)
                        .frame(maxWidth: .infinity)
                    .accessibilityElement(children: .ignore)
                    .accessibilityLabel(Text("\(max) \("at.max".localized), \(min) \("at.min".localized)") + Text(", ") + Text(weather.description.shortDescription) + Text(", ") + Text("on".localized + weekDay))
                }
            }
        }else {
            HStack(spacing: 0) {
                ConditionIcon(iconSet: theme.iconSet, condition: weather.condition)
                    .frame(width: 18, height: 18, alignment: .leading)
                    .accessibilityHidden(true)
                    .padding(.trailing , 4)
                
                VStack(alignment: .leading, spacing: 2) {
                    Text(weekDay)
                        .fonted(size: 11, weight: .semibold, custom: theme.font)
                        .foregroundColor(fontColor)
                        .lineLimit(1)
                        .accessibilityHidden(true)

                    MaxMinView(maxTemp: max, minTemp: min, fontColor: fontColor, fontSize: 10, font: theme.font)
                    .accessibilityElement(children: .ignore)
                    .accessibilityLabel(Text("\(max) \("at.max".localized), \(min) \("at.min".localized)") + Text(", ") + Text(weather.description.shortDescription) + Text(", ") + Text("on".localized + weekDay))
                }
            }
        }
        
    }
}

struct LocationView : View {
    var theme : WidgetTheme
    var weather : WeatherData
    var id = 0
    var isVertical: Bool = false
    var body : some View {
        let fontColor : Color = theme.fontColor
        let location = weather.location
        
        if isVertical {
            VStack (spacing : 2) {
                if (theme.showUpdateTime) {
                    Text(weather.updateTime.localizedHourAndMinutes(forceCurrentTimezone: true))
                        .fonted(size: 12, weight: .semibold, custom: theme.font)
                        .foregroundColor(fontColor)
                        .contentTransition(.numericText())
                }
                
                
                if (theme.showCityName) {
                    Text(theme.showAddress ? location.name : (location.placeMarkCityName ?? location.name))
                        .fonted(size: 12, weight: .semibold, custom: theme.font)
                        .foregroundColor(fontColor)
                        .transition(.push(from: .leading))
                }
            }
        }else {
            HStack (spacing : 0) {
                if (theme.showUpdateTime) {
                    Text(weather.updateTime.localizedHourAndMinutes(forceCurrentTimezone: true))
                        .fonted(size: 10, weight: .semibold, custom: theme.font)
                        .lineLimit(1)
                        .foregroundColor(fontColor)
                        .contentTransition(.numericText())
                }
                
                if (theme.showUpdateTime && theme.showCityName) {
                    Text(Constants.dash)
                        .fonted(size: 10, weight: .semibold, custom: theme.font)
                        .lineLimit(1)
                        .foregroundColor(fontColor)
                }
                
                if (theme.showCityName) {
                    Text(theme.showAddress ? location.name : (location.placeMarkCityName ?? location.name))
                        .fonted(size: 10, weight: .semibold, custom: theme.font)
                        .lineLimit(1)
                        .foregroundColor(fontColor)
                }
            }
        }
        
    }
}

struct MaxMinView: View {
    var maxTemp: String
    var minTemp: String
    var fontColor : Color = Color.white
    var fontSize = 12.0
    var font: String?
    
    var body : some View {
        HStack(spacing: 0) {
            Group{
                Text(maxTemp)
                    .fonted(size: fontSize, weight: .bold, custom: font)
                    .monospacedDigit()
                    .contentTransition(.numericText())

                Image(systemName: Constants.SystemIcons.arrowUp)
                    .fonted(size: fontSize - 2, weight: .bold)

                Text(Constants.space)
                    .fonted(size: fontSize, weight: .regular, custom: font)

                Image(systemName: Constants.SystemIcons.arrowDown)
                    .fonted(size: fontSize - 2, weight: .medium)
                    .opacity(Constants.pointSevenOpacity)
                
                Text(minTemp)
                    .fonted(size: fontSize, weight: .medium, custom: font)
                    .contentTransition(.numericText())
                    .monospacedDigit()
                    .opacity(Constants.pointSevenOpacity)
            }
            .monospacedDigit()
            .foregroundColor(fontColor)
            .foregroundStyle(.primary)
        }
        .widgetAccentable(false)
        .accessibilityElement(children: .ignore)
        .accessibilityLabel(Text("\(maxTemp) \("at.max".localized), \(minTemp) \("at.min".localized)"))
    }
}


struct ConditionView3 : View {
    var icon: String
    var color = Color.blue
    var title: Text
    var value: String
    var valueUnit: String?
    var theme: WidgetTheme? = nil
    var width:CGFloat = 80
    
    var body : some View {
        HStack(alignment: .center){
            Image(systemName: icon).foregroundColor(color)
                .frame(width: width/2, height: width/2)
                .background(color.opacity(0.1))
                .clipShape(Circle())
                .accessibilityHidden(true)
            
            VStack(alignment: .leading) {
                HStack(spacing: 0) {
                    Group() {
                        Text(value)
                            .fonted(size: 13, weight: .bold, custom: theme?.font)
                            .contentTransition(.numericText())

                        if let valueUnit = valueUnit {
                            Text(valueUnit)
                                .fonted(size: 11, weight: .bold, custom: theme?.font)
                                .transition(.push(from: .leading))
                        }
                    }
                    .lineLimit(1)
                    .minimumScaleFactor(0.01)
                }
                
                title.foregroundColor(theme?.fontColor).opacity(0.5)
                    .fonted(size: 13, weight: .regular, custom: theme?.font)
                    .lineLimit(1)
                    .minimumScaleFactor(0.01)
                    .transition(.push(from: .leading))
            }
            .frame(alignment: .leading)
            .foregroundColor(theme?.fontColor ?? .black)
            
            Spacer(minLength: 0)
        }
        .accessibilityElement(children: .ignore)
        .accessibilityLabel(title + Text("," + value + (valueUnit ?? "")))
        .frame(height : width)
        .frame(alignment: .center)
    }
}

struct AQIWidgetsView : View {
    var aqi : AQI
    var widgetWidth : CGFloat
    
    var body: some View {
        
        let intStage = aqi.index
        GeometryReader { geometry in
            VStack(spacing : 6) {
                let aqiColorForStages = Constants.aqiColors
                Text ("Air Quality Index : \(aqi.value)", tableName: "AQI")
                    .foregroundColor(.gray)
                    .frame(maxWidth : .infinity)
                    .frame(alignment : .leading)
                    .fonted(.caption, weight: .regular)
                    .contentTransition(.numericText())
                
                ZStack {
                    let lenght = CGFloat((widgetWidth - 16) / 6)
                    
                    let a = CGFloat(Double(aqi.index) * Double(lenght))
                    let b = CGFloat(Double(lenght) * Double(aqi.progress))
                    let newOffset : CGFloat =  a + b
                    
                    HStack(spacing : 0) {
                        aqiColorForStages[0]
                            .frame(maxWidth : .infinity)
                        aqiColorForStages[1]
                            .frame(maxWidth : .infinity)
                        aqiColorForStages[2]
                            .frame(maxWidth : .infinity)
                        aqiColorForStages[3]
                            .frame(maxWidth : .infinity)
                        aqiColorForStages[4]
                            .frame(maxWidth : .infinity)
                        aqiColorForStages[5]
                            .frame(maxWidth : .infinity)
                    }.frame(height : 4)
                        .padding(.horizontal, 8)
                        .cornerRadius(3.0)
                    
                    HStack {
                        Circle()
                            .fill((aqiColorForStages[intStage]))
                            .frame(width: 10, height: 10)
                            .offset(x : newOffset)
                    }.offset(x : -3 * lenght)
                }
                
                Text(aqi.status)
                    .foregroundColor(aqiColorForStages[intStage])
                    .fonted(.caption, weight: .regular)
            }
            .frame(maxWidth : .infinity)
        }
        
    }
}
