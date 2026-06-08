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
    @ObservationIgnored private var locationContinuation: CheckedContinuation<CityLocation, Error>?
 
    override init() {
        super.init()
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyKilometer
    }
 
    func resolveCurrentLocation() async throws -> CityLocation {
        if let current = currentLocation { return current }
 
        return try await withCheckedThrowingContinuation { continuation in
            self.locationContinuation = continuation
            startLocationServices()
        }
    }
 
    func startLocationServices() {
        switch manager.authorizationStatus {
        case .authorizedAlways, .authorizedWhenInUse:
            isAuthorized = true
            manager.requestLocation()
        case .notDetermined:
            isAuthorized = false
            manager.requestWhenInUseAuthorization()
        case .denied, .restricted:
            isAuthorized = false
            locationContinuation?.resume(throwing: LocationError.denied)
            locationContinuation = nil
        @unknown default:
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
            locationContinuation?.resume(throwing: LocationError.denied)
            locationContinuation = nil
        @unknown default:
            isAuthorized = false
        }
    }
 
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        if let clError = error as? CLError, clError.code == .denied {
            locationContinuation?.resume(throwing: LocationError.denied)
        } else {
            locationContinuation?.resume(throwing: LocationError.failed(error.localizedDescription))
        }
        locationContinuation = nil
    }
  
    private func resolveLocation(for location: CLLocation) async {
        let geocoder = CLGeocoder()
 
        guard !Task.isCancelled else { return }
 
        guard let placemark = try? await geocoder.reverseGeocodeLocation(location).first else {
            locationContinuation?.resume(throwing: LocationError.geocodingFailed)
            locationContinuation = nil
            return
        }
 
        guard !Task.isCancelled else { return }
 
        let city = CityLocation(
            id:      "\(location.coordinate.latitude),\(location.coordinate.longitude)",
            name:    placemark.locality ?? placemark.name ?? "Unknown",
            country: placemark.isoCountryCode ?? "",
            state:   placemark.administrativeArea,
            lat:     location.coordinate.latitude,
            lon:     location.coordinate.longitude
        )
 
        currentLocation = city
        locationContinuation?.resume(returning: city)
        locationContinuation = nil
    }
}
