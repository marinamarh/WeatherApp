//
//  WeatherViewModel.swift
//  WeatherApp
//
//  Created by Marina Marhitych on 02.06.2026.
//

import Foundation
import CoreLocation
 
@Observable
@MainActor
final class WeatherViewModel {
    private let weatherService: WeatherServiceProtocol
    let locationManager: LocationManager
 
    var state: LoadingState<ForecastResult> = .idle
 
    init(
        weatherService: WeatherServiceProtocol = WeatherService(),
        locationManager: LocationManager = LocationManager()
    ) {
        self.weatherService = weatherService
        self.locationManager = locationManager
    }
  
    func loadWeatherForCurrentLocation() async {
        state = .loading
        do {
            let location = try await locationManager.resolveCurrentLocation()
            await loadWeather(lat: location.lat, lon: location.lon)
        } catch {
            state = .error(error.localizedDescription)
        }
    }
 
    func loadWeather(lat: Double, lon: Double) async {
        state = .loading
        do {
            let forecast = try await weatherService.fetchForecast(lat: lat, lon: lon)
            state = .loaded(forecast)
        } catch {
            state = .error(error.localizedDescription)
        }
    }
}
