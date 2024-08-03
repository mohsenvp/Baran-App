//
//  WeatherMapsView.swift
//  HeyWeather
//
//  Created by Kamyar on 8/17/21.
//

import SwiftUI
import GoogleMaps

struct TileLayerWrapper {
    var tileLayer: GMSURLTileLayer
    var timestamp: TimeInterval
}
struct MapView: UIViewRepresentable {
    @ObservedObject var viewModel: MapViewModel
    var repository = Repository()
    @Environment(\.colorScheme) var colorScheme
    @EnvironmentObject var premium : Premium
    
    func makeUIView(context: Context) -> GMSMapView {
        
        let camera = GMSCameraPosition.camera(withLatitude: CityAgent.getSelectedCity().location.lat, longitude: CityAgent.getSelectedCity().location.long, zoom: 8.0)
        let mapView = GMSMapView.map(withFrame: .zero, camera: camera)
        mapView.isMyLocationEnabled = true
        
        return mapView
    }
    
    @MainActor
    func updateUIView(_ mapView: GMSMapView, context: Context) {
        
        
        if viewModel.shouldReloadMap {
            mapView.clear()
            for tileLayer in viewModel.tileLayers {
                tileLayer.tileLayer.clearTileCache()
            }
            viewModel.tileLayers.removeAll()
            
            do {
                if viewModel.mapStyleJSON != "" {
                    mapView.mapStyle = try GMSMapStyle(jsonString: viewModel.mapStyleJSON)
                }
            }catch{
                print(error)
            }
            if viewModel.mapData.steps.isEmpty {
                let timestamp = Date().timeIntervalSince1970
                let layer = createLayer(timestamp: timestamp)
                layer.map = mapView
                viewModel.tileLayers.append(TileLayerWrapper(tileLayer: layer, timestamp: timestamp) as TileLayerWrapper)
                viewModel.date = Date(timeIntervalSince1970: timestamp)
            }else {
                for timestamp in viewModel.mapData.steps {
                    let layer = createLayer(timestamp: timestamp)
                    layer.map = mapView
                    viewModel.tileLayers.append(TileLayerWrapper(tileLayer: layer, timestamp: timestamp) as TileLayerWrapper)
                }
                if !viewModel.mapData.steps.isEmpty {
                    viewModel.date = Date(timeIntervalSince1970: viewModel.mapData.steps[0])
                }
            }
          
            let marker = GMSMarker(position: CLLocationCoordinate2D(latitude: CityAgent.getSelectedCity().location.lat, longitude: CityAgent.getSelectedCity().location.long))
            marker.title = CityAgent.getMainCity().name
            marker.map = mapView
            
            viewModel.newTimeStampSelected = true
            viewModel.shouldReloadMap = false
        }
        
        if viewModel.shouldCenterCity {
            mapView.animate(toLocation: CLLocationCoordinate2D(latitude: CityAgent.getSelectedCity().location.lat, longitude: CityAgent.getSelectedCity().location.long))
            viewModel.shouldCenterCity = false
        }
        
        if viewModel.newTimeStampSelected {
            for tileLayer in viewModel.tileLayers {
                if tileLayer.timestamp.isEqual(to: viewModel.date.timeIntervalSince1970) {
                    tileLayer.tileLayer.opacity = 1
                }else {
                    tileLayer.tileLayer.opacity = 0
                }
            }
            viewModel.newTimeStampSelected = false
        }
        
        
    }
    
    private func createLayer(timestamp: TimeInterval) -> GMSURLTileLayer{
        let layer = GMSURLTileLayer(urlConstructor: { (x, y, zoom) in
            var tileURL : URL? = URL(string: "")
            repository.getMapTilesURL(
                style: colorScheme == .dark ? .dark : .light,
                layer: viewModel.selectedLayer,
                x: x,
                y: y,
                z: zoom,
                timestamp: Date(timeIntervalSince1970: timestamp),
                isPremium: premium.isPremium
            ) {
                tileURLFromServer in
                tileURL = tileURLFromServer
            }
            return tileURL
        })
        layer.fadeIn = false
        layer.userAgent = repository.getUserAgent()
        layer.opacity = 0
        return layer
    }
    
    
}
