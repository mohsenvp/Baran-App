//
//  OSV+Extension.swift
//  HeyWeather
//
//  Created by Kamyar on 10/31/21.
//

import Foundation

extension OperatingSystemVersion {
    func getFullVersion(separator: String = ".") -> String {
        return "\(majorVersion)\(separator)\(minorVersion)\(separator)\(patchVersion)"
    }
}
