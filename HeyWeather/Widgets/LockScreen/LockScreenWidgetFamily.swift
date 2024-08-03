//
//  LockScreenWidgetFamily.swift
//  HeyWeather
//
//  Created by Reza Ranjbaran on 16/06/2023.
//

import SwiftUI
import WidgetKit

struct LockScreenWidgetFamily: View {
    var weather : WeatherData = WeatherData()
    var astronomy : Astronomy = Astronomy()
    
    var widgetKind : LockScreenWidgetKind
    var widgetSize : WidgetFamily
    var id = 0
    
    var body: some View {
        switch widgetSize {
        case .accessoryCorner:
            if #available(iOS 17.0, *) {
                CornerView(weather: weather, widgetKind: widgetKind)
                    .widgetBackground(Color.clear)
            }
        case .accessoryCircular:
            CircularView(weather: weather, widgetKind: widgetKind)
        case .accessoryRectangular:
            RectangularView(weather: weather, astronomy: astronomy, widgetKind: widgetKind)
        case .accessoryInline:
            InlineView(weather: weather, widgetKind: widgetKind)
        default:
            EmptyView()
        }
        
    }
}
private struct InlineView: View {
    let weather : WeatherData
    let widgetKind : LockScreenWidgetKind
    
    var widgetText: String {
        switch widgetKind {
        case .currentOne:
            return weather.today.temperature.now?.localizedTemp ?? ""
        case .currentTwo:
            return "\(weather.today.temperature.now?.localizedTemp ?? "")\(Constants.spaceDashSpace)\(weather.today.temperature.max?.localizedTemp ?? "")\(Constants.arrowUpSymbol)\(Constants.space)\(Constants.arrowDownSymbol)\(weather.today.temperature.min?.localizedTemp ?? "")"
        case .precipitation:
            return "\(weather.today.details.pop?.localizedNumber ?? 0.localizedNumber)\(Constants.percent)\(Constants.spaceDashSpace)\((weather.today.details.precipitation?.localizedPrecipitation ?? 0).localizedNumber(withFractionalDigits: 1))"
        case .cloudiness:
            return "\(weather.today.details.clouds?.localizedNumber ?? "")\(Constants.percent)"
        case .uv:
            return String(localized: "UV Index", table: "WeatherDetails") +  "\(weather.today.details.uvIndex?.localizedNumber() ?? "")"
        case .humidity:
            return "\(weather.today.details.clouds?.localizedNumber ?? "") \(Constants.percent)"
        default:
            return ""
        }
    }
    var body: some View {
        switch widgetKind {
        case .currentOne:
            InlineContentView(condition: weather.today.condition, text: widgetText)
        case .currentTwo:
            InlineContentView(condition: weather.today.condition, text: widgetText)
        case .precipitation:
            InlineContentView(systemIcon: Constants.SystemIcons.umbrella, text: widgetText)
        case .cloudiness:
            InlineContentView(systemIcon: Constants.SystemIcons.cloudFill, text: widgetText)
        case .uv:
            InlineContentView(text: widgetText)
        case .humidity:
            InlineContentView(systemIcon: Constants.SystemIcons.humidityFill, text: widgetText)
        default:
            EmptyView()
        }
    }
    
    private struct InlineContentView: View {
        var condition: WeatherCondition? = nil
        var systemIcon: String? = nil
        let text: String
        
        var body: some View{
            HStack {
                if condition != nil {
                    ConditionIcon(iconSet: Constants.defaultLockScreenWidgetIconSet, condition: condition!)
                } else if systemIcon != nil {
                    Image(systemName: systemIcon!)
                }
                Text(text)
            }
        }
    }
}

private struct RectangularView: View {
    var weather : WeatherData
    var astronomy: Astronomy
    let widgetKind : LockScreenWidgetKind
    
    var body: some View {
        let currentWeather: Weather = weather.today
        let hourlyWeather: [Weather] = Array([currentWeather] + weather.hourlyForecast.prefix(4))
        let dailyWeather: [Weather] = Array(weather.dailyForecast.prefix(4))
        
        switch widgetKind {
        case .currentOne:
            RectangularCurrentOneView(weatherData: weather, astronomy: astronomy)
        case .currentTwo:
            RectangularCurrentTwoView(weatherData: weather, astronomy: astronomy)
        case .hourlyOne:
            RectangularHourlyOneView(hourlyWeather: hourlyWeather, astronomy: astronomy, today: weather.today)
        case .hourlyTwo:
            RectangularHourlyTwoView(hourlyWeather: hourlyWeather, astronomy: astronomy, today: weather.today)
        case .dailyOne:
            RectangularDailyOneView(dailyWeather: dailyWeather, astronomy: astronomy, today: weather.today)
        case .dailyTwo:
            RectangularDailyTwoView(dailyWeather: dailyWeather, astronomy: astronomy, today: weather.today)
        default:
            EmptyView()
        }
    }
    
    private struct RectangularCurrentOneView: View {
        var weatherData: WeatherData
        var astronomy: Astronomy
        var body: some View {
#if os(watchOS)
            let fontsize = 16.0
#else
            let fontsize = 12.0
#endif
            VStack(alignment: .leading, spacing: 0){
                HStack {
                    ConditionIcon(iconSet: Constants.defaultWatchIconSet, condition: weatherData.today.condition)
                        .widgetAccentable()
                        .frame(width: 22, height: 22)
                    
                    Text(weatherData.today.temperature.now?.localizedTemp ?? "")
                        .fonted(size: 18, weight: .bold)
                        .widgetAccentable()
                        .contentTransition(.numericText())
                    
                    Spacer()
                }.frame(maxHeight: .infinity)
                Text(weatherData.today.description.shortDescription)
                    .fonted(size: 14, weight: .semibold)
                    .foregroundStyle(.primary)
                    .frame(maxHeight: .infinity)
                
                MaxMinView(maxTemp: weatherData.today.temperature.max?.localizedTemp ?? "", minTemp: weatherData.today.temperature.min?.localizedTemp ?? "", fontSize: fontsize)
                    .frame(maxHeight: .infinity)
            }
            .complexModifier({ myView in
#if os(watchOS)
                myView.widgetBackground(AnimatedWeatherBackground(
                    sunrise: astronomy.sun.sunrise,
                    sunset: astronomy.sun.sunset,
                    weather: weatherData.today,
                    isAnimationEnabled: false
                ).weatherBackground, hasPadding: false)
#else
                myView.widgetBackground(Color.clear, hasPadding: false)
#endif
            })
        }
    }
    
    private struct RectangularCurrentTwoView: View {
        var weatherData: WeatherData
        var astronomy: Astronomy
        var body: some View {
#if os(watchOS)
            let fontsize = 14.0
#else
            let fontsize = 12.0
#endif
            HStack(spacing:0) {
                VStack {
                    HStack {
                        ConditionIcon(iconSet: Constants.defaultWatchIconSet, condition: weatherData.today.condition)
                            .frame(width: 22, height: 22)
                            .widgetAccentable()
                        Text(weatherData.today.temperature.now?.localizedTemp ?? "")
                            .fonted(size: 18, weight: .bold)
                            .widgetAccentable()
                            .contentTransition(.numericText())
                        
                    }
                    MaxMinView(maxTemp: weatherData.today.temperature.max?.localizedTemp ?? "", minTemp: weatherData.today.temperature.min?.localizedTemp ?? "", fontSize: fontsize)
                }
                Spacer(minLength: 0)
                VStack(spacing: 6){
                    Spacer(minLength: 0)
                    HStack(spacing: 3){
                        Image(systemName: Constants.SystemIcons.cloudFill)
                            .fonted(size: 14)
                        
                        
                        Spacer(minLength: 0)
                        
                        Text((weatherData.today.details.clouds?.localizedNumber ?? "") + Constants.percent)
                            .fonted(size: 14)
                            .contentTransition(.numericText())
                        
                    }
                    HStack(spacing: 3){
                        Image(systemName: Constants.SystemIcons.wind)
                            .fonted(size: 14)
                        
                        Spacer(minLength: 0)
                        
                        Text(weatherData.today.details.windSpeed?.rounded().localizedWindSpeed ?? "")
                            .fonted(size: 14)
                            .contentTransition(.numericText())
                        
                    }
                    HStack(spacing: 3){
                        Image(systemName: Constants.SystemIcons.humidityFill)
                            .fonted(size: 14)
                        
                        Spacer(minLength: 0)
                        
                        Text((weatherData.today.details.humidity?.localizedNumber ?? "") + Constants.percent)
                            .fonted(size: 14)
                            .contentTransition(.numericText())
                        
                    }
                    Spacer(minLength: 0)
                }.frame(width: 65)
            }
            .complexModifier({ myView in
#if os(watchOS)
                myView.widgetBackground(AnimatedWeatherBackground(
                    sunrise: astronomy.sun.sunrise,
                    sunset: astronomy.sun.sunset,
                    weather: weatherData.today,
                    isAnimationEnabled: false
                ).weatherBackground, hasPadding: false)
#else
                myView.widgetBackground(Color.clear, hasPadding: false)
#endif
            })
        }
    }
    
    
    private struct RectangularHourlyOneView: View {
        var hourlyWeather: [Weather]
        var astronomy: Astronomy
        var today: Weather
        var body: some View {
            HStack(spacing: 0){
                Spacer(minLength: 0)
                ForEach(hourlyWeather.prefix(4)) { weather in
                    VStack(spacing: 2){
                        Text(weather.localDate.localizedHour(withAmPm: false))
                            .fonted(size: 14, weight: .semibold)
                            .opacity(0.8)
                            .contentTransition(.numericText())
                        
                        ConditionIcon(iconSet: Constants.defaultWatchIconSet, condition: weather.condition)
                            .frame(width: 24, height: 24)
                        
                        Text(" " + (weather.temperature.now?.localizedTemp ?? ""))
                            .fonted(size: 15, weight: .bold)
                            .contentTransition(.numericText())
                        
                    }
                    Spacer(minLength: 0)
                }
            }
            .complexModifier({ myView in
#if os(watchOS)
                myView.widgetBackground(AnimatedWeatherBackground(
                    sunrise: astronomy.sun.sunrise,
                    sunset: astronomy.sun.sunset,
                    weather: today,
                    isAnimationEnabled: false
                ).weatherBackground, hasPadding: false)
#else
                myView.widgetBackground(Color.clear, hasPadding: false)
#endif
            })
        }
    }
    
    
    private struct RectangularHourlyTwoView: View {
        var hourlyWeather: [Weather]
        var astronomy: Astronomy
        var today: Weather
        var body: some View {
            VStack(spacing: 1){
                ForEach(hourlyWeather.prefix(3)) { weather in
                    HStack {
                        Text(weather.localDate.localizedHour(withAmPm: true))
                            .fonted(size: 13, weight: .semibold)
                            .opacity(0.9)
                            .monospacedDigit()
                            .frame(width: 40, alignment: .leading)
                            .contentTransition(.numericText())
                        
                        Spacer(minLength: 0)
                        
                        Text(weather.temperature.now?.localizedTemp ?? "")
                            .fonted(size: 13, weight: .bold)
                            .contentTransition(.numericText())
                        
                        Spacer(minLength: 0)
                        
                        ConditionIcon(iconSet: Constants.defaultWatchIconSet, condition: weather.condition)
                            .frame(width: 20, height: 20)
                        
                        Text((weather.details.pop?.localizedNumber ?? "\(0.localizedNumber)") + Constants.percent)
                            .fonted(size: 12, weight: .light)
                            .minimumScaleFactor(0.8)
                            .frame(width: 30, alignment: .trailing)
                            .contentTransition(.numericText())
                    }
                }
            }
            .complexModifier({ myView in
#if os(watchOS)
                myView.widgetBackground(AnimatedWeatherBackground(
                    sunrise: astronomy.sun.sunrise,
                    sunset: astronomy.sun.sunset,
                    weather: today,
                    isAnimationEnabled: false
                ).weatherBackground, hasPadding: false)
#else
                myView.widgetBackground(Color.clear, hasPadding: false)
#endif
            })
        }
    }
    
    
    private struct RectangularDailyOneView: View {
        var dailyWeather: [Weather]
        var astronomy: Astronomy
        var today: Weather
        
        var body: some View {
            HStack {
                ForEach(dailyWeather.prefix(3)) { weather in
                    VStack(spacing: 2){
                        Text(weather.localDate.shortWeekday)
                            .fonted(size: 14, weight: .semibold)
                            .opacity(0.8)
                        
                        ConditionIcon(iconSet: Constants.defaultWatchIconSet, condition: weather.condition)
                            .frame(width: 24, height: 24)
                        
                        HStack(spacing: 2){
                            Text(weather.temperature.max?.localizedTemp ?? "")
                                .fonted(size: 14, weight: .bold)
                                .monospacedDigit()
                                .minimumScaleFactor(0.8)
                                .contentTransition(.numericText())
                            
                            Text(weather.temperature.min?.localizedTemp ?? "")
                                .fonted(size: 14, weight: .light)
                                .minimumScaleFactor(0.8)
                                .monospacedDigit()
                                .contentTransition(.numericText())
                            
                        }
                    }.frame(maxWidth: .infinity)
                }
            }
            .complexModifier({ myView in
#if os(watchOS)
                myView.widgetBackground(AnimatedWeatherBackground(
                    sunrise: astronomy.sun.sunrise,
                    sunset: astronomy.sun.sunset,
                    weather: today,
                    isAnimationEnabled: false
                ).weatherBackground, hasPadding: false)
#else
                myView.widgetBackground(Color.clear, hasPadding: false)
#endif
            })
        }
    }
    
    private struct RectangularDailyTwoView: View {
        var dailyWeather: [Weather]
        var astronomy: Astronomy
        var today: Weather
        var body: some View {
            VStack(spacing: 1){
                ForEach(dailyWeather.prefix(3)) { weather in
                    HStack {
                        Text(weather.localDate.shortWeekday)
                            .fonted(size: 13, weight: .semibold)
                            .opacity(0.9)
                            .frame(width: 40, alignment: .leading)
                        
                        Spacer(minLength: 0)
                        
                        HStack(spacing: 0){
                            
                            Text(weather.temperature.max?.localizedTemp ?? "")
                                .fonted(size: 13, weight: .bold)
                                .frame(width: 30, alignment: .trailing)

                            Image(systemName: Constants.SystemIcons.arrowUp)
                                .fonted(size: 11, weight: .bold)
                            
                            Text(Constants.space)
                                .fonted(size: 13, weight: .regular)
                            
                            Image(systemName: Constants.SystemIcons.arrowDown)
                                .fonted(size: 11, weight: .medium)
                                .opacity(Constants.pointSevenOpacity)
                            
                            Text(weather.temperature.min?.localizedTemp ?? "")
                                .fonted(size: 13, weight: .medium)
                                .frame(width: 28, alignment: .leading)
                                .opacity(Constants.pointSevenOpacity)
                        }
                        
                        
                        Spacer(minLength: 0)
                        
                        ConditionIcon(iconSet: Constants.defaultWatchIconSet, condition: weather.condition)
                            .frame(width: 20, height: 20)
                        
                    }
                }
            }
            .complexModifier({ myView in
#if os(watchOS)
                myView.widgetBackground(AnimatedWeatherBackground(
                    sunrise: astronomy.sun.sunrise,
                    sunset: astronomy.sun.sunset,
                    weather: today,
                    isAnimationEnabled: false
                ).weatherBackground, hasPadding: false)
#else
                myView.widgetBackground(Color.clear, hasPadding: false)
#endif
            })
        }
    }
    
}

private struct CircularView: View {
    var weather : WeatherData
    let widgetKind : LockScreenWidgetKind
    
    var chartGradient: Gradient {
        switch widgetKind {
        case .currentOne, .currentTwo:
            let colors: [Color] = TemperatureColor.getColors(min: Double(weather.today.temperature.min ?? 0), max: Double(weather.today.temperature.max ?? 0))
            return Gradient(colors: colors)
        case .cloudiness:
            return Gradient(colors: [.init(hex: "2CEFEF"), .init(hex: "2AC0B7")])
        case .humidity:
            return Gradient(colors: [.init(hex: "63CE7A"), .init(hex: "66B6F5"), .init(hex: "5858BB")])
        case .uv:
            return Gradient(colors: [.init(hex: "14FF00"), .init(hex: "E2E521"), .init(hex: "F47E10"), .init(hex: "D129C0")])
        default:
            return Gradient(colors: [.init(hex: "219DC5")])
        }
    }
    
    var body: some View {
        
        ZStack{
            
            switch widgetKind {
            case .currentOne:
                Gauge(value: CGFloat(weather.today.temperature.now ?? 0), in: CGFloat(weather.today.temperature.min ?? 0)...CGFloat(weather.today.temperature.max ?? 0)) {
                    Text(" " + (weather.today.temperature.now?.localizedTemp ?? ""))
                        .fonted(.subheadline, weight: .bold)
                        .contentTransition(.numericText())
                } currentValueLabel: {
                    ConditionIcon(iconSet: Constants.defaultWatchIconSet, condition: weather.today.condition)
                        .frame(width: 24, height: 24)
                        .widgetAccentable()
                }
                .tint(chartGradient)
                .gaugeStyle(.accessoryCircular)
                
            case .currentTwo:
                Gauge(value: CGFloat(weather.today.temperature.now ?? 0), in: CGFloat(weather.today.temperature.min ?? 0)...CGFloat(weather.today.temperature.max ?? 0)) {
                    
                } currentValueLabel: {
                    Text(weather.today.temperature.now?.localizedTemp ?? "")
                        .fonted(.title3, weight: .bold)
                        .widgetAccentable()
                        .contentTransition(.numericText())
                } minimumValueLabel: {
                    Text(weather.today.temperature.min?.localizedTempWithoutDegreeSign ?? "")
                        .fonted(size: 12, weight: .medium)
                        .widgetAccentable()
                        .contentTransition(.numericText())
                    
                } maximumValueLabel: {
                    Text(weather.today.temperature.max?.localizedTempWithoutDegreeSign ?? "")
                        .fonted(size: 12, weight: .medium)
                        .widgetAccentable()
                        .contentTransition(.numericText())
                    
                }
                .tint(chartGradient)
                .gaugeStyle(.accessoryCircular)
            case .cloudiness:
                
                Gauge(value: CGFloat(weather.today.details.clouds ?? 0), in: CGFloat(0)...CGFloat(100)) {
                    Image(systemName: Constants.SystemIcons.cloudFill)
                        .renderingMode(.template)
                        .widgetAccentable()
                        .fonted(.body, weight: .bold)
                    
                } currentValueLabel: {
                    Text("\(weather.today.details.clouds?.localizedNumber ?? "")\(Constants.percent)")
                        .widgetAccentable()
                        .fonted(.title3, weight: .bold)
                        .contentTransition(.numericText())
                }
                .tint(chartGradient)
                .gaugeStyle(.accessoryCircular)
            case .uv:
                Gauge(value: CGFloat(weather.today.details.uvIndex ?? 0), in: CGFloat(0)...CGFloat(11)) {
                    Text("UV").fonted(.callout, weight: .bold)
                        .widgetAccentable()
                } currentValueLabel: {
                    Text("\((weather.today.details.uvIndex ?? 0).localizedNumber(withFractionalDigits: 2))")
                        .fonted(.title3, weight: .bold)
                        .widgetAccentable()
                        .contentTransition(.numericText())
                }
                .tint(chartGradient)
                .gaugeStyle(.accessoryCircular)
                
            case .humidity:
                Gauge(value: CGFloat(weather.today.details.humidity ?? 0), in: CGFloat(0)...CGFloat(100)) {
                    Image(systemName: Constants.SystemIcons.humidityFill)
                        .renderingMode(.template)
                        .widgetAccentable()
                        .fonted(.body, weight: .bold)
                } currentValueLabel: {
                    Text("\(weather.today.details.humidity?.localizedNumber ?? "")\(Constants.percent)")
                        .widgetAccentable()
                        .fonted(.title3, weight: .bold)
                        .contentTransition(.numericText())
                }
                .tint(chartGradient)
                .gaugeStyle(.accessoryCircular)
                
            default:
                EmptyView()
            }
            
        }
        .ZStackWidgetBackground(Color.clear, hasPadding: false)
    }
}


@available(iOS 17.0, *)
private struct CornerView: View {
    var weather : WeatherData
    let widgetKind : LockScreenWidgetKind
    
    var chartGradient: LinearGradient {
        switch widgetKind {
        case .currentOne, .currentTwo:
            let colors: [Color] = TemperatureColor.getColors(min: Double(weather.today.temperature.min ?? 0), max: Double(weather.today.temperature.max ?? 0))
            return LinearGradient(colors: colors, startPoint: .top, endPoint: .bottom)
        case .cloudiness:
            return LinearGradient(colors: [.init(hex: "2CEFEF"), .init(hex: "2AC0B7")], startPoint: .top, endPoint: .bottom)
        case .humidity:
            return LinearGradient(colors: [.init(hex: "63CE7A"), .init(hex: "66B6F5"), .init(hex: "5858BB")], startPoint: .top, endPoint: .bottom)
        case .uv:
            return LinearGradient(colors: [.init(hex: "14FF00"), .init(hex: "E2E521"), .init(hex: "F47E10"), .init(hex: "D129C0")], startPoint: .top, endPoint: .bottom)
        default:
            return LinearGradient(colors: [.init(hex: "219DC5"), .init(hex: "2189AA")], startPoint: .top, endPoint: .bottom)
        }
    }
    
    var body: some View {
        switch widgetKind {
        case .currentOne:
            Gauge(value: CGFloat(weather.today.temperature.now ?? 0), in: CGFloat(weather.today.temperature.min ?? 0)...CGFloat(weather.today.temperature.max ?? 0)) {
                Text(weather.today.temperature.now?.localizedTemp ?? "")
                    .fonted(.footnote, weight: .medium)
                    .contentTransition(.numericText())
                    .widgetAccentable()
            } currentValueLabel: {
                ConditionIcon(iconSet: Constants.defaultWatchIconSet, condition: weather.today.condition)
                    .frame(width: 20, height: 20)
                    .widgetAccentable()
            }
            .gaugeStyle(.accessoryCircular)
            .tint(chartGradient)
            .widgetAccentable()
            
        case .currentTwo:
            Text(weather.today.temperature.now?.localizedTemp ?? "")
                .widgetCurvesContent()
                .fonted(.title3, weight: .bold)
                .widgetAccentable()
                .widgetLabel {
                    Gauge(value: CGFloat(weather.today.temperature.now ?? 0), in: CGFloat(weather.today.temperature.min ?? 0)...CGFloat(weather.today.temperature.max ?? 0)) {
                    } currentValueLabel: {
                        
                    } minimumValueLabel: {
                        Text(weather.today.temperature.min?.localizedTemp ?? "")
                            .fonted(size: 10, weight: .regular)
                            .contentTransition(.numericText())
                        
                    } maximumValueLabel: {
                        Text(weather.today.temperature.max?.localizedTemp ?? "")
                            .fonted(size: 10, weight: .regular)
                            .contentTransition(.numericText())
                        
                    }
                    .tint(chartGradient)
                    .widgetAccentable()
                }
                .tint(chartGradient)
            
        case .cloudiness:
            Text("\(Int(weather.today.details.clouds ?? 0))%")
                .widgetCurvesContent()
                .fonted(.title3, weight: .bold)
                .widgetAccentable()
                .widgetLabel {
                    ProgressView(value: CGFloat(weather.today.details.clouds ?? 0), total: 100) {
                        Image(systemName: "cloud.fill")
                            .foregroundStyle(Color(hex: "2CEFEF"))
                    }
                    .tint(chartGradient)
                    .widgetAccentable()
                }
            
            
        case .uv:
            Text("UV: \(Int(weather.today.details.uvIndex ?? 0))")
                .widgetCurvesContent()
                .fonted(.body, weight: .bold)
                .widgetAccentable()
                .widgetLabel {
                    Gauge(value: CGFloat(weather.today.details.uvIndex ?? 0), in: CGFloat(0)...CGFloat(11)){
                    } currentValueLabel: {
                        
                    } minimumValueLabel: {
                        Text(0.localizedNumber)
                            .foregroundStyle(Color(hex: "14FF00"))
                            .contentTransition(.numericText())
                        
                    } maximumValueLabel: {
                        Text(11.localizedNumber)
                            .foregroundStyle(Color(hex: "D129C0"))
                            .contentTransition(.numericText())
                        
                        
                    }
                    .tint(chartGradient)
                    .widgetAccentable()
                }
        case .humidity:
            Text("\(Int(weather.today.details.humidity ?? 0))%")
                .widgetCurvesContent()
                .contentTransition(.numericText())
                .fonted(.title3, weight: .bold)
                .widgetAccentable()
                .widgetLabel {
                    ProgressView(value: CGFloat(weather.today.details.humidity ?? 0), total: 100) {
                        Image(systemName: "humidity.fill")
                            .foregroundStyle(Color(hex: "63CE7A"))
                    }
                    .tint(chartGradient)
                    .widgetAccentable()
                }
        default:
            EmptyView()
        }
    }
}


#if DEBUG
struct LockScreenWidgetFamily_Previews: PreviewProvider {
    static var previews: some View {
        RectangularView(
            weather: .init(),
            astronomy: .init(),
            widgetKind: .dailyTwo
        ).previewContext(WidgetPreviewContext(family: .accessoryRectangular))
        
    }
}
#endif

