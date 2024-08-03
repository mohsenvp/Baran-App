//
//  WeatherTabItem.swift
//  HeyWeather
//
//  Created by Mohammad Yeganeh on 10/17/23.
//

import SwiftUI

struct WeatherTabItem: View {
    
    @ObservedObject var weatherTabState: WeatherTabState
    @EnvironmentObject var premium: Premium
    @ObservedObject var viewModel: WeatherTabViewModel
    
    
    var body: some View {
        ZStack(alignment: .top){
           
            ScrollView(showsIndicators: false) {
                VStack(spacing: 0){
                    
                    WeatherTabHeader(weatherTabState: weatherTabState, onManageCitiesTapped: {
                        viewModel.navigateDetails(.cityList)
                    }, onClimateTapped: {
                        weatherTabState.isClimatePresented.toggle()
                    }, onTimeTravelTapped: {
                        weatherTabState.isTimeTravelPresented.toggle()
                    })

                    
                    LazyVStack {
                        //MARK: Weather Alerts
                        if weatherTabState.weatherData.alerts.count > 0 {
                            Button {
                                viewModel.navigateDetails(.weatherAlerts)
                            } label: {
                                WeatherAlertView(alerts: weatherTabState.weatherData.alerts)
                            }
                            .buttonStyle(.plain)
                            .transition(.scale)
                        }
                        //MARK: Precipitation Chart View
                        if weatherTabState.weatherData.precipitation.chartData.count > 0 {
                            PrecipitationView(precipitation: weatherTabState.weatherData.precipitation) {
                                weatherTabState.trackPrecipitationActivity()
                            }
                        }
                        
                        if weatherTabState.weatherData.today.description.isAvailable {
                            DescriptionView(description: weatherTabState.weatherData.today.description)
                        }

                        //MARK: Hourly Forecast View
                        HourlyForecastView(
                            hourlyWeather: weatherTabState.weatherData.getHourly(isPremium: premium.isPremium, isDetail: false)
                        ) {
                            weatherTabState.tappedWeather = nil
                            viewModel.navigateDetails(.hourly)
                        }  onWeatherTapped: { weather in
                            weatherTabState.tappedWeather = weather
                            viewModel.navigateDetails(.hourly)
                        }
                        .animation(nil, value: weatherTabState.weatherData)
                        

                        //MARK: Daily Forecast View
                        DailyForecastView(
                            dailyWeather: weatherTabState.weatherData.getDaily(isPremium: premium.isPremium, isDetail: false)
                        ) {
                            weatherTabState.tappedWeather = nil
                            viewModel.navigateDetails(.daily)
                        }  onWeatherTapped: { weather in
                            weatherTabState.tappedWeather = weather
                            viewModel.navigateDetails(.daily)
                        }
                        .animation(nil, value: weatherTabState.weatherData)


                        //MARK: Sunrise|Sunset View
                        SunView(
                            sun: weatherTabState.astronomy.sun
                        )
                        .onTapGesture {
                            viewModel.isSunDetailsViewPresented.toggle()
                        }
                        .redacted(isRedacted: weatherTabState.isAstronomyRedacted)
                        
                        //MARK: Wind View
                        if let wind = weatherTabState.weatherData.today.details.windSpeed {
                            Button {
                                viewModel.presentExtraDetailModal(type: .wind)
                            } label: {
                                WeatherDetailsSmallView(
                                    type: .wind,
                                    value: wind.localizedWindSpeed,
                                    windDirection: weatherTabState.weatherData.today.details.windDegree
                                )
                            }
                            .accentColor(.init(.label))
                        }

                        //MARK: AQI View
                        Button {
                            viewModel.presentModal(.aqi)
                        } label: {
                            AQIView(aqi: weatherTabState.aqiData.current).weatherTabShape()
                        }
                        .accentColor(.init(.label))
                        .redacted(isRedacted: weatherTabState.isAQIRedacted)
                        
                        
                        //MARK: ExtraDetail Cards
                        extraDetailCards
                        
                        
                        //MARK: Moon View
                        Button {
                            viewModel.presentModal(.astronomy)
                        } label: {
                            MoonView(moon: weatherTabState.astronomy.moon)
                        }.accentColor(.init(.label))
                            .redacted(isRedacted: weatherTabState.isAstronomyRedacted)
                    }
                    .padding()
                    .padding(.bottom, 20)
                }
            }
            .coordinateSpace(name: Constants.weatherTabCoordinateSpace)

        }
        .ignoresSafeArea(.all, edges: [.top])
        .redacted(isRedacted: weatherTabState.isWeatherRedacted)
        .overlay {
            if weatherTabState.weatherData.today.condition.type == .storm {
                StormView(intensity: weatherTabState.weatherData.today.condition.intensity)
                    .edgesIgnoringSafeArea(.all)
            }
            if weatherTabState.retryShown {
                RetryView(
                    latestCacheDate: weatherTabState.latestCacheDate,
                    networkFailResponse: weatherTabState.networkFailResponse
                ) {
                    AppState.shared.isLoading.toggle()
                    weatherTabState.updateData()
                } onLoadFromCache: {
                    weatherTabState.updateData(forceCache: true)
                }
            }
        }
        .alert(isPresented: $weatherTabState.liveActivityPermissionAlertPresented, content: {
            Alerts.generalAlert(
                title: Text("Live Activities are Disabled", tableName: "Alerts"),
                message: Text("Go to HeyWeather settings and enable Live Activities", tableName: "Alerts"),
                defaultBt: Text("Open Settings", tableName: "Alerts")
            ) {
                AppState.shared.navigateToAppSettingPage()
            }
        })
        .alert(isPresented: $weatherTabState.liveActivityHasActiveAlertPresented, content: {
            Alerts.generalAlert(
                title: Text("You have an active Live Activity", tableName: "Alerts"),
                message: Text("Do you want to replace precipitation on your current Live Activity with this one?", tableName: "Alerts"),
                defaultBt: Text("Yes, Replace it.", tableName: "Alerts"),
                cancelBtn: Text("No.", tableName: "Alerts")
            ) {
                weatherTabState.trackPrecipitationActivity(overrideCurrent: true)
            }
        })
        .sheet(isPresented: $weatherTabState.isClimatePresented) {
            ClimateDetailView(viewModel: .init(city: weatherTabState.city), isPresented: $weatherTabState.isClimatePresented)
                .environmentObject(viewModel.premium)
        }
        .sheet(isPresented: $weatherTabState.isTimeTravelPresented) {
            TimeTravelView(viewModel: .init(city: weatherTabState.city), isPresented: $weatherTabState.isTimeTravelPresented)
                .environmentObject(viewModel.premium)
        }
        
    }
    
    
    
    @ViewBuilder var extraDetailCards: some View {
        let details = weatherTabState.weatherData.today.details
        HStack {
            //MARK: Humidity View
            if let humidityDescription = details.humidityDescription {
                Button {
                    viewModel.presentExtraDetailModal(type: .humidity)
                } label: {
                    WeatherDetailsSmallView(
                        type: .humidity,
                        value: humidityDescription
                    )
                }.accentColor(.init(.label))
            }
            
            //MARK: Pressure View
            if let pressure = details.pressure {
                Button {
                    viewModel.presentExtraDetailModal(type: .pressure)
                } label: {
                    WeatherDetailsSmallView(
                        type: .pressure,
                        value: pressure.localizedPressure
                    )
                }.accentColor(.init(.label))
            }
        }
        
        
        HStack {
            //MARK: Dew Point View
            if let dewPoint = details.dewPoint {
                Button {
                    viewModel.presentExtraDetailModal(type: .dewPoint)
                } label: {
                    WeatherDetailsSmallView(type: .dewPoint,
                                            value: dewPoint.localizedDewPoint)
                }.accentColor(.init(.label))
            }
            
            //MARK: Visibility View
            if let visibility = details.visibility {
                Button {
                    viewModel.presentExtraDetailModal(type: .visibility)
                } label: {
                    WeatherDetailsSmallView(type: .visibility,
                                            value: visibility.localizedVisibility)
                }.accentColor(.init(.label))
            }
        }
        
        
        
        HStack {
            //MARK: Cloudiness View
            if let cloudiness = details.clouds {
                Button {
                    viewModel.presentExtraDetailModal(type: .clouds)
                } label: {
                    WeatherDetailsSmallView(type: .clouds,
                                            value: cloudiness.localizedNumber + Constants.percent)
                }.accentColor(.init(.label))
            }
            
            //MARK: UVIndex View
            if let uvindex = details.uvIndex {
                Button {
                    viewModel.presentExtraDetailModal(type: .uvIndex)
                } label: {
                    WeatherDetailsSmallView(type: .uvIndex,
                                            value: uvindex.localizedNumber())
                }.accentColor(.init(.label))
            }
        }
        
  
        
    }
}
