//
//  LocationManager.swift
//  WeatherApp
//
//  Created by Marina Marhitych on 31.05.2026.
//

import CoreLocation
import Foundation

@MainActor
@Observable
final class LocationManager: NSObject, CLLocationManagerDelegate {
    @ObservationIgnored let manager = CLLocationManager()
    var userLocation: CLLocation?
    var currentLocation: CityLocation?
    var isAuthorized = false
    
    @ObservationIgnored private var geocodeTask: Task<Void, Never>?

    override init() {
        super.init()
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyKilometer
    }

    func startLocationServices() {
        switch manager.authorizationStatus {
        case .authorizedAlways, .authorizedWhenInUse:
            isAuthorized = true
            manager.requestLocation()
        case .notDetermined:
            isAuthorized = false
            manager.requestWhenInUseAuthorization()
        default:
            isAuthorized = false
        }
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        userLocation = location
        
        geocodeTask?.cancel()
        
        geocodeTask = Task {
            await resolveLocation(for: location)
        }
    }

    private func resolveLocation(for location: CLLocation) async {
        let geocoder = CLGeocoder()
        
        guard !Task.isCancelled else { return }
        
        guard let placemark = try? await geocoder.reverseGeocodeLocation(location).first else { return }

        guard !Task.isCancelled else { return }

        let name    = placemark.locality ?? placemark.name ?? "Unknown"
        let country = placemark.isoCountryCode ?? ""
        let state   = placemark.administrativeArea
        let id      = "\(location.coordinate.latitude),\(location.coordinate.longitude)"

        currentLocation = CityLocation(
            id:      id,
            name:    name,
            country: country,
            state:   state,
            lat:     location.coordinate.latitude,
            lon:     location.coordinate.longitude
        )
    }

    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch manager.authorizationStatus {
        case .authorizedAlways, .authorizedWhenInUse:
            isAuthorized = true
            manager.requestLocation()
        case .notDetermined:
            isAuthorized = false
            manager.requestWhenInUseAuthorization()
        case .denied, .restricted:
            isAuthorized = false
        @unknown default:
            isAuthorized = false
        }
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        if let clError = error as? CLError, clError.code == .denied {
            print("Location access denied by user.")
            return
        }
        print("Location Manager failed: \(error.localizedDescription)")
    }
}
