//
//  MapsData.swift
//  HeyWeather
//
//  Created by Kamyar on 9/8/21.
//

import Foundation
import SwiftyJSON

struct MapData: Codable {
    var step: Float
    var maxSteps: Int
    var from: Date
    var to: Date
    var steps: [TimeInterval]
    var layers: [MapLayer]
    
    init(json: JSON) {
        step = json["step"].floatValue
        maxSteps = json["max_step"].intValue
        
        from = Date(timeIntervalSince1970: json["availability"]["from"].doubleValue)
        to = Date(timeIntervalSince1970: json["availability"]["to"].doubleValue)
        
        var mapLayers = [MapLayer]()
        json["layers"].forEach { layerJson in
            mapLayers.append(MapLayer(json: layerJson.1))
        }
        layers = mapLayers
        steps = []

      
    }
    init(){
        self.step = 3 * 3600
        self.maxSteps = 24 * 60 * 3600
        self.from = .now
        self.to = .now
        self.layers = []
        self.steps = []
    }
    
    static func initSteps(mapData: MapData) -> MapData{
        var data = mapData
        data.steps.removeAll()
        
        var counter = data.from
        while(counter < data.to) {
            counter = counter.addingTimeInterval(Double(data.step))
            data.steps.append(counter.timeIntervalSince1970)
        }
        return data
    }
    
}
