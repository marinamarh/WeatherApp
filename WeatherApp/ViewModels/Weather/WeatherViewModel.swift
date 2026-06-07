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
    
    // 1. Зберігаємо весь прогноз, щоб малювати графіки на 5 днів
    var state: LoadingState<ForecastResult> = .idle
    
    init(
        weatherService: WeatherServiceProtocol = WeatherService(),
        locationManager: LocationManager = LocationManager()
    ) {
        self.weatherService = weatherService
        self.locationManager = locationManager
    }
    
    // Для поточного місця знаходження
    func loadWeatherForCurrentLocation() async {
        // Замість миттєвого nil, ми можемо дочекатися оновлення локації,
        // якщо твій LocationManager має таку функцію (наприклад, async потік координат).
        // Але для початку залишимо твою безпечну перевірку:
        guard let location = locationManager.currentLocation else {
            state = .error("Не вдалося отримати вашу геолокацію. Перевірте дозволи.")
            return
        }
        
        await loadWeather(lat: location.lat, lon: location.lon)
    }
    
    // Універсальна функція для БУДЬ-ЯКОГО міста (зі списку чи пошуку)
    func loadWeather(lat: Double, lon: Double) async {
        state = .loading
        
        do {
            let forecast = try await weatherService.fetchForecast(lat: lat, lon: lon)
            // Зберігаємо ВЕСЬ об'єкт ForecastResult
            state = .loaded(forecast)
        } catch {
            state = .error(error.localizedDescription)
        }
    }
}
