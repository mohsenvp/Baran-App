//
//  Double+Extension.swift
//  HeyWeather
//
//  Created by Kamyar on 10/10/21.
//

import Foundation
import SwiftUI


extension Double {
    
    func removeZerosFromEnd() -> String {
        let formatter = NumberFormatter()
        formatter.locale = .init(identifier: LocalizeHelper.shared.currentLanguage.rawValue)
        let number = NSNumber(value: self)
        formatter.minimumFractionDigits = 0
        formatter.maximumFractionDigits = 2 //maximum digits in Double after dot (maximum precision)
        return String(formatter.string(from: number) ?? "")
    }
    
    var localizedDewPoint: String {
        return self.toUserDewPoint()
    }
    
    var localizedWindSpeed: String {
        return self.toUserSpeed()
    }
    
    var localizedPrecipitation: Double {
        return self.toUserPrecipitation()
    }
    
    //todo cleanup
    var localizedPrecipitationWithUnit: String {
        @AppStorage(Constants.precipitationUnitString, store: Constants.groupUserDefaults) var unit: String = Constants.defaultPrecipitationUnit.rawValue
        switch unit {
        case PrecipitationUnit.mm.rawValue:
            return self.convertPrecipitationWithUnit(precipitation: self, to: .millimeters)
        default:
            return self.convertPrecipitationWithUnit(precipitation: self, to: .inches)
        }
    }
    
    
    var localizedTemp: String {
        return self.toUserTemp()
    }
    
    var localizedTempValue: Double {
        @AppStorage(Constants.tempUnitString, store: Constants.groupUserDefaults) var unit: String = Constants.defaultTempUnit.rawValue
        var tempUnit = UnitTemperature.celsius
        if unit == TemperatureUnit.fahrenheit.rawValue {
            tempUnit = .fahrenheit
        }else if unit == TemperatureUnit.kelvin.rawValue {
            tempUnit = .kelvin
        }
        
        let formatter = MeasurementFormatter()
        formatter.locale = .init(identifier: LocalizeHelper.shared.currentLanguage.rawValue)
        formatter.numberFormatter.maximumFractionDigits = 0
        formatter.unitOptions = .providedUnit
        let input = Measurement(value: self, unit: UnitTemperature.celsius)
        return input.converted(to: tempUnit).value
    }
    
    func localizedNumber(withFractionalDigits digits: Int = 2) -> String {
        let formatter = NumberFormatter()
        formatter.locale = .init(identifier: LocalizeHelper.shared.currentLanguage.rawValue)
        formatter.maximumFractionDigits = digits
        return formatter.string(from: NSNumber(value: self)) ?? self.description
    }
    
    
    func convertedPrecipitation() -> Double {
        @AppStorage(Constants.precipitationUnitString, store: Constants.groupUserDefaults) var unit: String = Constants.defaultPrecipitationUnit.rawValue
        let measurement = Measurement(value: self, unit: UnitLength.millimeters)
        switch unit {
        case PrecipitationUnit.mm.rawValue:
            return measurement.converted(to: .millimeters).value
        default:
            return measurement.converted(to: .inches).value
        }
    }
    
    func convertedSpeed() -> Double {
        @AppStorage(Constants.speedUnitString, store: Constants.groupUserDefaults) var unit: String = Constants.defaultSpeedUnit.rawValue
        let measurement = Measurement(value: self, unit: UnitSpeed.metersPerSecond)
        switch unit {
        case SpeedUnit.mph.rawValue:
            return measurement.converted(to: .milesPerHour).value
        case SpeedUnit.kmph.rawValue:
            return measurement.converted(to: .kilometersPerHour).value
        default:
            return measurement.converted(to: .metersPerSecond).value
        }
    }
    
    func convertedDewPoint() -> Double {
        @AppStorage(Constants.tempUnitString, store: Constants.groupUserDefaults) var unit: String = Constants.defaultTempUnit.rawValue
        let measurement = Measurement(value: self, unit: UnitTemperature.celsius)
        switch unit {
        case TemperatureUnit.fahrenheit.rawValue:
            return measurement.converted(to: .fahrenheit).value
        case TemperatureUnit.kelvin.rawValue:
            return measurement.converted(to: .kelvin).value
        default:
            return measurement.converted(to: .celsius).value
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
    
    fileprivate func toUserPrecipitation() -> Double {
        @AppStorage(Constants.precipitationUnitString, store: Constants.groupUserDefaults) var unit: String = Constants.defaultPrecipitationUnit.rawValue
        switch unit {
        case PrecipitationUnit.mm.rawValue:
            return convertPrecipitation(precipitation: self, to: .millimeters)
        default:
            return convertPrecipitation(precipitation: self, to: .inches)
        }
    }
    
    fileprivate func toUserSpeed() -> String {
        @AppStorage(Constants.speedUnitString, store: Constants.groupUserDefaults) var unit: String = Constants.defaultSpeedUnit.rawValue
        switch unit {
        case SpeedUnit.mph.rawValue:
            return convertSpeed(speed: self, unit: .milesPerHour)
        case SpeedUnit.kmph.rawValue:
            return convertSpeed(speed: self, unit: .kilometersPerHour)
        default:
            return convertSpeed(speed: self, unit: .metersPerSecond)
        }
    }
    
    fileprivate func toUserDewPoint() -> String {
        @AppStorage(Constants.tempUnitString, store: Constants.groupUserDefaults) var unit: String = Constants.defaultTempUnit.rawValue
        switch unit {
        case TemperatureUnit.fahrenheit.rawValue:
            return convertTemp(temp: self, to: .fahrenheit)
        case TemperatureUnit.kelvin.rawValue:
            return convertTemp(temp: self, to: .kelvin)
        default:
            return convertTemp(temp: self, to: .celsius)
        }
    }
    
    
    fileprivate func convertSpeed(speed: Double, unit: UnitSpeed) -> String {
        let formatter = MeasurementFormatter()
        formatter.locale = .init(identifier: LocalizeHelper.shared.currentLanguage.rawValue)
        formatter.unitOptions = .providedUnit
        formatter.numberFormatter.maximumFractionDigits = 2
        let measurement: Measurement<UnitSpeed> = Measurement(value: speed, unit: .metersPerSecond)
        return formatter.string(from: measurement.converted(to: unit)) //.removeLetterUnit()
    }
    
    fileprivate func convertTemp(temp: Double, to outputTempType: UnitTemperature) -> String {
        let formatter = MeasurementFormatter()
        formatter.locale = .init(identifier: LocalizeHelper.shared.currentLanguage.rawValue)
        formatter.numberFormatter.maximumFractionDigits = 0
        formatter.unitOptions = .providedUnit
        let input = Measurement(value: temp, unit: UnitTemperature.celsius)
        let output = input.converted(to: outputTempType)
        return formatter.string(from: output)
    }
    
    fileprivate func convertPrecipitation(precipitation: Double, to unit: UnitLength) -> Double {
        let formatter = MeasurementFormatter()
        formatter.locale = .init(identifier: LocalizeHelper.shared.currentLanguage.rawValue)
        formatter.unitOptions = .providedUnit
        formatter.numberFormatter.maximumFractionDigits = 3
        let measurement: Measurement<UnitLength> = Measurement(value: precipitation, unit: .millimeters)
        return measurement.converted(to: unit).value
    }
    
    fileprivate func convertPrecipitationWithUnit(precipitation: Double, to unit: UnitLength) -> String {
        let formatter = MeasurementFormatter()
        formatter.locale = .init(identifier: LocalizeHelper.shared.currentLanguage.rawValue)
        formatter.unitOptions = .providedUnit
        formatter.numberFormatter.maximumFractionDigits = 3
        let measurement: Measurement<UnitLength> = Measurement(value: precipitation, unit: .millimeters)
        let output = measurement.converted(to: unit)
        return formatter.string(from: output)
    }
    
}
