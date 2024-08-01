//
//  WidgetTab.swift
//  HeyWeather
//
//  Created by Kamyar on 10/27/21.
//

import SwiftUI

struct WidgetTab: View {
    @StateObject var viewModel: WidgetTabViewModel = .init()
    @EnvironmentObject var premium: Premium
    @State var isForecastSheetPresented: Bool = false
    @State var isAqiSheetPresented: Bool = false

    var body: some View {
        NavigationStack {
            ScrollView(showsIndicators: false){
                VStack {
                    Button{
                        isForecastSheetPresented.toggle()
                    } label: {
                        WidgetKindCell(kind: .forecast, weatherData: viewModel.weatherData,
                                       aqi: viewModel.aqiData.current,
                                       moon: viewModel.astronomy.moon)
                    }
                    .foregroundColor(.init(.label))
                    .buttonStyle(.plain)
                    
                    NavigationLink {
                        CustomizableWidgets(viewModel: .init(weatherData: viewModel.weatherData))
                    } label: {
                        WidgetKindCell(kind: .customizable, weatherData: viewModel.weatherData,
                                       aqi: viewModel.aqiData.current,
                                       moon: viewModel.astronomy.moon)
                    }
                    .isDetailLink(false)
                    .foregroundColor(.init(.label))
                    .buttonStyle(.plain)
                    
                    Button{
                        isAqiSheetPresented.toggle()
                    } label: {
                        WidgetKindCell(kind: .aqi, weatherData: viewModel.weatherData,
                                       aqi: viewModel.aqiData.current,
                                       moon: viewModel.astronomy.moon)
                    }
                    .foregroundColor(.init(.label))
                    .buttonStyle(.plain)
                    
                }
                .padding(.bottom)
            }
            .navigationTitle(Text("Widgets", tableName: "TabItems"))
            .navigationViewStyle(.stack)
            
            .onAppear { viewModel.loadData() }
        }
        .navigationViewStyle(.stack)
        .background(Color(.systemGroupedBackground).edgesIgnoringSafeArea(.all))
        .sheet(isPresented: $isForecastSheetPresented) {
            ForecastWidgetsView(isPresented: $isForecastSheetPresented, weatherData: viewModel.weatherData)
        }
        .sheet(isPresented: $isAqiSheetPresented) {
            AQIWidgetsShowcaseView(isPresented: $isAqiSheetPresented, weatherData: viewModel.weatherData, aqiData: viewModel.aqiData, premium: premium)
        }
    }
    
    struct WidgetKindCell: View {
        let kind: WidgetKind
        let weatherData: WeatherData
        let aqi: AQI
        let moon: MoonDataModel
        var title: Text {
            switch kind {
            case .customizable:
                Text("Customizable Widgets", tableName: "Widgets")
            case .forecast:
                Text("Forecast Widgets", tableName: "Widgets")
            case .aqi:
                Text("AQI Widgets", tableName: "Widgets")
            }
        }
        var description: Text {
            switch kind {
            case .customizable:
                Text("Customizable widgets: Personalize every aspect as desired in the app.", tableName: "Widgets")
            case .forecast:
                Text("Forecast Widgets offering hourly and daily forecast, customizable by long-pressing the widget (PREMIUM)", tableName: "Widgets")
            case .aqi:
                Text("Protect yourself from pollution with AQI Forecast Widgets", tableName: "Widgets")
            }
        }
        var body: some View {
            VStack(alignment: .leading, spacing: 0){
                
                HStack {
                    title.fonted(.title3, weight: .semibold)
                    Spacer()
                    Image(systemName: Constants.SystemIcons.arrowRight)
                        .fonted(.title3, weight: .semibold)
                        .flipsForRightToLeftLayoutDirection(true)
                }
                .frame(maxWidth: Constants.mediumWidgetSize.width, alignment: .leading)
                .padding(.horizontal, 22)
                .padding(.top, 12)
                .unredacted()
                
                Group {
                    switch kind {
                    case .forecast:
                        ForecastWidgetFamily(
                            weather: weatherData,
                            setting: ForecastWidgetSetting(
                                widgetLook: .neumorph,
                                widgetBackground: .def,
                                forcastType: .both,
                                showCityName: true
                            ),
                            widgetSize: .systemMedium,
                            isPreviewForAppWidgetTab: true
                        )
                    case .customizable:
                        MediumWidgetView2(
                            weather: weatherData,
                            theme: .init(
                                colorStart: Constants.colorStyles[0][0],
                                colorEnd: Constants.colorStyles[0][1],
                                iconSet: "07",
                                fontColor: Constants.colorStyles[0][2]
                            ),
                            isPreviewForAppWidgetTab: true
                        )
                    case .aqi:
                        AQIWidgetFamily(
                            weather: .init(),
                            aqiData: .init(),
                            setting: .init(widgetStyle: .guage, showCityName: true),
                            widgetSize: .systemMedium,
                            id: 1,
                            isPreviewForAppWidgetTab: true
                        )
                        .background(Color.systemsBackground)
                    }
                }
                .accessibilityHidden(true)
                .cornerRadius(Constants.widgetRadius - 2)
                .frame(height: Constants.mediumWidgetSize.height)
                .frame(maxWidth: Constants.mediumWidgetSize.width * 1.1)
                .padding(EdgeInsets(top: 8, leading: 12, bottom: 8, trailing: 12))
                
                description
                    .fonted(.body, weight: .regular)
                    .opacity(Constants.primaryOpacity)
                    .multilineTextAlignment(.leading)
                    .frame(maxWidth: Constants.mediumWidgetSize.width, alignment: .leading)
                    .padding(.bottom)
                    .padding(.horizontal)
                    .unredacted()
                
                
            }
            .background(
                ZStack {
                    Constants.getBgColor(for: kind).opacity(0.2)
                }
            )
            .cornerRadius(Constants.widgetRadius)
            .padding(.horizontal)
            .padding(.top)
        }
    }
}

#if DEBUG
struct WidgetTab_Previews: PreviewProvider {
    static var previews: some View {
        WidgetTab()
    }
}
#endif
