//
//  NewHeader.swift
//  HeyWeather
//
//  Created by Mohammad Yeganeh on 7/11/23.
//

import SwiftUI



struct WeatherTabHeader: View {
    
    @ObservedObject var weatherTabState: WeatherTabState
    var onManageCitiesTapped: () -> Void
    var onClimateTapped: () -> Void
    var onTimeTravelTapped: () -> Void
    
    @State var width: CGFloat = Constants.screenWidth
    let padding: CGFloat = 20
    let idleIconWidth: CGFloat = 80
    let collapsedIconWidth: CGFloat = 50
    let collapsedTopPadding: CGFloat = 8
    let collapsedDegreeFontSize: CGFloat = 28
    
    
    
    
    var statusText: String {
        weatherTabState.weatherData.today.isAvailable ? "\(weatherTabState.weatherData.today.description.shortDescription) • \(weatherTabState.weatherData.today.temperature.max.localizedTemp)↑↓\(weatherTabState.weatherData.today.temperature.min.localizedTemp)" : ""
    }
    
    var body: some View {
        let window = UIApplication.shared.windows.filter {$0.isKeyWindow}.first
        let topSafeArea: CGFloat = window?.windowScene?.statusBarManager?.statusBarFrame.height ?? 0
        let idleHeaderHeight = topSafeArea + 180
        let collapsedHeaderHeight = topSafeArea + 66
        
        GeometryReader { geo in
            
            
            let width = geo.size.width
            let statusTextWidth = statusText.widthOfString(usingFont: UIFont.systemFont(ofSize: 16))
            
            let iconIdleX = width / 2 - idleIconWidth - 10
            let degreeWidth = width / 3.8
            let degreeCollapsedX = width - degreeWidth
            let degreeIdleX = width / 2
            let statusIdleY = topSafeArea + idleIconWidth + (padding * 4)
            let statusCollapsedY = topSafeArea + padding + collapsedTopPadding + 8
            let statusCollapsedX = padding * 1.6 + collapsedIconWidth
            let locationIdleWidth = width / 1.5
            let locationCollapsedWidth = width / 1.7
            let locationY = topSafeArea + collapsedTopPadding + 4
            let rightIconX = width - 80
            let rightIconY = topSafeArea + 8
            let statusIdleX = (width / 2) - (statusTextWidth / 2)
            let feelIsShownInCollapsed = statusTextWidth < (width / 1.7)
            
            let minY = geo.frame(in: .named(Constants.weatherTabCoordinateSpace)).minY
            let value = ((-minY) + collapsedHeaderHeight).interpolated(from: collapsedHeaderHeight...idleHeaderHeight, to: 0...1).clamped(to: 0...1)
            let reverseValue = 1 - value
            
            let locationOpacity = 1.0 - (0.2 * value)
            let locationFontSize = 16 - (2 * value)
            let locationWidth = (locationCollapsedWidth * value) + (locationIdleWidth * reverseValue)
            let locationBoxX = (reverseValue * 8) + padding * 1.6 + (value * collapsedIconWidth)
            let locationBoxY = topSafeArea + collapsedTopPadding + (6 * value)
            let conditionIconWidth = (collapsedIconWidth * value) + (idleIconWidth * reverseValue)
            let conditionIconX = (value * padding) + (reverseValue * iconIdleX)
            let conditionIconY = topSafeArea + collapsedTopPadding + (padding * 2.5 * reverseValue) + (collapsedTopPadding / 4 * value)
            let degreeFontSize = 56 - (28 * value)
            let feelsFontSize = 16 - (4 * value)
            let feelsOpacity = 1.0 - (feelIsShownInCollapsed ? 0.0 : value)
            let degreeBoxX = value.interpolated(from: 0...1, to: degreeIdleX...degreeCollapsedX)
            let degreeBoxY = topSafeArea + collapsedTopPadding + (padding * 2.5 * reverseValue)
            let statusX = (statusCollapsedX * value) + (statusIdleX * reverseValue)
            let statusY = (statusCollapsedY * value) + (statusIdleY * reverseValue)
            let statusOpacity = 1.0 - (0.1 * value)
            let backgroundOpacity = -2.0 + (value * 3.0)
            
            
            
            ZStack(alignment: .topLeading){
                
                
                AnimatedWeatherBackground(
                    sunrise: weatherTabState.astronomy.sun.sunrise,
                    sunset: weatherTabState.astronomy.sun.sunset,
                    weather: weatherTabState.weatherData.today,
                    isAnimationEnabled: false
                )
                .frame(height: collapsedHeaderHeight)
                .contentShape(Rectangle())
                .mediumShadow()
                .opacity(backgroundOpacity)
                
                
                Image(systemName: weatherTabState.city.isCurrentLocation ? Constants.SystemIcons.location : Constants.SystemIcons.mapPin)
                    .resizable()
                    .renderingMode(.template)
                    .frame(width: 12, height: 12)
                    .foregroundColor(weatherTabState.textColor)
                    .fontWeight(.semibold)
                    .offset(x: padding, y: locationY)
                    .opacity(reverseValue)
                    .accessibilityHidden(true)
                
                
                HStack {
                    Text(weatherTabState.weatherData.location.name)
                        .lineLimit(1)
                        .opacity(locationOpacity)
                        .fonted(size: locationFontSize, weight: .medium)
                        .transition(.push(from: .leading))
                        .complexModifier({ view in
                            if #available(iOS 17, *) {
                                view.invalidatableContent(weatherTabState.isLoadingForRefresher)
                                    .redacted(isRedacted: weatherTabState.isLoadingForRefresher)
                                    
                            }else {
                                view.redacted(isRedacted: weatherTabState.isLoadingForRefresher)
                            }
                        })
                    
                    Text(Date().timeInTimezone(timezone: weatherTabState.weatherData.timezone))
                        .opacity(0.8)
                        .fonted(size: 14, weight: .light)
                        .accessibilityHidden(true)
                        .complexModifier({ view in
                            if #available(iOS 17, *) {
                                view.invalidatableContent(weatherTabState.isLoadingForRefresher)
                                    .redacted(isRedacted: weatherTabState.isLoadingForRefresher)
                            }else {
                                view.redacted(isRedacted: weatherTabState.isLoadingForRefresher)
                            }
                        })
                    
                    Spacer(minLength: 0)
                }
                .foregroundColor(weatherTabState.textColor)
                .frame(width: locationWidth)
                .offset(x: locationBoxX, y: locationBoxY)
                
                Button {//clicker space for cities
                    onManageCitiesTapped()
                } label: {
                    Rectangle().fill(.clear)
                        .frame(width: .infinity)
                        .frame(height: idleIconWidth * 1.2)
                }
                
                HStack(spacing: 12){
                    
                    Menu {
                        Button {
                            onClimateTapped()
                        } label: {
                            HStack {
                                Image(systemName: Constants.SystemIcons.cloudSunRain)
                                Text("Climate Data", tableName: "Climate")
                                    .fonted(.callout, weight: .medium)
                            }
                        }
                        
                        Button {
                            onTimeTravelTapped()
                        } label: {
                            HStack {
                                Image(systemName: Constants.SystemIcons.timer)
                                Text("Precast Data", tableName: "TimeTravel")
                                    .fonted(.callout, weight: .medium)
                            }
                        }
                        
                    } label: {
                        Image(systemName: Constants.SystemIcons.extensionPuzzle)
                            .flipsForRightToLeftLayoutDirection(true)
                    }
                    .accentColor(weatherTabState.textColor)
                    .opacity(reverseValue)
                    
                    Image(systemName: Constants.SystemIcons.listBullet)
                        .flipsForRightToLeftLayoutDirection(true)
                        .font(.system(.title3))
                        .opacity(reverseValue)
                        .foregroundStyle(weatherTabState.textColor)
                    
                }
                .offset(x: rightIconX, y: rightIconY)
                
                
                
                ConditionIcon(
                    iconSet: Constants.default3DIconSet,
                    condition: weatherTabState.weatherData.today.condition
                )
                .accessibilityHidden(true)
                .frame(width: conditionIconWidth)
                .offset(x: conditionIconX, y: conditionIconY)
                .complexModifier({ view in
                    if #available(iOS 17, *) {
                        view.invalidatableContent(weatherTabState.isLoadingForRefresher)
                            .redacted(isRedacted: weatherTabState.isLoadingForRefresher)
                    }else{
                        view
                    }
                })
                
                
                VStack(spacing: -2){
                    Text(weatherTabState.weatherData.today.temperature.now.localizedTemp)
                        .fonted(size: degreeFontSize, weight: .semibold)
                        .lineLimit(1)
                        .minimumScaleFactor(0.8)
                        .contentTransition(.numericText())
                    
                    
                    Text("Feels \(weatherTabState.weatherData.today.temperature.feels.localizedTemp)", tableName: "General")
                        .fonted(size: feelsFontSize, weight: .regular)
                        .opacity(0.8)
                        .opacity(feelsOpacity)
                        .lineLimit(1)
                        .minimumScaleFactor(0.8)
                        .transition(.push(from: .leading))
                }
                .foregroundColor(weatherTabState.textColor)
                .frame(width: degreeWidth)
                .offset(x: degreeBoxX , y: degreeBoxY)
                
                
                Text(statusText)
                    .fonted(size: 16, weight: .regular)
                    .foregroundColor(weatherTabState.textColor)
                    .opacity(statusOpacity)
                    .contentTransition(.numericText())
                    .offset(x: statusX,y: statusY)
                    .accessibilityLabel(Text("current condition is \(weatherTabState.weatherData.today.description.shortDescription), at max  \(weatherTabState.weatherData.today.temperature.max.localizedTemp), at min \(weatherTabState.weatherData.today.temperature.min.localizedTemp)", tableName: "Accessibility"))
                
            }
            .offset(y: (-minY))
        }
        .frame(height: idleHeaderHeight)
        .zIndex(999)
        .animation(.linear, value: weatherTabState.weatherData)
        .dynamicTypeSize(.large)
    }
    
    
}

