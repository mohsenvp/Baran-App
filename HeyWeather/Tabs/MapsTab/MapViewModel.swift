//
//  MapsTabViewModel.swift
//  HeyWeather
//
//  Created by Kamyar on 10/27/21.
//

import Foundation
import GoogleMaps
import SwiftUI

class MapViewModel: ObservableObject {
    
    let repository = Repository()
    @Published var selectedLayer: MapLayer = .init()
    @Published var date: Date = .now
    @Published var mapStyleJSON: String = ""
    @Published var mapData: MapData = .init()
    @Published var isPlayed: Bool = false
    @Published var isLayersViewOpen: Bool = false
    @Published var shouldCenterCity: Bool = false
    @Published var shouldReloadMap: Bool = false
    @Published var newTimeStampSelected: Bool = true
    @Published var isLoadingLayerData: Bool = true
    @Published var tileLayers: [TileLayerWrapper] = []

    
    func getMapStyle(style: MapStyle){
        Task { [weak self] in
            do {
                self?.mapStyleJSON = try await self?.repository.getMapStyle(style: style) ?? ""
                DispatchQueue.main.async { [weak self] in
                    self?.shouldReloadMap = true
                }
            } catch { }
        }
    }
    
    func selectLayer(layer: MapLayer) {
        UserDefaults.save(value: layer.key, for: .selectedMapLayerKey)
        selectedLayer = layer
        isLayersViewOpen.toggle()
        shouldReloadMap = false
        shouldReloadMap = true
    }
    
   
    func onAppear(colorScheme: ColorScheme, premium: Premium){
        if mapData.layers.isEmpty {
            getLayers(premium: premium)
        }
        if mapStyleJSON == "" {
            getMapStyle(style: colorScheme == .light ? .light : .dark)
        }
    }
    private func getLayers(premium: Premium) {
        Task { [weak self] in
            let mapData = try await self?.repository.getMapData() ?? MapData()
            DispatchQueue.main.async { [weak self] in
                self?.mapData = mapData
                self?.checkSelectedLayer(premium: premium)
                if self?.selectedLayer.title != "" {
                    mapData.layers.forEach { layer in
                        if layer.key == self?.selectedLayer.key {
                            self?.selectedLayer = layer
                        }
                    }
                }
                self?.mapData.layers = mapData.layers
                self?.shouldReloadMap = true
                self?.isLoadingLayerData = false
            }
        }
    }
    
    private func checkSelectedLayer(premium: Premium){
        if !mapData.layers.isEmpty {
            if premium.isPremium == true {
                let selectedLayerKey: String = UserDefaults.get(for: .selectedMapLayerKey) ?? ""
                selectedLayer = mapData.layers.filter({$0.key == selectedLayerKey}).first ?? (mapData.layers.first ?? MapLayer())
            }else {
                selectedLayer = mapData.layers.first ?? MapLayer()
            }
        }
    }
    
    func loadTimeLineData(){
        mapData = MapData.initSteps(mapData: mapData)
        shouldReloadMap = true
    }
}
