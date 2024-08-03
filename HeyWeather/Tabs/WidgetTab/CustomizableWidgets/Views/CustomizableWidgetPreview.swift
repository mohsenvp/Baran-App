//
//  WidgetPreview.swift
//  HeyWeather
//
//  Created by Mohammad Yeganeh on 5/23/23.
//

import SwiftUI

struct CustomizableWidgetPreview<Content: View>: View {
    
    var theme: WidgetTheme
    let widgetFamily: WidgetSize
    let widgetIndex: Int
    let weatherData: WeatherData
    
    @ViewBuilder var previewBackgroundImage: Content


    
    var body: some View {
        if widgetFamily == .small {
            ZStack {
                previewBackgroundImage
                
                switch widgetIndex {
                case 0:
                    SmallWidgetView1(weather: weatherData, theme: theme,
                                     isPreviewForAppWidgetTab: true)
                case 1:
                    SmallWidgetView2(weather: weatherData, theme: theme,
                                     isPreviewForAppWidgetTab: true)
                case 2:
                    SmallWidgetView3(weather: weatherData, theme: theme,
                                     isPreviewForAppWidgetTab: true)
                case 3:
                    SmallWidgetView4(weather: weatherData, theme: theme,
                                     isPreviewForAppWidgetTab: true)
                case 4:
                    SmallWidgetView5(weather: weatherData, theme: theme,
                                     isPreviewForAppWidgetTab: true)
                case 5:
                    SmallWidgetView6(weather: weatherData, theme: theme,
                                     isPreviewForAppWidgetTab: true)
                case 6:
                    SmallWidgetView7(weather: weatherData, theme: theme,
                                     isPreviewForAppWidgetTab: true)
                case 7:
                    SmallWidgetView8(weather: weatherData, theme: theme,
                                     isPreviewForAppWidgetTab: true)
                default:
                    EmptyView()
                }
            }
            .frame(width: Constants.smallWidgetSize.width, height: Constants.smallWidgetSize.height)
            .cornerRadius(25)
            
        }else if widgetFamily == .medium {

            ZStack {
                previewBackgroundImage
                
                switch widgetIndex {
                case 0:
                    MediumWidgetView1(weather: weatherData, theme: theme,
                                      isPreviewForAppWidgetTab: true)
                case 1:
                    MediumWidgetView2(weather: weatherData, theme: theme,
                                      isPreviewForAppWidgetTab: true)
                case 2:
                    MediumWidgetView3(weather: weatherData, theme: theme,
                                      isPreviewForAppWidgetTab: true)
                case 3:
                    MediumWidgetView4(weather: weatherData, theme: theme,
                                      isPreviewForAppWidgetTab: true)
                case 4:
                    MediumWidgetView5(weather: weatherData, theme: theme,
                                      isPreviewForAppWidgetTab: true)
                case 5:
                    MediumWidgetView6(weather: weatherData, theme: theme,
                                      isPreviewForAppWidgetTab: true)
                case 6:
                    MediumWidgetView7(weather: weatherData, theme: theme,
                                      isPreviewForAppWidgetTab: true)
                case 7:
                    MediumWidgetView8(weather: weatherData, theme: theme,
                                      isPreviewForAppWidgetTab: true)
                default:
                    EmptyView()
                }
            }
            .frame(width: Constants.mediumWidgetSize.width, height: Constants.mediumWidgetSize.height)
            .cornerRadius(25)
            .clipShape(RoundedRectangle(cornerRadius: 25, style: .continuous))
            
        }else {
       
            ZStack {
                previewBackgroundImage
                
                switch widgetIndex {
                case 0:
                    LargeWidgetView1(weather: weatherData, theme: theme,
                                     isPreviewForAppWidgetTab: true)
                case 1:
                    LargeWidgetView2(weather: weatherData, theme: theme,
                                     isPreviewForAppWidgetTab: true)
                case 2:
                    LargeWidgetView3(weather: weatherData, theme: theme,
                                     isPreviewForAppWidgetTab: true)
                case 3:
                    LargeWidgetView4(weather: weatherData, theme: theme,
                                     isPreviewForAppWidgetTab: true)
                case 4:
                    LargeWidgetView5(weather: weatherData, theme: theme,
                                     isPreviewForAppWidgetTab: true)
                case 5:
                    LargeWidgetView6(weather: weatherData, theme: theme,
                                     isPreviewForAppWidgetTab: true)
                default:
                    EmptyView()
                }
            }
            .frame(width: Constants.largeWidgetSize.width, height: Constants.largeWidgetSize.height)
            .cornerRadius(25)
        }
        
    }
}

struct MyPreviewProvider_Previews: PreviewProvider {
    @State static var theme: WidgetTheme = .init()
    
    static var previews: some View {
        CustomizableWidgetPreview(theme: theme, widgetFamily: .small, widgetIndex: 0, weatherData: .init(), previewBackgroundImage: {})
    }
}
