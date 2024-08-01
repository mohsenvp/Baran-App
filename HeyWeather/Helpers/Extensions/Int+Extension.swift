//
//  Int+Extension.swift
//  HeyWeather
//
//  Created by Kamyar on 10/11/21.
//

import Foundation
import SwiftUI

extension Int {
    var isZero: Bool {
        return self == 0
    }
    
    func aqiValueToProgress() -> Double {
        if self <= 200 {
            return Double(self).interpolated(from: 0...200, to: 0...66.4)
        }else if self <= 300{
            return Double(self).interpolated(from: 200...300, to: 66.4...83)
        }else {
            return Double(self).interpolated(from: 300...500, to: 83...100)
        }
     }
    
    func secondsToHoursAndMinutes() -> String {
        let hours = self / 3600
        let minutes = (self / 60) % 60
        return String(localized: "\(hours) hours and \(minutes) minutes", table: "General")
    }
    

    
    func convertedTemp() -> Double {
        @AppStorage(Constants.tempUnitString, store: Constants.groupUserDefaults) var unit: String = Constants.defaultTempUnit.rawValue
        let measurement = Measurement(value: Double(self), unit: UnitTemperature.celsius)
         switch unit {
         case TemperatureUnit.fahrenheit.rawValue:
             return measurement.converted(to: .fahrenheit).value
         case TemperatureUnit.kelvin.rawValue:
             return measurement.converted(to: .kelvin).value
         default:
             return measurement.converted(to: .fahrenheit).value
         }
     }
    
    
    
    func convertedDistance() -> Double {
        @AppStorage(Constants.distanceUnitString, store: Constants.groupUserDefaults) var unit: String = Constants.defaultDistanceUnit.rawValue
        let measurement = Measurement(value: Double(self), unit: UnitLength.meters)
        switch unit {
        case DistanceUnit.km.rawValue:
            return measurement.converted(to: .kilometers).value
        default:
            return measurement.converted(to: .miles).value
        }
    }
    
    func convertedPressure() -> Double {
        @AppStorage(Constants.pressureUnitString, store: Constants.groupUserDefaults) var unit: String = Constants.defaultPressureUnit.rawValue
        let measurement = Measurement(value: Double(self), unit: UnitPressure.hectopascals)

        switch unit {
        case PressureUnit.hPa.rawValue:
            return  measurement.converted(to: .hectopascals).value
        case PressureUnit.mBar.rawValue:
            return  measurement.converted(to: .millibars).value
        case PressureUnit.inHg.rawValue:
            return  measurement.converted(to: .inchesOfMercury).value
        default:
            return   measurement.converted(to: .millimetersOfMercury).value
        }
    }
    
   fileprivate func toUserTemp() -> String {
       @AppStorage(Constants.tempUnitString, store: Constants.groupUserDefaults) var unit: String = Constants.defaultTempUnit.rawValue
        switch unit {
        case TemperatureUnit.fahrenheit.rawValue:
            return convertTemp(temp: Double(self), to: .fahrenheit).withoutLetters
        case TemperatureUnit.kelvin.rawValue:
            return convertTemp(temp: Double(self), to: .kelvin)
        default:
            return convertTemp(temp: Double(self), to: .celsius).withoutLetters
        }
    }
    
   fileprivate func toUserTempValue() -> Int {
       @AppStorage(Constants.tempUnitString, store: Constants.groupUserDefaults) var unit: String = Constants.defaultTempUnit.rawValue
            switch unit {
            case TemperatureUnit.fahrenheit.rawValue:
                return Int(convertTemp(temp: Double(self), to: .fahrenheit))
            case TemperatureUnit.kelvin.rawValue:
                return Int(convertTemp(temp: Double(self), to: .kelvin))
            default:
                return Int(convertTemp(temp: Double(self), to: .celsius))
            }
        }
    
    fileprivate func toUserDistance() -> String {
        @AppStorage(Constants.distanceUnitString, store: Constants.groupUserDefaults) var unit: String = Constants.defaultDistanceUnit.rawValue
        switch unit {
        case DistanceUnit.km.rawValue:
            return convertDistance(distance: self, to: .kilometers)
        default:
            return convertDistance(distance: self, to: .miles)
        }
    }
    
    fileprivate func toUserPressure() -> String {
        @AppStorage(Constants.pressureUnitString, store: Constants.groupUserDefaults) var unit: String = Constants.defaultPressureUnit.rawValue
        switch unit {
        case PressureUnit.hPa.rawValue:
            return convertPressure(pressure: self, to: .hectopascals)
        case PressureUnit.mBar.rawValue:
            return convertPressure(pressure: self, to: .millibars)
        case PressureUnit.inHg.rawValue:
            return convertPressure(pressure: self, to: .inchesOfMercury)
        default:
            return convertPressure(pressure: self, to: .millimetersOfMercury)
        }
    }
    
    fileprivate func convertTemp(temp: Double, to outputTempType: UnitTemperature) -> Double {
        let input = Measurement(value: temp, unit: UnitTemperature.celsius)
        return input.converted(to: outputTempType).value
    }
    
    fileprivate func convertTemp(temp: Double, to unit: UnitTemperature) -> String {
        let formatter = MeasurementFormatter()
        formatter.locale = .init(identifier: LocalizeHelper.shared.currentLanguage.rawValue)
        formatter.unitOptions = .providedUnit
        formatter.numberFormatter.maximumFractionDigits = 0
        let measurement: Measurement<UnitTemperature> = Measurement(value: temp, unit: .celsius)
        return formatter.string(from: measurement.converted(to: unit))
    }
    
    fileprivate func convertPressure(pressure: Int, to unit: UnitPressure) -> String {
        let formatter = MeasurementFormatter()
        formatter.locale = .init(identifier: LocalizeHelper.shared.currentLanguage.rawValue)
        formatter.unitOptions = .providedUnit
        formatter.numberFormatter.maximumFractionDigits = unit == .millimetersOfMercury ? 0 : 2
        let measurement: Measurement<UnitPressure> = Measurement(value: Double(pressure), unit: .hectopascals)
        return formatter.string(from: measurement.converted(to: unit))
    }
    
    fileprivate func convertDistance(distance: Int, to unit: UnitLength) -> String {
        let formatter = MeasurementFormatter()
        formatter.locale = .init(identifier: LocalizeHelper.shared.currentLanguage.rawValue)
        formatter.unitOptions = .providedUnit
        let measurement: Measurement<UnitLength> = Measurement(value: Double(distance), unit: .meters)
        return formatter.string(from: measurement.converted(to: unit))
    }
}

extension Int64 {
    func isPassed()-> Bool {
        return self < Int64(Date().timeIntervalSince1970)
    }
}

extension Int {
    var localizedPressure: String {
        return self.toUserPressure()
    }
    
    var localizedVisibility: String {
        return self.toUserDistance()
    }
    var localizedNumber: String {
        let formatter = NumberFormatter()
        formatter.locale = .init(identifier: LocalizeHelper.shared.currentLanguage.rawValue)
        formatter.maximumFractionDigits = 0
        return formatter.string(from: NSNumber(value: self)) ?? self.description
    }
    var spelledOut: String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .spellOut
        formatter.locale = .init(identifier: LocalizeHelper.shared.currentLanguage.rawValue)
        return formatter.string(for: self) ?? "\(self)"
    }
    var localizedTemp: String {
        return self.toUserTemp()
    }
    
    var localizedTempWithoutDegreeSign: String {
        return self.localizedTemp.replacingOccurrences(of: "°", with: "")
    }

}

extension Optional where Wrapped == Int {
    var localizedTemp: String {
        return self?.toUserTemp() ?? Constants.none
    }
    
    var localizedTempValue: Int {
        return self?.toUserTempValue() ?? 0
    }
}
