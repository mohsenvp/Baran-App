//
//  DailyForecastView.swift
//  HeyWeather
//
//  Created by Kamyar on 11/28/21.
//

import SwiftUI

struct DailyForecastView: View {
    let dailyWeather: [Weather]
    let onMoreTapped: (() -> ())?
    let onWeatherTapped: ((Weather) -> ())?
    @Environment(\.isSubscriptionViewPresented) var isSubscriptionViewPresented
    @EnvironmentObject var premium: Premium
    
    var body: some View {
        let minTempOfAll: Int = dailyWeather.compactMap({$0.temperature.min}).min() ?? 0
        let maxTempOfAll: Int = dailyWeather.compactMap({$0.temperature.max}).max() ?? 0
        let hasAnyPrecipitation : Bool = dailyWeather.contains(where: { $0.details.precipitation! > 0.0 })
        let hasAnyPop : Bool = dailyWeather.contains(where: { $0.details.pop! > 0 })
        
        
        VStack(spacing:2) {
            
            HStack(spacing:0) {
                Text("DAILY FORECAST", tableName: "WeatherTab")
                    .fonted(.footnote, weight: .medium)
                    .opacity(Constants.primaryOpacity)
                    .accessibilityHidden(true)
                    .unredacted()
                Spacer()
                Button {
                    onMoreTapped?()
                } label: {
                    Text("Details", tableName: "WeatherTab")
                        .fonted(.footnote, weight: .medium)
                        .foregroundColor(Constants.accentColor)
                        .unredacted()
                    
                    Image(systemName: Constants.SystemIcons.arrowRight)
                        .fonted(.body, weight: .semibold)
                        .foregroundColor(Constants.accentColor)
                        .unredacted()
                        .flipsForRightToLeftLayoutDirection(true)
                        .accessibilityHidden(true)
                }
                .contentShape(Rectangle())
                .foregroundColor(.init(.label))
                .accessibilityLabel(Text("this week's weather detail", tableName: "Accessibility"))
                
                
            }
            .padding(.bottom, 12.5)
            
            LazyVStack(spacing: 2) {//For accessibility
                
                ForEach(0..<dailyWeather.count, id: \.self) { i in
                    
                    Button {
                        onWeatherTapped?(dailyWeather[i])
                    } label: {
                        DailyForecastNewCell(
                            weather: dailyWeather[i],
                            minTempOfAll: minTempOfAll,
                            maxTempOfAll: maxTempOfAll,
                            hasAnyPop: hasAnyPop,
                            hasAnyPrecipitation: hasAnyPrecipitation
                        )
                    }
                    .contentShape(Rectangle())
                    
                    if i != dailyWeather.count - 1 {
                        Divider().opacity(0.3)
                    }
                }
                
                if !premium.isPremium {
                    
                    Rectangle()
                        .fill(.clear)
                        .frame(height: 80)
                        .isPremium(
                            false,
                            cornerRadius: 10,
                            title: Text("Get up to 15 days forecast", tableName: "WeatherDetails"),
                            subtitle: nil,
                            isSubscriptionViewPresented: isSubscriptionViewPresented,
                            shouldBlur: false
                        )
                }
                
                
            }.accessibilityHidden(true)
            
        }
        .padding(.leading, 16)
        .padding(.trailing, 16)
        .weatherTabShape(horizontalPadding: false)
        
    }
}

fileprivate struct DailyForecastNewCell: View {
    @Environment(\.dynamicTypeSize) var typeSize
    let weather: Weather
    let minTempOfAll: Int
    let maxTempOfAll: Int
    let hasAnyPop: Bool
    let hasAnyPrecipitation : Bool
    @AppStorage(Constants.precipitationUnitString, store: Constants.groupUserDefaults) var unit: PrecipitationUnit = Constants.defaultPrecipitationUnit

    var body: some View {
        
        HStack(spacing : 0) {
            
            Group {
                if (weather.localDate.isTodayReal(timezone: weather.timezone)) {
                    Text("Today.abbr", tableName: "General")
                        .fonted(.body, weight: .semibold)
                }else {
                    Text(weather.localDate.shortWeekday)
                        .fonted(.body, weight: .regular)
                }
            }
            .frame(width: typeSize < .xxxLarge ? 46 : 54, height: 36, alignment: .leading)
            .lineLimit(1)
            .minimumScaleFactor(0.8)
            .foregroundColor(Color(Constants.primaryRowBgReversed))
            .accessibilityLabel(weather.localDate.weekday)
            
            
            if typeSize < .xxLarge {
                Text(Constants.openParen + weather.localDate.shortLocalizedString + Constants.closeParen)
                    .fonted(.caption, weight: .light)
                    .frame(width: 60, height: 30, alignment: .leading)
                    .opacity(Constants.pointThreeOpacity)
                    .lineLimit(1)
                    .minimumScaleFactor(0.8)
                    .foregroundColor(Color(Constants.primaryRowBgReversed))
            }
            
            HStack(spacing : 0) {
                Text(weather.temperature.min.localizedTemp)
                    .fonted(.callout, weight: .regular)
                    .opacity(Constants.primaryOpacity)
                    .lineLimit(1)
                    .minimumScaleFactor(0.8)
                    .foregroundColor(Color(Constants.primaryRowBgReversed))
                
                if typeSize < .xLarge || !Constants.isWidthCompact {
                    TemperatureForecastBar(minTempValue: weather.temperature.min, maxTempValue: weather.temperature.max, meanTempValue: nil, minTempOfAll: minTempOfAll, maxTempOfAll: maxTempOfAll)
                        .frame(height: 30)
                        .padding(.horizontal, 6)
                }else {
                    Image(systemName: Constants.SystemIcons.arrowDown)
                        .fonted(.callout, weight: .medium)
                        .foregroundColor(Constants.minTempColor)
                    Image(systemName: Constants.SystemIcons.arrowUp)
                        .fonted(.callout, weight: .medium)
                        .foregroundColor(Constants.maxTempColor)
                }
                
                Text(weather.temperature.max.localizedTemp)
                    .fonted(.callout, weight: .medium)
                    .lineLimit(1)
                    .minimumScaleFactor(0.8)
                    .foregroundColor(Color(Constants.primaryRowBgReversed))
            }
            .frame(
                minWidth: 0,
                maxWidth: .infinity,
                alignment: .center
            )
            
            
            Spacer()
            ConditionIcon(iconSet: Constants.defaultIconSet, condition: weather.condition)
                .frame(width: typeSize < .xxLarge ? 30 : 36, height: typeSize < .xxLarge ? 30 : 36)
                .fixedSize()
                .padding(.trailing, 6)

            
            
            if (hasAnyPrecipitation) {
                VStack(spacing: 0) {
                    
                    if weather.details.rainPossibility != nil {
                        HStack {
                            
                            Text(weather.details.rainPossibility ?? Constants.none)
                                .fonted(.footnote, weight: .medium)
                                .opacity(weather.details.rainPossibility == nil ? 0 : (weather.details.pop! <=  20 ? 0.8 : 1))
                                .foregroundColor(Constants.precipitationProgress)
                                .lineLimit(1)
                                .monospacedDigit()
                            Spacer(minLength: 0)
                            
                        }
                    }
                    
                    if weather.details.precipitation ?? 0 != 0, typeSize < .xLarge {
                        HStack(alignment: .bottom, spacing: 0){
                            Text(String(weather.details.precipitation!.localizedPrecipitation.removeZerosFromEnd()))
                                .fonted(.caption, weight: .regular)
                                .opacity(weather.details.precipitation! <=  0.2 ? 0.6 : 1)
                                .monospacedDigit()
                                .lineLimit(1)
                                .minimumScaleFactor(0.8)
                            
                            Text(unit.amount)
                                .fonted(size: 10, weight: .regular)
                                .opacity(weather.details.precipitation! <=  0.2 ? 0.6 : 1)
                                .minimumScaleFactor(0.7)
                            
                            Spacer(minLength: 0)
                        }
                        .opacity(weather.details.precipitation == 0 ? 0 : 1)
                        .foregroundColor(Constants.accentColor)
                    }
                }
                .frame(width: 48,alignment: .trailing)
            }else {
                Color.clear
                    .frame(width: 20,height: 0, alignment: .trailing)
            }
            
        }
        .padding(.vertical, typeSize < .xxLarge ? 5 : 10)
    }
}

#if DEBUG
struct DailyForecastView_Previews: PreviewProvider {
    static let premium = Premium()
    static var previews: some View {
        DailyForecastView(dailyWeather: [Weather(),Weather(),Weather(),Weather(),Weather(),Weather()], onMoreTapped: nil, onWeatherTapped: nil)
            .environmentObject(premium)
    }
}
#endif
