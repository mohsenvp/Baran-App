//
//  AnimatedWeatherBackground.swift
//  HeyWeather
//
//  Created by Mohammad Yeganeh on 6/6/23.
//
import SpriteKit
import SwiftUI
#if os(watchOS)
import WatchKit
#endif
struct AnimatedWeatherBackground: View {
    
    var sunrise: Date?
    var sunset: Date?
    var weather: Weather
    var isAnimationEnabled: Bool = false

    static func getTextColor(sunrise: Date?, sunset: Date?, weather: Weather) -> Color{
        let now = weather.localDate
        guard let sunriseUnwrapped = sunrise, let sunsetUnwrapped = sunset else {
            if weather.condition.isDay {
                return .black
            }else {
                return .white
            }
        }
        let afterSunrize = sunriseUnwrapped.addingTimeInterval(30 * 60)
        let beforeSunset = sunsetUnwrapped.addingTimeInterval(30 * 60)
        
        if now > afterSunrize && now < beforeSunset && weather.condition.type != .storm && weather.condition.type != .rain{
            return .black
        }
        return .white
    }
    
    var weatherBackground:  LinearGradient {

        if (!weather.isAvailable) {
            return Constants.conditionBackgroundNotLoaded
        }
        guard let sunriseUnwrapped = sunrise, let sunsetUnwrapped = sunset else {
            if weather.condition.isDay {
                return Constants.weatherBackgroundNoon
            }else {
                return Constants.weatherBackgroundNight
            }
        }
        let now = weather.localDate
        let beforeSunrise = sunriseUnwrapped.addingTimeInterval(-30 * 60)
        let afterSunrise = sunriseUnwrapped.addingTimeInterval(30 * 60)
        let afternoonStart = sunsetUnwrapped.addingTimeInterval(-90 * 60)
        let beforeSunset = sunsetUnwrapped.addingTimeInterval(-30 * 60)
        let afterSunset = sunsetUnwrapped.addingTimeInterval(30 * 60)

        let sunriseRange = beforeSunrise...afterSunrise
        let noonRange = afterSunrise < beforeSunset ? afterSunrise...beforeSunset : beforeSunset...afterSunrise
        let afternoonRange = afternoonStart...beforeSunset
        let sunsetRange = beforeSunset...afterSunset
        let midnight = now.setTime(hour: 0, min: 0)!

    
        
        if sunriseRange.contains(now){
            return Constants.weatherBackgroundSunrise
        }
        if noonRange.contains(now){
            return Constants.weatherBackgroundNoon
        }
        if afternoonRange.contains(now){
            return Constants.weatherBackgroundAfternoon
        }
        if sunsetRange.contains(now){
            return Constants.weatherBackgroundSunset
        }
        if now > afterSunset && now < midnight{
            return Constants.weatherBackgroundNight
        }
        if now > midnight {
            return Constants.weatherBackgroundMidnight
        }

        return Constants.weatherBackgroundNoon
    }
    
    var ConditionBackground: LinearGradient {
        switch weather.condition.type {
        case .atmosphere, .clear, .clouds, .nothing:
            return LinearGradient(colors: [.clear, .clear], startPoint: .top, endPoint: .bottom)
        case .storm:
            return Constants.conditionBackgroundStorm
        case .rain:
            return Constants.conditionBackgroundRain
        case .snow:
            return Constants.conditionBackgroundSnow
        case .drizzle:
            return Constants.conditionBackgroundDrizzle
        }
    }
  
    var conditionOpacity: CGFloat {
        if weather.condition.intensity == .light {
            return 0.4
        }else if weather.condition.intensity == .normal {
            return 0.6
        }else {
            return 0.8
        }
    }

    var hasAnimation: Bool {
        #if os(watchOS)
        if !isAnimationEnabled {
            return false
        }
        #else
        if Constants.motionReduced || !isAnimationEnabled {
            return false
        }
        #endif
        
        switch weather.condition.type {
        case .atmosphere, .clear, .nothing:
            return false
        case .storm, .rain, .snow, .drizzle, .clouds:
            return true
        }
    }
    
    var body: some View {
        ZStack {
            Rectangle().fill(weatherBackground)
            Rectangle().fill(ConditionBackground).opacity(conditionOpacity)
           
            if hasAnimation {
                WeatherAnimationView(
                    weatherType: weather.condition.type,
                    weatherIntensity: weather.condition.intensity
                )
            }
        }
        .accessibilityHidden(true)
        .ignoresSafeArea()
    }
}

struct WeatherAnimationView: View {
    
    var weatherType: WeatherCondition.WeatherType = .clouds
    var weatherIntensity: WeatherCondition.Intensity = .heavy
    
    var scene: WeatherSpriteScene {
        let s = WeatherSpriteScene()
        s.weatherIntensity = weatherIntensity
        s.weatherType = weatherType
        s.removeAllChildren()
        s.sceneDidLoad()
        s.isUserInteractionEnabled = false
        return s
    }
    var body: some View {
        #if os(watchOS)
        SpriteView(scene: scene)
            .id(scene.id)
            .edgesIgnoringSafeArea(.all)
            .animation(.linear(duration: 0.3), value: weatherType)
        #else
        SpriteView(scene: scene, options : [.allowsTransparency])
            .id(scene.id)
            .edgesIgnoringSafeArea(.all)
            .animation(.linear(duration: 0.3), value: weatherType)
        #endif
    }
    
    class WeatherSpriteScene: SKScene {
        var id: UUID = UUID()
        var weatherType: WeatherCondition.WeatherType = .atmosphere
        var weatherIntensity: WeatherCondition.Intensity = .light
        
    
        var emmiterNode: SKEmitterNode? {
            switch weatherType {
            case .atmosphere, .clear, .nothing:
                return nil
            case .clouds:
                return SKEmitterNode(fileNamed: Constants.Particles.cloud)!
            case .rain, .storm:
                return SKEmitterNode(fileNamed: Constants.Particles.rain)!
            case .snow:
                return SKEmitterNode(fileNamed: Constants.Particles.snow)!
            case .drizzle:
                return SKEmitterNode(fileNamed: Constants.Particles.drizzle)!
            }
        }
        override func sceneDidLoad() {
            var screenSize: CGSize = .zero
            #if os(watchOS)
            screenSize = .init(width: WKInterfaceDevice.current().screenBounds.width, height: WKInterfaceDevice.current().screenBounds.height)
            #else
            screenSize = UIScreen.main.bounds.size
            #endif
            scaleMode = .resizeFill
            anchorPoint = CGPoint(x: weatherType == .clouds ? 1 : 0.5, y: 1)
            backgroundColor = .clear
            
            if let node = emmiterNode {
                if weatherIntensity == .light {
                    node.particleBirthRate = node.particleBirthRate / 3
                }else if weatherIntensity == .normal {
                    node.particleBirthRate = node.particleBirthRate / 2
                }
                if weatherType == .clouds {
                    node.position.x += 300
                    #if os(watchOS)
                    node.position.y += 50
                    node.particleScale -= 1.5
                    #endif
                }
                node.isUserInteractionEnabled = false
                addChild(node)
                node.particlePositionRange.dx = screenSize.width
                self.isUserInteractionEnabled = false
            }
        }
    }
    
    class SimpleScene: SKScene {
        var emmiterNode: SKEmitterNode? {
            return SKEmitterNode(fileNamed: Constants.Particles.rain)!
        }
        override func sceneDidLoad() {

          
        }
    }
}
