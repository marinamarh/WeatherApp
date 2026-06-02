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
    
    var currentForecast: ForecastResult?
    var searchResults: [CityLocation] = []
    var errorMessage: String?
    var isLoading = false
    
    init(
        weatherService: WeatherServiceProtocol = WeatherService(),
        locationManager: LocationManager = LocationManager()
    ) {
        self.weatherService = weatherService
        self.locationManager = locationManager
    }
    
    func loadWeatherForCurrentLocation() async {
        guard let location = locationManager.currentLocation else {
            errorMessage = "Can not get location"
            return
        }
        
        await fetchForecast(lat: location.lat, lon: location.lon)
    }
    
    func search(query: String) async {
        guard !query.isEmpty else {
            searchResults = []
            return
        }
        
        do {
            searchResults = try await weatherService.searchCity(query: query)
        } catch {
            errorMessage = "Search error: \(error.localizedDescription)"
            print(error)
        }
    }
    
    func selectCityAndLoadWeather(_ city: CityLocation) async {
        await fetchForecast(lat: city.lat, lon: city.lon)
        searchResults = [] // Очищаємо результати пошуку після вибору
    }
    
    private func fetchForecast(lat: Double, lon: Double) async {
        isLoading = true
        errorMessage = nil
        
        do {
            currentForecast = try await weatherService.fetchForecast(lat: lat, lon: lon)
        } catch {
            errorMessage = "Can not fetch weather: \(error.localizedDescription)"
        }
        
        isLoading = false
    }
}
