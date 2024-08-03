//
//  LocationManager.swift
//  HeyWeather
//
//  Created by Reza Rg on 19/9/23.
//

import Foundation
import CoreLocation

class LocationAgent: NSObject, CLLocationManagerDelegate {
    
    private let locationManager = CLLocationManager()
    private var locationCheckedContinuation: CheckedContinuation<CLLocation?, Error>?
    
    override init() {
        super.init()
    }
    
    func start() {
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        self.locationManager.distanceFilter = 10
        self.locationManager.requestWhenInUseAuthorization()
        self.locationManager.startUpdatingLocation()
    }
    
    func stop() {
        self.locationManager.stopUpdatingLocation()
    }
    
    func getLocation() async throws -> CLLocation? {
        return try await withCheckedThrowingContinuation { [weak self] continuation in
            guard let self = self else {
                return
            }
            self.locationCheckedContinuation = continuation
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        checkForDeniedStatus(status: status)
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            print("Got location: lat \(location.coordinate.latitude.maxFractionDigit(to: 3)), long \(location.coordinate.longitude.maxFractionDigit(to: 3))")
            locationCheckedContinuation?.resume(returning: location)
            locationCheckedContinuation = nil
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
//        print("\(manager.authorizationStatus.description) - \(error.localizedDescription)")
        checkForDeniedStatus(status: manager.authorizationStatus)
        
        if [.authorizedAlways, .authorizedWhenInUse].contains(manager.authorizationStatus) {
            locationCheckedContinuation?.resume(returning: nil)
            locationCheckedContinuation = nil
        }
    }
    
    func checkForDeniedStatus(status: CLAuthorizationStatus) {
        if [.denied, .restricted].contains(status) {
            locationCheckedContinuation?.resume(returning: nil)
            locationCheckedContinuation = nil
        }
    }
}

extension CLAuthorizationStatus {
    var description: String {
        switch self {
        case .notDetermined:
            return "NotDetermined"
        case .restricted:
            return "Restricted"
        case .denied:
            return "Denied"
        case .authorizedAlways:
            return "AuthorizedAlways"
        case .authorizedWhenInUse:
            return "AuthorizedWhenInUse"
        @unknown default:
            return "Unknown"
        }
    }
}

extension LocationAgent {
    func getDistance(lat1 : Double, long1 : Double, lat2 : Double, long2 : Double) -> Int {
        let coordinate1 = CLLocation(latitude: lat1, longitude: long1)
        let coordinate2 = CLLocation(latitude: lat2, longitude: long2)
        return Int(coordinate1.distance(from: coordinate2))
    }
}
