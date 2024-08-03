//
//  WeatherDetailsView.swift
//  HeyWeather
//
//  Created by Kamyar on 12/8/21.
//

import SwiftUI


struct WeatherDetailsView: View {
    @StateObject var viewModel: WeatherDetailsViewModel
    @EnvironmentObject var premium : Premium
    @Environment(\.isSubscriptionViewPresented) var isSubscriptionViewPresented
    
    var body: some View {
        GeometryReader { proxy in
            ScrollView(showsIndicators: false) {
                VStack {
                    HorizontalWeatherListView(viewModel: viewModel).frame(height: proxy.size.height * (Constants.isWidthCompact ? 0.45 : 0.35))
                    
                    ZStack {
                        ///minus bottom padding is in order for the scroll bounce not to show bottom of
                        ///the scrolling box since the main background view is gray and the scrolling view is white
                        Color(.systemBackground).shadow(radius: 8, y: -4).padding(.bottom, -Constants.screenHeight)
                        VStack {
                            BriefInfo(viewModel: viewModel)
                            
                            if viewModel.isShowingHourly {
                                HourlyForecastView(
                                    hourlyWeather: viewModel.weatherData.getHourly(for: viewModel.selectedWeather.localDate, isPremium: premium.isPremium, isDetail: true),
                                    fromMainView: false
                                )
                            }
                            
                            PrecipitationDetailsView(viewModel: viewModel)
                            
                            ExtraDetailsGridView(viewModel: viewModel)
                            
                            if viewModel.type == .daily {
                                AstronomyDetailsView(type: .sun, sun: viewModel.selectedSun)
                                AstronomyDetailsView(type: .moon, moon: viewModel.selectedMoon)
                            }
                            Spacer()
                        }
                        .padding(.horizontal)
                    }
                    
                }
            }
            .onChange(of: viewModel.selectedWeather) { selectedWeather in
                viewModel.onDateChange()
                if premium.isPremium {
                    withAnimation {
                        viewModel.isShowingHourly = viewModel.type == .daily && viewModel.weatherData.getHourly(for: viewModel.selectedWeather.localDate, isPremium: premium.isPremium, isDetail: true).count > 0
                    }
                }
            }
            .onAppear(){
                if premium.isPremium {
                    viewModel.getAQIs()
                }
            }
            .background(Color(.secondarySystemBackground).ignoresSafeArea())
            .navigationTitle(viewModel.navigationTitle)
            .navigationBarTitleDisplayMode(.inline)
        }
    }
    
    private struct HorizontalWeatherListView: View {
        
        @ObservedObject var viewModel: WeatherDetailsViewModel
        @EnvironmentObject var premium: Premium
        @Environment(\.isSubscriptionViewPresented) var isSubscriptionViewPresented
        @Environment(\.dynamicTypeSize) var typeSize
        
        
        var body: some View {
            GeometryReader { proxy in
                let yOffsets = viewModel.getWeatherDetailYOffsets(for: proxy.size.height, typeSize: typeSize)
                ScrollViewReader { scrollReader in
                    
                    ScrollView(.horizontal, showsIndicators: false) {
                        LazyHStack(spacing:0, pinnedViews: [.sectionHeaders]) {
                            ForEach(viewModel.sectionedWeathers) { weatherSection in
                                Section {
                                    ForEach(weatherSection.items) { weather in
                                        let index = viewModel.weathers.firstIndex(of: weather)!
                                        
                                        DetailWeatherCell(
                                            weather: weather,
                                            selected: weather == viewModel.selectedWeather,
                                            type: viewModel.type,
                                            yOffset: yOffsets[index],
                                            index: index
                                        ).onTapGesture {
                                            viewModel.selectedWeather = weather
                                        }
                                        .padding(.trailing, index == viewModel.weathers.count - 1 ? 10 : 0)
                                        .padding(.leading, index == 0 ? 10 : 0)
                                        
                                    }
                                    
                                } header: {
                                    if viewModel.type != .daily {
                                        SectionHeaderView(title: weatherSection.sectionTitle)
                                    }
                                }
                            }
                            if (!premium.isPremium) {
                                Rectangle()
                                    .fill(.clear)
                                    .frame(width: Constants.screenWidth / 2)
                                    .isPremium(
                                        premium.isPremium,
                                        cornerRadius: 0,
                                        subtitle: nil,
                                        isSubscriptionViewPresented: isSubscriptionViewPresented,
                                        shouldBlur: false,
                                        isVertical: true
                                    )
                                Spacer()
                            }
                        }
                    }.onAppear {
                        scrollReader.scrollTo(0, anchor: LocalizeHelper.shared.currentLanguage.isRTL ? .trailing : .leading)
                        
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
                            withAnimation(.linear(duration: Constants.motionReduced ? 0 : 0.3)) {
                                scrollReader.scrollTo(viewModel.selectedWeather.id, anchor: .center)
                            }
                        })
                    }
                }
            }
        }
        
        private struct SectionHeaderView: View {
            @Environment(\.dynamicTypeSize) var typeSize
            let title: String
            var body: some View {
                HStack(spacing: 0){
                    Rectangle().fill(Color(.secondarySystemBackground))
                    Text(title)
                        .fonted(.body, weight: .regular)
                        .modifier(VerticalRotationModifier(rotation: .anticlockwise))
                        .frame(width : typeSize < .xxxLarge ?  29 : 32)
                        .frame(maxHeight:.infinity)
                        .background(Color(Constants.stickyHeader))
                        .foregroundColor(.black)
                        .preferredColorScheme(.light)
                    
                }
            }
        }
        
        
        private struct DetailWeatherCell: View {
            @Environment(\.dynamicTypeSize) var typeSize
            let weather: Weather
            let selected: Bool
            let type: WeatherDetailsType
            let yOffset: CGFloat
            let index: Int
            var body: some View {
                VStack(spacing:0)  {
                    if type == .daily ? weather.localDate.isTodayReal(timezone: weather.timezone) : weather.localDate.isRealNow(timezone: weather.timezone) {
                        Group {
                            if type == .daily {
                                Text("Today.abbr", tableName: "General")
                            }else{
                                Text("Now.abbr", tableName: "General")
                            }
                        }
                        .fonted(.callout, weight: selected ? .semibold : .regular)
                        .frame(height: 28)
                        .lineLimit(1)
                        .minimumScaleFactor(0.7)
                        
                    } else {
                        Text(type == .daily ? weather.localDate.shortWeekday : weather.localDate.localizedHour(withAmPm: false))
                            .fonted(.callout, weight: selected ? .semibold : .regular)
                            .accessibilityLabel(type == .daily ? Text(weather.localDate.shortLocalizedString) : Text("\(weather.localDate.localizedHour(withAmPm: false)) o'clock", tableName: "Accessibility"))
                            .frame(height: 28)
                    }
                    VStack(spacing:typeSize < .xxLarge ? 0 : 2) {
                        ConditionIcon(iconSet: Constants.defaultIconSet, condition: weather.condition)
                            .frame(width: typeSize < .xxLarge ? 30 : 36, height: typeSize < .xxLarge ? 30 : 36)
                        if (type == .hourly) {
                            Text(weather.temperature.now.localizedTemp)
                                .fonted(.body, weight: selected ? .semibold : .regular)
                                .opacity(selected ? 1 : Constants.primaryOpacity)
                                .frame(height: 18)
                        }else {
                            Text(weather.temperature.max.localizedTemp)
                                .fonted(.body, weight: selected ? .semibold : .regular)
                                .opacity(selected ? 1 : Constants.primaryOpacity)
                                .frame(height: 18)
                            Text(weather.temperature.min.localizedTemp)
                                .fonted(.callout, weight: selected ? .medium : .light)
                                .opacity(selected ? 0.5 : 0.4)
                                .frame(height: 18)
                        }
                        
                    }
                    .offset(y: yOffset)
                    
                    Spacer()
                    
                    Text(weather.details.rainPossibility ?? "")
                        .fonted(.footnote, weight: selected ? .bold : .regular)
                        .foregroundColor(Constants.precipitationProgress)
                        .accessibilityLabel(Text("Chance of rain", tableName: "Accessibility"))
                        .accessibilityValue(weather.details.rainPossibility ?? "")
                        .lineLimit(1)
                        .minimumScaleFactor(0.8)
                    
                    
                }
                .accessibilityElement(children: .combine)
                .contentShape(Rectangle())
                .padding(.vertical, 5)
                .padding(.horizontal, 5)
                .frame(width: typeSize < .xLarge ? 56 : 66)
                .background(index % 2 == 0 ? Color.clear.cornerRadius(0) : Color(Constants.primaryRowBg).cornerRadius(selected ? 8 : 0))
                .background(selected ? Constants.accentColor.opacity(0.05) : .clear)
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(selected ? Constants.accentColor : .clear, lineWidth: 2.5)
                        .padding(1)
                )
                .padding(.vertical, 1)
            }
        }
    }
    
    private struct BriefInfo: View {
        @ObservedObject var viewModel: WeatherDetailsViewModel
        
        var body: some View {
            HStack {
                RoundedRectangle(cornerRadius: 2)
                    .fill(Constants.accentColor)
                    .frame(width: 5)
                
                ConditionIcon(
                    iconSet: Constants.default3DIconSet,
                    condition: viewModel.selectedWeather.condition
                )
                .frame(width: 50, height: 50)
                .padding(.trailing, 10)
                
                VStack(alignment: .leading, spacing: 5) {
                    
                    HStack {
                        if viewModel.type == .daily ? viewModel.selectedWeather.localDate.isTodayReal(timezone: viewModel.selectedWeather.timezone) : viewModel.selectedWeather.localDate.isRealNow(timezone: viewModel.selectedWeather.timezone) {
                            Group {
                                if viewModel.type == .daily {
                                    Text("Today", tableName: "General")
                                }else{
                                    Text("Now", tableName: "General")
                                }
                            }
                            .fonted(.body, weight: .regular)
                            .opacity(Constants.primaryOpacity)
                        } else {
                            Text(viewModel.type == .daily ? viewModel.selectedWeather.localDate.weekday + Constants.commaAndSpace +  viewModel.selectedWeather.localDate.shortLocalizedString : viewModel.selectedWeather.localDate.atHourWithAmPm)
                                .fonted(.body, weight: .regular)
                                .opacity(Constants.primaryOpacity)
                                .lineLimit(2)
                                .minimumScaleFactor(0.8)
                        }
                        
                        Spacer(minLength: 2)
                        if viewModel.type == .daily {
                            TemperatureMinMaxView(
                                min: viewModel.selectedWeather.temperature.min ?? 0,
                                max: viewModel.selectedWeather.temperature.max ?? 0
                            )
                        }else {
                            Text(viewModel.selectedWeather.temperature.now.localizedTemp)
                                .fonted(.body, weight: .bold)
                                .padding(.trailing)
                        }
                    }
                    
                    Text(viewModel.selectedWeather.description.shortDescription)
                        .fonted(.body, weight: .bold)
                    
                }
                
            }
            .padding(.vertical)
            .accessibilityHidden(true)
        }
        
        private struct TemperatureMinMaxView: View {
            let min: Int
            let max: Int
            var body: some View {
                AdaptiveStack(horizontalSpacing: 0, verticalSpacing: 0) { sizeClass, typeSize in
                    sizeClass == .compact && typeSize > .large
                } content: {
                    HStack(spacing: 0){
                        Text(max.localizedTemp)
                            .fonted(.body, weight: .regular)
                        
                        
                        Image(systemName: Constants.SystemIcons.arrowUp)
                            .fonted(.subheadline, weight: .medium)
                            .foregroundColor(Constants.maxTempColor)
                        
                    }
                    
                    HStack(spacing: 0){
                        Image(systemName: Constants.SystemIcons.arrowDown)
                            .fonted(.subheadline, weight: .medium)
                            .foregroundColor(Constants.minTempColor)
                        Text(min.localizedTemp)
                            .fonted(.body, weight: .regular)
                    }.opacity(0.8)
                    
                    
                }
            }
        }
    }
    
    private struct ExtraDetailsGridView: View {
        
        @ObservedObject var viewModel: WeatherDetailsViewModel
        @Environment(\.dynamicTypeSize) var typeSize
        
        var body: some View {
            let columns: [GridItem] = typeSize > .large ? [.init(.flexible()), .init(.flexible())] : [.init(.flexible()), .init(.flexible()), .init(.flexible())]
            
            LazyVGrid(columns: columns) {
                ForEach(viewModel.extraDetailItems, id: \.self.id) { item in
                    GridCell(item: item)
                }
            }
        }
        
        private struct GridCell: View {
            let item: WeatherDetailsViewModel.ExtraDetailItem
            @EnvironmentObject var premium: Premium
            @Environment(\.isSubscriptionViewPresented) var isSubscriptionViewPresented
            
            var body: some View {
                
                
                VStack(alignment: .leading) {
                    item.title
                        .fonted(.subheadline, weight: .regular)
                        .lineLimit(1)
                        .opacity(Constants.primaryOpacity)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    Group{
                        if item.isLocked && item.value == 0.localizedNumber {
                            if (premium.isPremium) {
                                Text(Constants.notApplicable)
                                    .fonted(.body, weight: .regular)
                            }else {
                                Image(systemName: Constants.SystemIcons.lock)
                                    .foregroundColor(.accentColor)
                            }
                        }else {
                            Text(item.value)
                                .fonted(.body, weight: .regular)
                        }
                    }
                    .lineLimit(1)
                    .fonted(.headline, weight: .regular)
                    .frame(maxWidth: .infinity, alignment: .leading)
                }
                .padding()
                .background(Color(.tertiaryLabel).opacity(0.3))
                .cornerRadius(Constants.weatherTabRadius)
                .padding(.vertical, 1)
                .accessibilityElement(children: .combine)
                .isLocked(
                    item.isLocked && item.value == 0.localizedNumber && !premium.isPremium,
                    cornerRadius: Constants.weatherTabRadius,
                    isSubscriptionViewPresented: isSubscriptionViewPresented
                )
            }
        }
    }
    
}


struct PrecipitationDetailsView: View {
    @ObservedObject var viewModel: WeatherDetailsViewModel
    
    var body: some View {
        let pop = viewModel.selectedWeather.details.pop ?? 0
        let precipitation = viewModel.selectedWeather.details.precipitation ?? 0
        
        VStack(spacing:0) {
            HStack (spacing : 2){
                Image(systemName: Constants.SystemIcons.umbrella)
                    .fonted(.subheadline, weight: .regular)
                
                Text("Precipitation", tableName: "WeatherDetails")
                    .fonted(.body, weight: .regular)
            }
            .foregroundColor(Color.white.opacity(Constants.primaryOpacity))
            
            HStack {
                Text("Probability (%)", tableName: "WeatherTab")
                    .fonted(.subheadline, weight: .regular)
                    .lineLimit(1)
                
                Spacer()
                
                Text("Amount (\(viewModel.precipitationUnit.amount))", tableName: "General")
                    .lineLimit(1)
                    .fonted(.subheadline, weight: .regular)
            }
            .foregroundColor(Color.white.opacity(Constants.primaryOpacity))
            .padding(.vertical, 5)

            HStack(spacing : 0){
                
                Text(pop.localizedNumber)
                    .foregroundColor(Color.white)
                    .fonted(.headline, weight: .regular)
                    .frame(width:50)
                
                ProgressBarView(alignment: .trailing, progress: pop)
                    .frame(height: 12)
                
                Rectangle().fill(.gray)
                    .frame(width: 0.5, height: 20)
                    .padding(.horizontal, 4)

                
                ProgressBarView(
                    alignment: .leading,
                    progress: min(100, Int(precipitation * 10.0))
                )
                .frame(height: 12)
                
                Text(precipitation.localizedPrecipitation.removeZerosFromEnd())
                    .foregroundColor(Color.white)
                    .lineLimit(1)
                    .fonted(.headline, weight: .regular)
                    .frame(width:50)
            }
        }
        .dynamicTypeSize(...DynamicTypeSize.large)
        .padding(.horizontal,12)
        .padding(.vertical,10)
        .background(Color(.tertiaryLabel).opacity(0.3))
        .background(Constants.precipitationBg)
        .cornerRadius(Constants.weatherTabRadius)
        .accessibilityElement(children: .combine)
    }
}
#if DEBUG
struct WeatherDetailsView_Previews: PreviewProvider {
    static let premium = Premium()
    static var previews: some View {
        WeatherDetailsView(viewModel: .init(type: .daily, tappedWeather: nil, weatherData: Repository().getDefaultOrCachedWeatherData(), aqiData: .init(), astronomies: [.init()], premium: premium))
            .environmentObject(premium)
    }
}
#endif
