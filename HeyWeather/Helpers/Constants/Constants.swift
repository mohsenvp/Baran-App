//
//  Constants.swift
//  HeyWeather
//
//  Created by Kamyar on 10/10/21.
//

import Foundation
import UIKit
import SwiftUI

struct Constants {
    
#if os(iOS) || os(macOS)
    // MARK: Screen Constants
    static let screenWidth = UIScreen.main.bounds.width
    static let screenHeight = UIScreen.main.bounds.height
    static let smallWidgetSize = screenHeight.getWidgetSize(for: .systemSmall)
    static let mediumWidgetSize = screenHeight.getWidgetSize(for: .systemMedium)
    static let largeWidgetSize = screenHeight.getWidgetSize(for: .systemLarge)
    static let isWidthCompact = UIScreen.main.bounds.width < 390
    // MARK: isDevice Constants
    static let isIpad = UIDevice.current.userInterfaceIdiom == .pad
#if targetEnvironment(macCatalyst)
    static let isMac = true
#else
    static let isMac = false
#endif
    static let AmericanTypewriteFontName = "American Typewriter"
    static let maxDynamicType: DynamicTypeSize = Constants.isWidthCompact ? DynamicTypeSize.xxxLarge : DynamicTypeSize.accessibility1
    
    
    // MARK: Widget Themes
    static let defaultTheme1 = WidgetTheme(colorStart: colorStyles[0][0] , colorEnd: colorStyles[0][1], iconSet: "03", fontColor: colorStyles[0][2])
    static let defaultTheme2 = WidgetTheme(colorStart: colorStyles[1][0] , colorEnd: colorStyles[1][1], iconSet: "02", fontColor: colorStyles[1][2])
    static let defaultTheme3 = WidgetTheme(colorStart: colorStyles[2][0] , colorEnd: colorStyles[2][1], iconSet: "01", fontColor: colorStyles[2][2])
    
    
    // MARK: Colors
    static let accentColorDark = Color(#colorLiteral(red: 0.3254901961, green: 0.2941176471, blue: 0.6078431373, alpha: 1))
    static let accentUIColor = UIColor(named: "AccentColor")
    static let precipitationProgress = Color(#colorLiteral(red: 0.4745098054, green: 0.8392156959, blue: 0.9764705896, alpha: 1))
    static let defaultAlertColorCode = "F43023"
    static let tabbarBackground = Color("TabbarBackgroundColor")
    static let tabbarBackgroundUIColor = UIColor(named: "TabbarBackgroundColor")

    static let accentRadialGradient = RadialGradient(colors: [.accentColor, .accentColor.opacity(0.8)], center: .center, startRadius: 0, endRadius: Constants.screenWidth/2)
    static let accentGradient: LinearGradient = .init(colors: [accentColor.lighter(by: 10), accentColor], startPoint: .leading, endPoint: .trailing)
    
    static let precipitationChartBarGradient: LinearGradient = .init(gradient: .init(colors: [Color(#colorLiteral(red: 0.4039215686, green: 0.1960784314, blue: 1, alpha: 1)), Color(#colorLiteral(red: 0.2352941176, green: 0.4549019608, blue: 0.8784313725, alpha: 1)), Color(#colorLiteral(red: 0.462745098, green: 0.9019607843, blue: 1, alpha: 1))]), startPoint: .top, endPoint: .bottom)
    static let nightBg: LinearGradient = .init(gradient: .init(colors: [Color(#colorLiteral(red: 0.04705882353, green: 0.07843137255, blue: 0.2705882353, alpha: 1)), Color(#colorLiteral(red: 0.137254902, green: 0.1921568627, blue: 0.5176470588, alpha: 1))]), startPoint: .top, endPoint: .bottom)
    
    static let sunBg: LinearGradient = .init(gradient: .init(colors: [Color("VeryOrange"), Color(#colorLiteral(red: 0.9607843161, green: 0.7058823705, blue: 0.200000003, alpha: 1))]), startPoint: .top, endPoint: .bottom)
    static let sunBgDark: LinearGradient = .init(gradient: .init(colors: [Color(#colorLiteral(red: 0.6078431373, green: 0.231372549, blue: 0.2039215686, alpha: 1)), Color(#colorLiteral(red: 0.7725490196, green: 0.3019607843, blue: 0.1137254902, alpha: 1))]), startPoint: .top, endPoint: .bottom)
    static let sunTextColor: Color = Color("SunTextColor")
    static let sunRowColor: Color = Color("SunRowColor")
    static let precipitationBg: LinearGradient = .init(gradient: .init(colors: [Color(#colorLiteral(red: 0.1019607857, green: 0.2784313858, blue: 0.400000006, alpha: 1)), Color(#colorLiteral(red: 0.1411764771, green: 0.3960784376, blue: 0.5647059083, alpha: 1))]), startPoint: .top, endPoint: .bottom)
    static let placeholderBg: LinearGradient = .init(gradient: .init(colors: [Color(.darkGray), Color(.lightGray)]), startPoint: .top, endPoint: .bottom)
    static let blue = Color(#colorLiteral(red: 0.2666666667, green: 0.7058823529, blue: 1, alpha: 1))
    static let maxTempColor = Color(hex: "D16C48")
    static let minTempColor = Color(hex: "4F90E0")
    static let midTempColor = Color(hex: "04BD91")
    static let aqiUIColors = [#colorLiteral(red: 0.3058823529, green: 0.8039215686, blue: 0.5803921569, alpha: 1), #colorLiteral(red: 0.7019607843, green: 0.8156862745, blue: 0.4431372549, alpha: 1), #colorLiteral(red: 0.9450980392, green: 0.8352941176, blue: 0.4509803922, alpha: 1), #colorLiteral(red: 0.9333333333, green: 0.6196078431, blue: 0.3882352941, alpha: 1), #colorLiteral(red: 0.8941176471, green: 0.4392156863, blue: 0.4352941176, alpha: 1), #colorLiteral(red: 0.6156862745, green: 0.4980392157, blue: 0.7058823529, alpha: 1)]
    static let TimeTravelPrimary: Color = .init(hex: "545351")
    static let TimeTravelButtonBG: Color = .init(hex: "BDB3A8")
    static let colorStyles = [
        [#colorLiteral(red: 0.03921568627, green: 0.3019607843, blue: 0.4078431373, alpha: 1), #colorLiteral(red: 0.03137254902, green: 0.5137254902, blue: 0.5843137255, alpha: 1), #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)],
        [#colorLiteral(red: 0.1647058824, green: 0.1843137255, blue: 0.3098039216, alpha: 1), #colorLiteral(red: 0.568627451, green: 0.4980392157, blue: 0.7019607843, alpha: 1), #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)],
        [#colorLiteral(red: 0.8196078431, green: 0.3019607843, blue: 0.4470588235, alpha: 1), #colorLiteral(red: 1, green: 0.6705882353, blue: 0.6705882353, alpha: 1), #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)],
        [#colorLiteral(red: 0.9490196078, green: 0.8039215686, blue: 0.3607843137, alpha: 1), #colorLiteral(red: 0.9490196078, green: 0.5725490196, blue: 0.1137254902, alpha: 1), #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)],
        [#colorLiteral(red: 0.1137254902, green: 0.1098039216, blue: 0.8980392157, alpha: 1), #colorLiteral(red: 0.2745098039, green: 0.2862745098, blue: 1, alpha: 1), #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)],
        [#colorLiteral(red: 0.4392156899, green: 0.01176470611, blue: 0.1921568662, alpha: 1), #colorLiteral(red: 0.7254901961, green: 0, blue: 0.3568627451, alpha: 1), #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)],
        [#colorLiteral(red: 0.9647058824, green: 0.9450980392, blue: 0.9450980392, alpha: 1), #colorLiteral(red: 0.6862745098, green: 0.8274509804, blue: 0.8862745098, alpha: 1), #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)],
        [#colorLiteral(red: 0.3647058824, green: 0.2196078431, blue: 0.568627451, alpha: 1), #colorLiteral(red: 0.9764705882, green: 0.5803921569, blue: 0.09019607843, alpha: 1), #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)],
        [#colorLiteral(red: 0.4392156899, green: 0.01176470611, blue: 0.1921568662, alpha: 1), #colorLiteral(red: 0.8549019694, green: 0.250980407, blue: 0.4784313738, alpha: 1), #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)],
        [#colorLiteral(red: 0.02352941176, green: 0.7450980392, blue: 0.7137254902, alpha: 1), #colorLiteral(red: 0.2006966472, green: 0.4977551103, blue: 0.537597537, alpha: 1), #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)],
        [#colorLiteral(red: 0.9098039216, green: 0.7647058824, blue: 0.9921568627, alpha: 1), #colorLiteral(red: 0.5254901961, green: 0.7725490196, blue: 0.9882352941, alpha: 1), #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)],
        [#colorLiteral(red: 1, green: 0.4588235294, blue: 0.5490196078, alpha: 1), #colorLiteral(red: 1, green: 0.4941176471, blue: 0.7019607843, alpha: 1), #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)],
        [#colorLiteral(red: 0.7450980544, green: 0.1568627506, blue: 0.07450980693, alpha: 1), #colorLiteral(red: 0.8549019694, green: 0.250980407, blue: 0.4784313738, alpha: 1), #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)],
        [#colorLiteral(red: 0.9702447057, green: 0.5423682928, blue: 0.6203573346, alpha: 1), #colorLiteral(red: 0.9943041205, green: 0.6020525098, blue: 0.5444304347, alpha: 1), #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)],
        [#colorLiteral(red: 0.4, green: 0.4941176471, blue: 0.9176470588, alpha: 1), #colorLiteral(red: 0.462745098, green: 0.2941176471, blue: 0.6352941176, alpha: 1), #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)],
        [#colorLiteral(red: 0.003921568627, green: 0.09803921569, blue: 0.5960784314, alpha: 1), #colorLiteral(red: 0.01680417731, green: 0.1983509958, blue: 1, alpha: 1), #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)],
        [#colorLiteral(red: 0, green: 0.01568627451, blue: 0.1568627451, alpha: 1), #colorLiteral(red: 0, green: 0.3058823529, blue: 0.5725490196, alpha: 1), #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)],
        [#colorLiteral(red: 0.03529411765, green: 0.1254901961, blue: 0.2470588235, alpha: 1), #colorLiteral(red: 0.3254901961, green: 0.4705882353, blue: 0.5843137255, alpha: 1), #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)],
        [#colorLiteral(red: 0.262745098, green: 0.262745098, blue: 0.262745098, alpha: 1), #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)],
        [#colorLiteral(red: 0.1607843137, green: 0.1960784314, blue: 0.2352941176, alpha: 1), #colorLiteral(red: 0.2823529412, green: 0.3333333333, blue: 0.3882352941, alpha: 1), #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)],
        [#colorLiteral(red: 0.07450980392, green: 0.3294117647, blue: 0.4784313725, alpha: 1), #colorLiteral(red: 0.5019607843, green: 0.8156862745, blue: 0.7803921569, alpha: 1), #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)],
        [#colorLiteral(red: 0.9607843137, green: 0.968627451, blue: 0.9803921569, alpha: 1), #colorLiteral(red: 0.7647058824, green: 0.8117647059, blue: 0.8862745098, alpha: 1), #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)],
        [#colorLiteral(red: 0.7529411765, green: 0.7529411765, blue: 0.7568627451, alpha: 1), #colorLiteral(red: 0.439212501, green: 0.5205973983, blue: 0.7133714557, alpha: 1), #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)],
        [#colorLiteral(red: 0.9921568627, green: 0.9882352941, blue: 0.9843137255, alpha: 1), #colorLiteral(red: 0.8862745098, green: 0.8196078431, blue: 0.7647058824, alpha: 1), #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)]
    ]
    
    
    
    let t1 = WidgetTheme(colorStart:  #colorLiteral(red: 0.03921568627, green: 0.3019607843, blue: 0.4078431373, alpha: 1), colorEnd:  #colorLiteral(red: 0.03137254902, green: 0.5137254902, blue: 0.5843137255, alpha: 1), iconSet: "03", fontColor:  #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1))
    let t2 = WidgetTheme(colorStart:  #colorLiteral(red: 0.1647058824, green: 0.1843137255, blue: 0.3098039216, alpha: 1), colorEnd:  #colorLiteral(red: 0.568627451, green: 0.4980392157, blue: 0.7019607843, alpha: 1), iconSet: "s00", fontColor:  #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1))
    let t3 = WidgetTheme(colorStart:  #colorLiteral(red: 0.8196078431, green: 0.3019607843, blue: 0.4470588235, alpha: 1), colorEnd:  #colorLiteral(red: 1, green: 0.6705882353, blue: 0.6705882353, alpha: 1), iconSet: "14", fontColor:  #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1))
    let t4 = WidgetTheme(colorStart:  #colorLiteral(red: 0.9490196078, green: 0.8039215686, blue: 0.3607843137, alpha: 1), colorEnd:  #colorLiteral(red: 0.9490196078, green: 0.5725490196, blue: 0.1137254902, alpha: 1), iconSet: "27", fontColor:  #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1))
    let t5 = WidgetTheme(colorStart:  #colorLiteral(red: 0.1137254902, green: 0.1098039216, blue: 0.8980392157, alpha: 1), colorEnd:  #colorLiteral(red: 0.2745098039, green: 0.2862745098, blue: 1, alpha: 1), iconSet: "18", fontColor:  #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1))
    let t6 = WidgetTheme(colorStart:  #colorLiteral(red: 0.4392156899, green: 0.01176470611, blue: 0.1921568662, alpha: 1), colorEnd:  #colorLiteral(red: 0.7254901961, green: 0, blue: 0.3568627451, alpha: 1), iconSet: "21", fontColor:  #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1))
    let t7 = WidgetTheme(colorStart:  #colorLiteral(red: 0.9647058824, green: 0.9450980392, blue: 0.9450980392, alpha: 1), colorEnd:  #colorLiteral(red: 0.6862745098, green: 0.8274509804, blue: 0.8862745098, alpha: 1), iconSet: "05", fontColor:  #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1))
    let t8 = WidgetTheme(colorStart:  #colorLiteral(red: 0.3647058824, green: 0.2196078431, blue: 0.568627451, alpha: 1), colorEnd:  #colorLiteral(red: 0.9764705882, green: 0.5803921569, blue: 0.09019607843, alpha: 1), iconSet: "10", fontColor:  #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1))
    let t9 = WidgetTheme(colorStart:  #colorLiteral(red: 0.1921568662, green: 0.007843137719, blue: 0.09019608051, alpha: 1), colorEnd:  #colorLiteral(red: 0.1921568662, green: 0.007843137719, blue: 0.09019608051, alpha: 1), iconSet: "09", fontColor:  #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1))
    
    
    static let flatWidgetsBackground = "bg-flat-widget"
    
    
    static let purpleTheme: ForecastTheme = ForecastTheme(
        gradientLightColor: .init(hex: "8164F4"),
        gradientDarkColor: .init(hex: "5B4CAD"),
        lightInnerShadowColor: .init(hex: "9581E5"),
        darkInnerShadowColor: .init(hex: "211C40"),
        textStartColor: .init(hex: "FFFFFF"),
        textEndColor: .init(hex: "9586E2"),
        primaryTextColor: .init(hex: "F1EEFF"),
        secondaryTextColor: .init(hex: "D3C9FF")
    )
    static let lighTheme: ForecastTheme = ForecastTheme(
        gradientLightColor: .init(hex: "EFEFEF"),
        gradientDarkColor: .init(hex: "D8D8D8"),
        lightInnerShadowColor: .init(hex: "FFFFFF"),
        darkInnerShadowColor: .init(hex: "757575"),
        textStartColor: .init(hex: "B2B2B2"),
        textEndColor: .init(hex: "000000"),
        primaryTextColor: .init(hex: "3D3D3D"),
        secondaryTextColor: .init(hex: "505050")
    )
    static let darkTheme: ForecastTheme = ForecastTheme(
        gradientLightColor: .init(hex: "4E4E4E"),
        gradientDarkColor: .init(hex: "262626"),
        lightInnerShadowColor: .init(hex: "505050"),
        darkInnerShadowColor: .init(hex: "000000"),
        textStartColor: .init(hex: "FFFFFF"),
        textEndColor: .init(hex: "8E8E8E"),
        primaryTextColor: .init(hex: "F4F4F4"),
        secondaryTextColor: .init(hex: "D9D9D9")
    )
    static let blueTheme: ForecastTheme = ForecastTheme(
        gradientLightColor: .init(hex: "233184"),
        gradientDarkColor: .init(hex: "0C1445"),
        lightInnerShadowColor: .init(hex: "4E5990"),
        darkInnerShadowColor: .init(hex: "010307"),
        textStartColor: .init(hex: "FFFFFF"),
        textEndColor: .init(hex: "214A96"),
        primaryTextColor: .init(hex: "E8EAF2"),
        secondaryTextColor: .init(hex: "A2BBE7")
    )
    static let tealTheme: ForecastTheme = ForecastTheme(
        gradientLightColor: .init(hex: "00ABB3"),
        gradientDarkColor: .init(hex: "0E6165"),
        lightInnerShadowColor: .init(hex: "1BA5AB"),
        darkInnerShadowColor: .init(hex: "0A1E1F"),
        textStartColor: .init(hex: "FFFFFF"),
        textEndColor: .init(hex: "1CD6C3"),
        primaryTextColor: .init(hex: "82F1F6"),
        secondaryTextColor: .init(hex: "A4E3E5")
    )
    static let orangeTheme: ForecastTheme = ForecastTheme(
        gradientLightColor: .init(hex: "F9B664"),
        gradientDarkColor: .init(hex: "F47340"),
        lightInnerShadowColor: .init(hex: "FBC482"),
        darkInnerShadowColor: .init(hex: "B13D10"),
        textStartColor: .init(hex: "D78346"),
        textEndColor: .init(hex: "461D0B"),
        primaryTextColor: .init(hex: "733316"),
        secondaryTextColor: .init(hex: "A45032")
    )
    static let redTheme: ForecastTheme = ForecastTheme(
        gradientLightColor: .init(hex: "ED5050"),
        gradientDarkColor: .init(hex: "D12B2B"),
        lightInnerShadowColor: .init(hex: "F27373"),
        darkInnerShadowColor: .init(hex: "680000"),
        textStartColor: .init(hex: "FFFFFF"),
        textEndColor: .init(hex: "FF8B8B"),
        primaryTextColor: .init(hex: "F4F4F4"),
        secondaryTextColor: .init(hex: "FFB9B9")
    )
    
    
    static let stickyHeader = #colorLiteral(red: 0.8, green: 0.7529411765, blue: 0.9647058824, alpha: 1)
    
    
    static let sunViewColors: [Color] = [.init(hex: "CFDEE1").lighter(by: 5),
                                         .init(hex: "AFD3E1"),
                                         .init(hex: "202D7D").lighter(by: 10),
                                         .init(hex: "0E174D")
    ]
    
    static let moonViewColors: [Color] = [.init(hex: "101951"),
                                          .init(hex: "1F2C79").lighter(by: 10)
    ]
    
    static func getBgColor(for widgetKind: WidgetKind) -> Color {
        switch widgetKind {
        case .forecast:
            return Color(#colorLiteral(red: 0.5254901961, green: 0.4156862745, blue: 0.937254902, alpha: 1))
        case .customizable:
            return Color(#colorLiteral(red: 0.3254901961, green: 0.4705882353, blue: 0.5843137255, alpha: 1))

        case .aqi:
            return otherWidgetsColors[.appleLightEnd]!
        }
    }
    
    // MARK: - Other Widgets Constants
    
    static let otherWidgetsColors: [OtherWidgetsColor : Color] = [
        .appleLightStart : Color(red: 116/255, green: 166/255, blue: 200/255),
        .appleDarkStart : Color.init(red: 10/255, green: 15/255, blue: 33/255),
        .appleLightEnd : Color(red: 69/255, green: 138/255, blue: 183/255),
        .appleDarkEnd : Color.init(red: 48/255, green: 53/255, blue: 67/255)
    ]
    
    enum OtherWidgetsColor: Int {
        case appleLightStart
        case appleDarkStart
        case appleLightEnd
        case appleDarkEnd
    }
    
    // MARK: - AQI Gauge Sections
    
    //    static let aqiSections: [GaugeViewSection] = [GaugeViewSection(color: Color(aqiColors[0]), size: 0.17),
    //                                        GaugeViewSection(color: Color(aqiColors[1]), size: 0.16),
    //                                        GaugeViewSection(color: Color(aqiColors[2]), size: 0.17),
    //                                        GaugeViewSection(color: Color(aqiColors[3]), size: 0.17),
    //                                        GaugeViewSection(color: Color(aqiColors[4]), size: 0.16),
    //                                        GaugeViewSection(color: Color(aqiColors[5]), size: 0.17)]
    
    
    
#endif
}

extension Constants {
    struct Patterns {
        static let timeTravelTile: String = "timetravel_tile"
        
    }
}

extension Constants {
    static let fonts = [
        "Default",
        "Default",
        "SF Pro",
        "Copperplate",
        "Heiti SC",
        "Iowan Old Style",
        "Kohinoor Telugu",
        "Thonburi",
        "Heiti TC",
        "Courier New",
        "Gill Sans",
        "Apple SD Gothic Neo",
        "Marker Felt",
        "Avenir Next Condensed",
        "Tamil Sangam MN",
        "Helvetica Neue",
        "Gurmukhi MN",
        "Times New Roman",
        "Georgia",
        "Arial Rounded MT Bold",
        "Kailasa",
        "Chalkboard SE",
        "Sinhala Sangam MN",
        "PingFang TC",
        "Gujarati Sangam MN",
        "Noteworthy",
        "Geeza Pro",
        "Avenir",
        "Academy Engraved LET",
        "Mishafi",
        "Futura",
        "Farah",
        "Kannada Sangam MN",
        "Arial Hebrew",
        "Arial",
        "Hoefler Text",
        "Optima",
        "Palatino",
        "Lao Sangam MN",
        "Malayalam Sangam MN",
        "Al Nile",
        "Bradley Hand",
        "PingFang HK",
        "Trebuchet MS",
        "Helvetica",
        "Courier",
        "Cochin",
        "Hiragino Mincho ProN",
        "Devanagari Sangam MN",
        "Oriya Sangam MN",
        "Zapf Dingbats",
        "Bodoni 72",
        "Verdana",
        "American Typewriter",
        "Avenir Next",
        "Baskerville",
        "Didot",
        "Savoye LET",
        "Menlo",
        "Bodoni 72 Smallcaps",
        "Papyrus",
        "Hiragino Sans",
        "PingFang SC",
        "Euphemia UCAS",
        "Telugu Sangam MN",
        "Bangla Sangam MN",
        "Bodoni 72 Oldstyle"
    ]
}
