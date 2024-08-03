//
//  MapLayer.swift
//  HeyWeather
//
//  Created by Kamyar on 9/6/21.
//

import Foundation
import SwiftyJSON
import SwiftUI

struct MapLayer: Codable, Identifiable, Equatable {
    var id = UUID()
    var key: String
    var title: String
    var unit: String
    var palette: String
    var isLayerLocked: Bool
    var isPlayLocked: Bool
    var imageDark: String
    var imageLight: String
    var opacityDark: Double
    var opacityLight: Double

    init(json: JSON) {
        self.key = json["key"].stringValue
        self.title = json["title"].stringValue
        self.unit = json["unit"].stringValue
        self.palette = json["palette"].stringValue
        self.isLayerLocked = json["lock_layer"].boolValue
        self.isPlayLocked = json["lock_play"].boolValue
        self.imageDark = json["image_dark"].stringValue
        self.imageLight = json["image_light"].stringValue
        self.opacityDark = json["opacity_dark"].doubleValue
        self.opacityLight = json["opacity_light"].doubleValue

    }
    
    init() {
        self.key = "TA2"
        self.title = ""
        self.unit = ""
        self.palette = ""
        self.isLayerLocked = false
        self.isPlayLocked = false
        self.imageDark = ""
        self.imageLight = ""
        self.opacityDark = 0.8
        self.opacityLight = 0.8
    }
    
    func getLayerGuides() -> [LayerGuide] {
        var allGuides = [LayerGuide]()
        let palettes = palette.components(separatedBy: ";")
        for palette in palettes {
            let paletteComponents = palette.components(separatedBy: ":")
            if paletteComponents.count > 1 {
                let layerGuide = LayerGuide(color: Color.init(hex: paletteComponents[1]), value: paletteComponents[0])
                allGuides.append(layerGuide)
            }
        }
        return allGuides
    }
    
}
