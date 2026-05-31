//
//  LocationManager.swift
//  WeatherApp
//
//  Created by Marina Marhitych on 31.05.2026.
//

import CoreLocation
import SwiftUI

@Observable
final class LocationManager: NSObject {

    private(set) var location: CLLocation?
    private(set) var status: LocationStatus = .notDetermined

    private let manager = CLLocationManager()

    override init() {
        super.init()
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyKilometer
    }

    func requestLocation() {
        switch manager.authorizationStatus {
        case .notDetermined:
            manager.requestWhenInUseAuthorization()
        case .authorizedWhenInUse, .authorizedAlways:
            status = .loading
            manager.requestLocation()
        case .denied, .restricted:
            status = .denied
        @unknown default:
            break
        }
    }
}

extension LocationManager: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        location = locations.last
        status = .ready
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        status = .failed(error.localizedDescription)
    }

    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch manager.authorizationStatus {
        case .authorizedWhenInUse, .authorizedAlways:
            status = .loading
            manager.requestLocation()
        case .denied, .restricted:
            status = .denied
        default:
            break
        }
    }
}
