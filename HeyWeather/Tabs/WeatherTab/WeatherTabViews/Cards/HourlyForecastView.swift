//
//  HourlyForecastView.swift
//  HeyWeather
//
//  Created by Kamyar on 11/28/21.
//

import SwiftUI

struct HourlyForecastView: View {
    let hourlyWeather: [Weather]
    var fromMainView: Bool = true
    var onMoreTapped: (() -> ())? = nil
    var onWeatherTapped: ((Weather) -> ())? = nil
    
    @Environment(\.isSubscriptionViewPresented) var isSubscriptionViewPresented
    @Environment(\.dynamicTypeSize) var typeSize: DynamicTypeSize
    @EnvironmentObject var premium: Premium
    
    var body: some View {
        
        VStack {
            HStack {
                Text("HOURLY FORECAST", tableName: "WeatherTab")
                    .fonted(.footnote, weight: .medium)
                    .opacity(Constants.primaryOpacity)
                    .unredacted()
                    .accessibilityHidden(true)
                Spacer()
                if (fromMainView) {
                    Button {
                        onMoreTapped?()
                    } label: {
                        
                        Text("Details", tableName: "WeatherTab")
                            .fonted(.footnote, weight: .medium)
                            .foregroundColor(Constants.accentColor)
                            .unredacted()
                            .accessibilityHidden(true)
                        
                        Image(systemName: Constants.SystemIcons.arrowRight)
                            .fonted(.body, weight: .semibold)
                            .foregroundColor(Constants.accentColor)
                            .unredacted()
                            .flipsForRightToLeftLayoutDirection(true)
                            .accessibilityHidden(true)
                        
                    }.accessibilityValue(Text("today's weather detail", tableName: "Accessibility"))
                }
            }
            .padding(EdgeInsets(top: 0, leading: 16, bottom: 7.5, trailing: 16))
            
            ZStack {
                ScrollViewReader { scrollReader in
                    
                    ScrollView(.horizontal, showsIndicators: false) {
                        LazyHStack(pinnedViews: [.sectionHeaders]) {
                            ForEach(WeatherData.sectionilizeHourlyData(items: hourlyWeather)) { weatherSection in
                                Section {
                                    ForEach(weatherSection.items) { weather in
                                        Button {
                                            onWeatherTapped?(weather)
                                        } label: {
                                            HourlyForecastCell(weather: weather)
                                        }
                                        .contentShape(Rectangle())
                                    }
                                    
                                } header: {
                                    Text(weatherSection.sectionTitle)
                                        .fonted(.footnote, weight: .medium)
                                        .modifier(VerticalRotationModifier(rotation: .anticlockwise))
                                        .frame(width : 24)
                                        .frame(maxHeight: .infinity)
                                        .background(Color(Constants.stickyHeader))
                                        .cornerRadius(4)
                                        .foregroundColor(.black)
                                        .preferredColorScheme(.light)
                                }
                            }
                            
                            if (!premium.isPremium && fromMainView) {
                                // MARK: Fake View Under the limit View in mainView
                                Rectangle()
                                    .fill(Color.clear)
                                    .frame(width: Constants.screenWidth * 0.8, height : 110)
                                    .isPremium(premium.isPremium, cornerRadius: Constants.weatherTabRadius, subtitle: nil, isSubscriptionViewPresented: isSubscriptionViewPresented, shouldBlur: false)
                                
                                Spacer(minLength: 16)
                                
                            }else if (premium.isPremium && fromMainView) {
                                Button {
                                    onMoreTapped?()
                                } label: {
                                    VStack {
                                        Image(Constants.Icons.circleArrow)
                                        Text("See More", tableName: "General").fonted(.caption2, weight: .semibold)
                                    }
                                }.padding(EdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 24))
                            }
                        }
                        .onAppear {
                            scrollReader.scrollTo(0, anchor: LocalizeHelper.shared.currentLanguage.isRTL ? .trailing : .leading)
                        }
                        
                    }
                }
                .padding(.leading, 16)
                .frame(minHeight: typeSize < .xxLarge ? 110 : 130)
                .accessibilityElement(children: .ignore)
                
                if ((!premium.isPremium && !fromMainView && hourlyWeather.count < 1)) {
                    // MARK: Fake View Under the limit View in detailsView
                    HStack {
                        Spacer()
                        ForEach(0...5, id: \.self) { weather in
                            HourlyForecastCell(weather: Weather())
                        }
                        Spacer()
                    }
                    .frame(height : 110)
                    .isPremium(premium.isPremium, cornerRadius: Constants.weatherTabRadius, subtitle: nil, isSubscriptionViewPresented: isSubscriptionViewPresented, shouldBlur: true)
                    .padding(.horizontal, 16)
                }
            }.accessibilityHidden(true)
            
        }
        .weatherTabShape(background: fromMainView ? nil : [Color(.tertiaryLabel).opacity(0.3)], horizontalPadding: false)
    }
}


struct HourlyForecastCell: View {
    @Environment(\.dynamicTypeSize) var typeSize
    
    let weather: Weather
    
    var body: some View {
        VStack {
            
            Group {
                if (weather.localDate.isRealNow(timezone: weather.timezone)) {
                    Text("Now.abbr", tableName: "General")
                        .fonted(.body, weight: .semibold)
                }else {
                    Text(weather.localDate.atHour)
                        .fonted(.body, weight: .regular)
                }
            }
            .foregroundColor(Color(Constants.primaryRowBgReversed))
            .foregroundColor(.init(.label))
            .fonted(.body, weight: .regular)
            
            Spacer(minLength: 0)
            ConditionIcon(iconSet: Constants.defaultIconSet, condition: weather.condition)
                .frame(width: typeSize < .xxLarge ? 25 : 30, height: typeSize < .xxLarge ? 25 : 30)
                .fixedSize()
            
            Text(weather.details.rainPossibility ?? " ")
                .fonted(.footnote, weight: .medium)
                .foregroundColor(Constants.precipitationProgress)
                .padding(.top, -5)
            
            
            Spacer(minLength: 0)
            Text(weather.temperature.now.localizedTemp)
                .bold()
                .foregroundColor(Color(Constants.primaryRowBgReversed))
            
        }
        .padding(.horizontal, 8)
    }
}

#if DEBUG
struct HourlyForecastView_Previews: PreviewProvider {
    static let premium = Premium()
    static var previews: some View {
        HourlyForecastView(hourlyWeather: [Weather(),Weather(),Weather(),Weather(),Weather()], fromMainView: true)
            .environmentObject(premium)
    }
}
#endif
