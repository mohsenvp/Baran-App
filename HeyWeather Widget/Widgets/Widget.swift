//
//  MainWidget.swift
//  WeatherApp
//
//  Created by RezaRg on 8/1/20.
//

import WidgetKit
import SwiftUI
import Intents


@main
struct Widgets: WidgetBundle {

    @WidgetBundleBuilder
    var body: some Widget {
        
        #if !os(watchOS)
        ForecastWidget()
        CustomizableWidget()
        AQIWidget()
        if #available(iOSApplicationExtension 16.1, *) {
            PrecipitationActivityLiveActivity()
        }
        #endif
        
        LockscreenWeatherWidgets().body
        LockscreenDetailsWidgets().body
    }
}


struct LockscreenWeatherWidgets: WidgetBundle {

    @WidgetBundleBuilder
    var body: some Widget {
        LockScreenWeatherWidget(widgetKind : .currentOne)
        LockScreenWeatherWidget(widgetKind : .currentTwo)
        LockScreenWeatherWidget(widgetKind : .hourlyOne)
        LockScreenWeatherWidget(widgetKind : .hourlyTwo)
        LockScreenWeatherWidget(widgetKind : .dailyOne)
        LockScreenWeatherWidget(widgetKind : .dailyTwo)
    }
}

struct LockscreenDetailsWidgets: WidgetBundle {

    @WidgetBundleBuilder
    var body: some Widget {
        LockScreenWeatherWidget(widgetKind : .precipitation)
        LockScreenWeatherWidget(widgetKind : .cloudiness)
        LockScreenWeatherWidget(widgetKind : .uv)
        LockScreenWeatherWidget(widgetKind : .humidity)
        LockScreenAQIWeatherWidget()
    }
}
