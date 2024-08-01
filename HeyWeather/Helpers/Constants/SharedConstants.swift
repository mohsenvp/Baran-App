//
//  SharedConstants.swift
//  HeyWeather
//
//  Created by Mohammad Yeganeh on 8/7/23.
//

import Foundation
import SwiftUI
import UIKit

extension Constants {
    
    static let appStoreID = 1532052012

    
    // MARK: Trying to test rounded font:
    static let appFontDesign : Font.Design = .rounded
    
    // MARK: Not Premium limits Constants
    static let maxPremiumHourly = 48
    static let maxNotPremiumHourly = 24
    static let maxPremiumDaily = 8
    static let maxNotPremiumDaily = 7
    
    #if os(iOS)
    static let systemVersionIn4Digit: Double = Double(UIDevice.current.systemVersion.prefix(4)) ?? 0
    #endif
    
    // MARK: String Constants
    static let googleMapApiKey = "AIzaSyBb429LGcveFC90kWM2oqJQoU15J4SvAH4"//no need to be worried about securities here, key is restricted
    static let appGroupBundleId = "group.com.app.heyweather"
    static let appBundleId = "com.app.heyweather"

    static let imagesURL = "https://v2.heyweatherapp.com/images/"
    
    static let termURL = "https://heyweatherapp.com/terms"
    static let privacyURL = "https://heyweatherapp.com/privacy"
    static let aboutUsURL = "https://v2.heyweatherapp.com/about"
    static let appStoreURL = "https://apps.apple.com/us/app/id\(appStoreID)"
    
    static let hexAccent: Color = .init(hex: "#9975FF")
    static let twitterColorCode = Color(#colorLiteral(red: 0, green: 0.6745098039, blue: 0.9333333333, alpha: 1))
    static let twitterAccount = "heyweatherapp"
    static let twitterAccountApp = "twitter://user?screen_name=\(twitterAccount)"
    static let twitterAccountUrl = "https://twitter.com/\(twitterAccount)"
    
    static let redditColorCode = Color(#colorLiteral(red: 1, green: 0.3411764706, blue: 0, alpha: 1))
    static let redditAccount = "heyweatherapp"
    static let redditAccountApp = "reddit://r/\(redditAccount)"
    static let redditAccountUrl = "https://www.reddit.com/r/\(redditAccount)"
    
    static let lightMapStyleURL = "https://v2.heyweatherapp.com/lightMapStyle.json"
    static let darkMapStyleURL = "https://v2.heyweatherapp.com/darkMapStyle.json"
    
    static let weatherTabCoordinateSpace = "WeatherTabScrollCoordinator"
    static let appIcons = [ "AppIcon-0", "AppIcon-1", "AppIcon-2", "AppIcon-3", "AppIcon-4", "AppIcon-5", "AppIcon-6", "AppIcon-7", "AppIcon-8" ]
    static let primaryRowBg = "bg-row-1"
    static let primaryRowBgReversed = "r-bg-row-1"
    static let secondaryRowBg = "bg-row-2"
    static let coolBackground = "bg-cool"
    
    static let selectedRowBg = "bg-row-selected"
    static let default3DIconSet = "s01"
    static let defaultIconSet = "s00"
    static let defaultTabBarIconSet = "s04"
    static let defaultLockScreenWidgetIconSet = "s00"
    static let defaultWatchIconSet = "s00"
    static let defaultTimeTravelIconSet = "s02"
    static let defaultLightIconSet = "03"
    static let defaultDarkIconSet = "07"

    static let shouldUpdateWeatherPublisherName = "shouldUpdateWeather"
    static let shouldUpdateWeatherPublisher = NotificationCenter.default.publisher(for: NSNotification.Name(Constants.shouldUpdateWeatherPublisherName)).eraseToAnyPublisher()
    
    static let shouldUpdateAQIPublisherName = "shouldUpdateAQI"
    static let shouldUpdateAQIPublisher = NotificationCenter.default.publisher(for: NSNotification.Name(Constants.shouldUpdateAQIPublisherName)).eraseToAnyPublisher()
    
    static let premiumPurchaseWasSuccessfulName = "premiumPurchaseWasSuccessful"
    static let premiumPurchaseWasSuccessfulPublisher = NotificationCenter.default.publisher(for: NSNotification.Name(Constants.premiumPurchaseWasSuccessfulName)).eraseToAnyPublisher()
    
    static let cityListChangedName = "cityListChanged"
    static let cityListChangedPublisher = NotificationCenter.default.publisher(for: NSNotification.Name(Constants.cityListChangedName)).eraseToAnyPublisher()
    
    static let ic = "ic_"
    static let days = "days"
    
    // MARK: Sign Constants
    static let notApplicable = "N/A"
    static let none = "-"
    static let dash = "-"
    static let space = " "
    static let dot = "."
    static let colonAndSpace = ": "
    static let commaAndSpace = ", "
    static let spaceSlashSpace = " / "
    static let spaceDashSpace = " - "
    static let slash = "/"
    static let percent = "%"
    static let degree = "°"
    static let openParen = "("
    static let closeParen = ")"
    static let arrowUpSymbol = "↑"
    static let arrowDownSymbol = "↓"
    // MARK: Default Units
    static let defaultTempUnit = getDefaultTempType()
    static let defaultPressureUnit = PressureUnit.hPa
    static let defaultPrecipitationUnit = PrecipitationUnit.mm
    static let defaultSpeedUnit = SpeedUnit.mps
    static let defaultDistanceUnit = DistanceUnit.km
    
    // MARK: MailTypes
    enum MailType: String { case bugReport = "bug_report", featureRequest = "feature_request", general = "general", purchaseProblem = "purchase_problem", helpToTranslate = "help_to_translate" }
    
    static let now = Date()
    static let weatherTabRadius = 17.0
    static let widgetRadius = 25.0
    
    static let tempUnitString = UserDefaultsKey.tempUnit.rawValue
    static let speedUnitString = UserDefaultsKey.speedUnit.rawValue
    static let distanceUnitString = UserDefaultsKey.distanceUnit.rawValue
    static let pressureUnitString = UserDefaultsKey.pressureUnit.rawValue
    static let precipitationUnitString = UserDefaultsKey.precipitationUnit.rawValue
    static let groupUserDefaults = UserDefaults(suiteName: Constants.appGroupBundleId)
    
    static private func getDefaultTempType() -> TemperatureUnit {
        if let savedUnit: String = UserDefaults.get(for: .tempUnit) {
            return TemperatureUnit(rawValue: savedUnit) ?? .celsius
        }else {
            let myFormatter = MeasurementFormatter()
            let temperature = Measurement(value: 0, unit: UnitTemperature.celsius)
            let unit = myFormatter.string(from: temperature).justChars()
            switch unit {
            case "K":
                UserDefaults.save(value: TemperatureUnit.kelvin.rawValue, for: .tempUnit)
                return .kelvin
            case "F":
                UserDefaults.save(value: TemperatureUnit.fahrenheit.rawValue, for: .tempUnit)
                return .fahrenheit
            default:
                UserDefaults.save(value: TemperatureUnit.celsius.rawValue, for: .tempUnit)
                return .celsius
            }
        }
    }
    
    #if os(watchOS)
    static let motionReduced: Bool = false
    #else
    static let motionReduced: Bool = UIAccessibility.isReduceMotionEnabled
    #endif
    
    
    // MARK: Other Constants
    static let primaryOpacity = motionReduced ? 1 : 0.6
    static let secondaryOpacity = motionReduced ? 1 : 0.5
    static let tertiaryOpacity = motionReduced ? 1 : 0.2
    static let pointThreeOpacity = motionReduced ? 1 : 0.3
    static let pointSevenOpacity = motionReduced ? 1 : 0.7
    static let smallOpacity = motionReduced ? 1 : 0.1
    static let accentColor = Color("AccentColor")

    static let climateGradient: LinearGradient = LinearGradient(colors: [.init(hex: "54C1FF"), .init(hex: "6B38FC")], startPoint: .leading, endPoint: .trailing)
    static let weatherBackgroundSunrise: LinearGradient = LinearGradient(colors: [Color(#colorLiteral(red: 0.06666666667, green: 0.03137254902, blue: 0.2392156863, alpha: 1)), Color(#colorLiteral(red: 0.3607843137, green: 0.2431372549, blue: 0.4470588235, alpha: 1)), Color(#colorLiteral(red: 0.6, green: 0.4117647059, blue: 0.568627451, alpha: 1)), Color(#colorLiteral(red: 0.7882352941, green: 0.568627451, blue: 0.5803921569, alpha: 1)), Color(#colorLiteral(red: 0.9137254902, green: 0.6392156863, blue: 0.5019607843, alpha: 1))], startPoint: .top, endPoint: .bottom)
    static let weatherBackgroundNoon: LinearGradient = LinearGradient(colors: [Color(#colorLiteral(red: 0.3647058824, green: 0.7647058824, blue: 0.9803921569, alpha: 1)), Color(#colorLiteral(red: 0.5137254902, green: 0.7607843137, blue: 0.968627451, alpha: 1))], startPoint: .top, endPoint: .bottom)
    static let weatherBackgroundAfternoon: LinearGradient = LinearGradient(colors: [Color(#colorLiteral(red: 1, green: 0.9215686275, blue: 0.7058823529, alpha: 1)), Color(#colorLiteral(red: 1, green: 0.7490196078, blue: 0.662745098, alpha: 1))], startPoint: .top, endPoint: .bottom)
    static let weatherBackgroundSunset: LinearGradient = LinearGradient(colors: [Color(#colorLiteral(red: 0.4196078431, green: 0.2196078431, blue: 0.9882352941, alpha: 1)), Color(#colorLiteral(red: 0.5568627451, green: 0.2196078431, blue: 0.9882352941, alpha: 1)), Color(#colorLiteral(red: 0.7411764706, green: 0.2196078431, blue: 0.9882352941, alpha: 1)), Color(#colorLiteral(red: 0.9333333333, green: 0.1568627451, blue: 1, alpha: 1)), Color(#colorLiteral(red: 1, green: 0.1098039216, blue: 0.9647058824, alpha: 1))], startPoint: .top, endPoint: .bottom)
    static let weatherBackgroundNight: LinearGradient = LinearGradient(colors: [Color(#colorLiteral(red: 0.2156862745, green: 0.2705882353, blue: 0.3882352941, alpha: 1)), Color(#colorLiteral(red: 0.1215686275, green: 0.1490196078, blue: 0.2156862745, alpha: 1))], startPoint: .top, endPoint: .bottom)
    static let weatherBackgroundMidnight: LinearGradient = LinearGradient(colors: [Color(#colorLiteral(red: 0.03137254902, green: 0.06666666667, blue: 0.231372549, alpha: 1)), Color(#colorLiteral(red: 0.02352941176, green: 0.05490196078, blue: 0.1882352941, alpha: 1))], startPoint: .top, endPoint: .bottom)
    static let conditionBackgroundRain: LinearGradient = LinearGradient(colors: [Color(#colorLiteral(red: 0.2823529412, green: 0.368627451, blue: 0.4549019608, alpha: 1)), Color(#colorLiteral(red: 0.2352941176, green: 0.3254901961, blue: 0.4117647059, alpha: 1))], startPoint: .top, endPoint: .bottom)
    static let conditionBackgroundDrizzle: LinearGradient = LinearGradient(colors: [Color(#colorLiteral(red: 0.3882352941, green: 0.4901960784, blue: 0.5921568627, alpha: 1)), Color(#colorLiteral(red: 0.6509803922, green: 0.7450980392, blue: 0.8392156863, alpha: 1))], startPoint: .top, endPoint: .bottom)
    static let conditionBackgroundSnow: LinearGradient = LinearGradient(colors: [Color(#colorLiteral(red: 0.9254901961, green: 0.9764705882, blue: 1, alpha: 1)), Color(#colorLiteral(red: 1, green: 0.9843137255, blue: 0.9215686275, alpha: 1))], startPoint: .top, endPoint: .bottom)
    static let conditionBackgroundStorm: LinearGradient = LinearGradient(colors: [Color(#colorLiteral(red: 0.05098039216, green: 0.1137254902, blue: 0.2039215686, alpha: 1)), Color(#colorLiteral(red: 0.1921568627, green: 0.2705882353, blue: 0.3764705882, alpha: 1))], startPoint: .top, endPoint: .bottom)
    static let conditionBackgroundNotLoaded: LinearGradient = LinearGradient(colors: [Color(#colorLiteral(red: 0.4392156863, green: 0.4392156863, blue: 0.4392156863, alpha: 1)), Color(#colorLiteral(red: 0.5019607843, green: 0.5019607843, blue: 0.5019607843, alpha: 1))], startPoint: .top, endPoint: .bottom)
    static let aqiColors: [Color] = [.init(hex: "4ECD94"), .init(hex: "B8CF7C"), .init(hex: "F1D573"), .init(hex: "E2A16D"), .init(hex: "D57672"), .init(hex: "9880B0")]

    
    struct Particles {
        static let rain: String = "RainParticles.sks"
        static let snow: String = "SnowParticles.sks"
        static let cloud: String = "MinimalCloudParticles.sks"
        static let drizzle: String = "DrizzleParticles.sks"
    }
    
    struct ViewTitles {
        static let welcomeViews: String = "WelcomeViews"
        static let weatherTab: String = "WeatherTab"
        static let widgetTab: String = "WidgetTab"
        static let customizableWidgets: String = "CustomizableWidgets"
        static let otherWidgets: String = "OtherWidgets"
        static let mapsTab: String = "MapsTab"
        static let settingsTab: String = "SettingsTab"
        static let subscriptionView: String = "SubscriptionView"
        static let cityList: String = "CityList"
        static let searchCityView: String = "SearchCityView"
    }
}

// MARK: - Fail Responses

enum NetworkFailResponse: String, CaseIterable, Error {
    case noInternet
    case internalServer
    case notModified
    case badRequest
    case unauthorized
    case forbidden
    case notFound
    case conflict
    case unknown
    case appStorePlans
    case outOfSync
}

// MARK: - Icons

extension Constants {
    enum SystemIcons {
        static let zzz = "zzz"
        static let xmark = "xmark"
        static let sunMin = "sun.min"
        static let rectAndPencil = "rectangle.and.pencil.and.ellipsis"
        static let map = "map"
        static let gearshape = "gearshape"
        static let sunMax = "sun.max"
        static let sunrise = "sunrise"
        static let sunset = "sunset"
        static let cloudMoonRain = "cloud.moon.rain"
        static let arrowUp = "arrow.up"
        static let arrowDown = "arrow.down"
        static let arrowRight = "arrow.right"
        static let arrowLeft = "arrow.left"
        static let location = "location"
        static let mapPin = "mappin.and.ellipse"
        static let arrowTriangleUp = "arrowtriangle.up"
        static let arrowTriangleDown = "arrowtriangle.down"
        static let wind = "wind"
        static let sparkles = "sparkles"
        static let uCircle = "u.circle"
        static let compressVertical = "rectangle.compress.vertical"
        static let aqiMedium = "aqi.medium"
        static let moonFill = "moon.fill"
        static let chevronRight = "chevron.right"
        static let chevronDown = "chevron.down"
        static let squareAndArrowUp = "square.and.arrow.up"
        static let star = "star.fill"
        static let checkmark = "checkmark"
        static let checkmarkCircle = "checkmark.circle"
        static let plus = "plus.app"
        static let trash = "trash"
        static let magnifyingGlass = "magnifyingglass"
        static let appPlus = "plus.app.fill"
        static let play = "play"
        static let pause = "pause"
        static let layers = "square.3.layers.3d.down.right"
        static let squareGrid = "square.grid.2x2"
        static let umbrella = "umbrella"
        static let infoCircle = "info.circle"
        static let appsIphone = "apps.iphone"
        static let minusCircle = "minus.circle"
        static let lock = "lock.fill"
        static let refresh = "arrow.triangle.2.circlepath"
        static let cloud = "cloud"
        static let cloudFill = "cloud.fill"
        static let humidity = "humidity"
        static let humidityFill = "humidity.fill"
        static let wifiSlash = "wifi.slash"
        static let clockArrowCircle = "clock.arrow.circlepath"
        static let clockLiveActivity = "clock.badge"
        static let listBullet = "list.bullet"
        static let questionmarkCircle = "questionmark.circle"
        static let extensionPuzzle = "puzzlepiece.extension"
        static let cloudSunRain = "cloud.sun.rain"
        static let timer = "timer"
    }

    enum Icons {
        static let moonrise = "moonrise"
        static let moonset = "moonset"
        static let sunrise = "sunrise"
        static let sunset = "sunset"
        static let astronomyWidgetBg = "astronomy-widget"
        static let compass = "ic_compass"
        static let location = "ic_location"
        static let unknownFlag = "unknown-flag"
        static let premium = "ic_premium"
        static let bestUserCrown = "best_user_crown"
        static let widgetBg = "ic_widget_bg"
        static let logoart = "logoart"
        static let radialSun = "radial_sun"
        static let onBoardingWidgets = "OnBoardingWidgets"
        static let onBoardingPageOne = "OnBoardingFirstPage"
        static let onBoardingPageTwo = "OnBoardingSecondPage"
        static let onBoardingPageThree = "OnBoardingThirdPage"
        static let onBoardingCityPin = "cityPin"
        static let windmillBody = "windmill_body"
        static let windmillHead = "windmill_head"
        static let sun = "sun"
        static let gcoLogo = "gcologo"
        static let checked = "ic_checked"
        static let umbrella = "umbrella_simple"
        static let umbrellaDeactive = "umbrella_simple_deactive"
        static let circleArrow = "circle_arrow"
        static let logoSun = "logo_sun"
        static let logoCircle = "logo_circle"
        static let tabWidget = "tab_widget"
        static let tabMap = "tab_map"
        static let tabSetting = "tab_setting"
        static let locationPin = "ic_location_pin"
        static let circleMenu = "ic_circle_menu"
        static let warning = "ic_warning"
        static let themeAuto = "ic_sparkle"
        static let themeDark = "ic_moon"
        static let themeLight = "ic_sun"
        static let timeFormat12 = "ic_12clockwise"
        static let timeFormat24 = "ic_24clockwise"
        
        static let notifTodaySummary = "ic_notif_calendar_check"
        static let notifTomorrowOutlook = "ic_notif_calendar_arrow_right"
        static let notifRainAlert = "ic_notif_rainy_cloud"
        static let notifHighUV = "ic_uv"
        static let notifHighTemperature = "ic_notif_thermometer_hot"
        static let notifLowTemperature = "ic_notif_thermometer_cold"
        static let notifHighWind = "ic_notif_wind"
        static let notifPoorAQI = "ic_notif_aqi"
        static let notifSnowAlert = "ic_notif_snowflake"
        static let notifFullMoon = "ic_moon"
        static let notifSevereWeather = "ic_warning"

        static func getIconName(for type: WeatherDetailsViewType) -> String {
            switch type {
            case .wind:
                return "ic_wind"
            case .pressure:
                return "ic_pressure"
            case .humidity:
                return "ic_humidity"
            case .dewPoint:
                return "ic_dew"
            case .visibility:
                return "ic_visibility"
            case .uvIndex:
                return "ic_uv"
            case .clouds:
                return "ic_clouds"
            case .precipitation:
                return "ic_precipitation"
            }
        }
        static func getIconName(for aqiIndex: Int) -> String {
            let iconName: String = Constants.ic + "aqi_\(aqiIndex)"
            return iconName
        }
        
    }
    
    enum TutorialImages {
        static let homeScreenTutorialFirstPage = "tutorial_homeScreenFirstPage"
        static let homeScreenTutorialSecondPage = "tutorial_homeScreenSecondPage"
        static let homeScreenTutorialThirdPage = "tutorial_homeScreenThirdPage"
        static let homeScreenTutorialFourthPage = "tutorial_homeScreenFourthPage"
    }
    
    static func Icon(for settingsType: SettingsRowType) -> Image {
        return Image(ic.appending(settingsType.rawValue))
    }
    
}
