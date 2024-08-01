//
//  AstronomyManager.swift
//  HeyWeather
//
//  Created by Mohsen on 27/11/2023.
//

import Combine
import SunKit
import MoonKit
import CoreLocation

class AstronomyManager: NSObject, ObservableObject {

    static private(set) var shared: AstronomyManager = AstronomyManager()

    @Published var sunInfo: SunDataModel?
    @Published var moonInfo: MoonDataModel?

    override init() {
        super.init()
    }
    
    // MARK: - Get Astronomy functions
    
    func getAstronomy(city: City, count: Int = 1, timeZone: TimeZone) -> [Astronomy] {
        let location = CLLocation(latitude: city.location.lat, longitude: city.location.long)
        var currentDate = Date()
        let calendar = Calendar.current

        var astronomies: [Astronomy] = []
        
        for _ in 0...count {
            var astronomy = Astronomy()
            let sunInfo = calculateSunInfo(location: location, date : currentDate, timeZone: timeZone)
            let moonInfo = calculateMoonInfo(location: location, date : currentDate, timeZone: timeZone)
            
            astronomy.sun = sunInfo
            astronomy.moon = moonInfo
            
            astronomies.append(astronomy)
            currentDate = calendar.date(byAdding: .day, value: 1, to: currentDate)!

        }
        return astronomies
    }
    
    
    // MARK: - Get Moon Info
    
    private func calculateMoonInfo(location: CLLocation, date: Date, timeZone: TimeZone) -> MoonDataModel {
        let userLatitude = location.coordinate.latitude
        let userLongitude = location.coordinate.longitude
        
        let userLocation: CLLocation = .init(latitude: userLatitude, longitude: userLongitude)
        let customTimeZone: TimeZone = TimeZone(identifier: "UTC") ?? .current
        let myMoon: Moon = .init(location: userLocation, timeZone: customTimeZone)
        myMoon.setDate(date)
        
        var moonInfo = MoonDataModel()
        
        moonInfo.age = Int(myMoon.ageOfTheMoonInDays)
        moonInfo.rise = myMoon.moonRise?.convertToTimeZone(timeZone: timeZone)
        moonInfo.set = myMoon.moonSet?.convertToTimeZone(timeZone: timeZone)
        moonInfo.type = myMoon.moonSign.rawValue
        if 0...2.5 ~= myMoon.moonPercentage{
            moonInfo.phase = String(localized: "New Moon", table: "Moon")
        }else if 97.5...100 ~= myMoon.moonPercentage{
            moonInfo.phase = String(localized: "Full Moon", table: "Moon")
        }else{
            moonInfo.phase = myMoon.currentMoonPhase.rawValue
        }
        moonInfo.illumination = myMoon.moonPercentage
        moonInfo.parallacticAngle = myMoon.moonEclipticCoordinates.eclipticLatitude.degrees
        moonInfo.distance = 389029
        
        let moonVisibaleTime = myMoon.moonRise == nil && myMoon.moonSet == nil ? 86400 : myMoon.moonSet?.timeIntervalSince(myMoon.moonRise ?? Date())
        let moonVisibality =  myMoon.moonRise == nil || myMoon.moonSet == nil ? true : false
        moonInfo.visible = moonInfo.isVisible()
        moonInfo.alwaysUp = myMoon.moonEclipticCoordinates.eclipticLatitude.radians > 0 && myMoon.moonRise == nil && myMoon.moonSet == nil ? true : false
        moonInfo.alwaysDown =  myMoon.moonEclipticCoordinates.eclipticLatitude.radians < 0 && myMoon.moonRise == nil && myMoon.moonSet == nil ? true : false
        let fromLastNewMoon = 29.5 - Double(myMoon.nextNewMoon)
        moonInfo.lastNewMoon = fromLastNewMoon
        moonInfo.nextFullMoon = Double(myMoon.nextFullMoon)

        
        return moonInfo
    }
    
    func moonParallacticAngle(observerLatitude: Double, observerLongitude: Double, moonAltitude: Double, azimuth: Double) -> Double {
        let observerLatRad = observerLatitude * (Double.pi / 180.0) // Convert observer's latitude to radians
        let moonAltRad = moonAltitude * (Double.pi / 180.0) // Convert Moon's altitude to radians

        let numerator = sin(azimuth * (Double.pi / 180.0))
        let denominator = (cos(observerLatRad) * tan(moonAltRad)) - (sin(observerLatRad) * cos(azimuth * (Double.pi / 180.0)))

        let parallacticAngle = atan2(numerator, denominator) * (180.0 / Double.pi) // Convert parallactic angle to degrees

        return parallacticAngle
    }
    
    func moonDistance(rightAscension: Double, declination: Double) -> Double {
        let earthRadius = 6371.0 // Average radius of the Earth in kilometers
        
        let moonRightAscension = rightAscension * (Double.pi / 180.0) // Convert to radians
        let moonDeclination = declination * (Double.pi / 180.0) // Convert to radians

        let moonEarthDistance = earthRadius / sin(moonDeclination)
        let moonDistance = moonEarthDistance * cos(moonDeclination) * cos(moonRightAscension)

        return moonDistance
    }
    
    // MARK: - Get Sun Info
    
    private func calculateSunInfo(location: CLLocation, date: Date, timeZone: TimeZone) -> SunDataModel {
        let userLatitude = location.coordinate.latitude
        let userLongitude = location.coordinate.longitude
        
        let userLocation: CLLocation = .init(latitude: userLatitude, longitude: userLongitude)
        let utcTimeZone: TimeZone = TimeZone(identifier: "UTC") ?? .current
        let mySun: Sun = .init(location: userLocation, timeZone: utcTimeZone)
        mySun.setDate(date)
        
        var sunInfo = SunDataModel()
        sunInfo.sunrise = mySun.sunrise.convertToTimeZone(timeZone: timeZone)
        sunInfo.sunset = mySun.sunset.convertToTimeZone(timeZone: timeZone)
        let dayLightDuration = mySun.sunset.timeIntervalSince(mySun.sunrise)
        sunInfo.alwaysUp = dayLightDuration == 86400
        sunInfo.alwaysDown = dayLightDuration == 0
        sunInfo.altitude = mySun.altitude.degrees//sunPosition.altitude
        sunInfo.direction = mySun.azimuth.degrees//sunPosition.azimuth
        sunInfo.dayProgress = calculateDayProgress(sunrise: mySun.sunrise, sunset: mySun.sunset, date: date)
//        sunInfo.distance = estimateSunDistance(latitude: location.coordinate.latitude, solarAltitude: mySun.altitude.degrees, date: date)
        sunInfo.distance = calculateSunDistance(altitude: mySun.altitude.degrees, latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)

        return sunInfo
    }
    
    // MARK: - Calculate day progress
    
    func calculateDayProgress(sunrise: Date, sunset: Date, date: Date) -> Double {
        let totalDaylightDuration = sunset.timeIntervalSince(sunrise)
        let elapsedTime = date.timeIntervalSince(sunrise)
        let dayProgress = elapsedTime / totalDaylightDuration
        return min(max(dayProgress, 0), 1)
    }
    
    
    func calculateSunDistance(altitude: Double, latitude: Double, longitude: Double) -> Double {
        let observerAltitude = 0.0 // Assume observer is at sea level
        let earthRadius = 6371.0 // in kilometers

        // Convert angles to radians
        let altitudeRad = altitude * Double.pi / 180.0
        let latitudeRad = latitude * Double.pi / 180.0
        let longitudeRad = longitude * Double.pi / 180.0

        // Calculate the zenith angle
        let zenithAngle = Double.pi / 2 - altitudeRad

        // Calculate the observer's distance from the Earth's center
        let observerDistance = (earthRadius + observerAltitude) * cos(altitudeRad)

        // Calculate the observer's position in 3D space
        let observerX = observerDistance * cos(latitudeRad) * cos(longitudeRad)
        let observerY = observerDistance * cos(latitudeRad) * sin(longitudeRad)
        let observerZ = observerDistance * sin(latitudeRad)

        // Calculate the Sun's position in 3D space (assuming spherical symmetry)
        let sunX = 0.0
        let sunY = 0.0
        let sunZ = -149.568e6 // Estimated current Sun distance in kilometers

        // Calculate the distance between the observer and the Sun
        let distanceToSun = sqrt(pow(observerX - sunX, 2) + pow(observerY - sunY, 2) + pow(observerZ - sunZ, 2))

        return distanceToSun
    }
    
    func estimateSunDistance(latitude: Double, solarAltitude: Double, date: Date) -> Double {
        let earthPerihelionDistance = 147_098_074.0 // Perihelion distance of the Earth in kilometers
        let earthAphelionDistance = 152_097_701.0 // Aphelion distance of the Earth in kilometers
        
        let solarAltitudeRadians = solarAltitude * Double.pi / 180.0 // Convert solar altitude to radians
        
        let earthEccentricity = (earthAphelionDistance - earthPerihelionDistance) / (earthAphelionDistance + earthPerihelionDistance)
        let earthMeanDistance = (earthPerihelionDistance + earthAphelionDistance) / 2.0
        
        let solarDistance = earthMeanDistance * (1.0 + earthEccentricity * cos(dateToJulianDay(date))) / (1.0 - earthEccentricity * cos(solarAltitudeRadians))
        
        return solarDistance
    }

    func dateToJulianDay(_ date: Date) -> Double {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year, .month, .day], from: date)
        let year = Double(components.year!)
        let month = Double(components.month!)
        let day = Double(components.day!)
        
        var a: Double
        var b: Double
        
        if month <= 2 {
            a = year - 1
            b = month + 12
        } else {
            a = year
            b = month
        }
        
        let jd = floor(365.25 * (a + 4716.0)) + floor(30.6001 * (b + 1.0)) + day - 1524.5
        
        return jd
    }
}
