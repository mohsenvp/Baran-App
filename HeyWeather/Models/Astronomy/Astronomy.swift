//
//  Astronomy.swift
//  HeyWeather
//
//  Created by Kamyar on 10/12/21.
//

import Foundation
import SwiftyJSON

struct Astronomy: Codable {
    var sun: SunDataModel
    var moon: MoonDataModel
    
    init() {
        self.sun = .init()
        self.moon = .init()
    }
}
