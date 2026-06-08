//
//  MockWeatherService.swift
//  WeatherApp
//
//  Created by Marina Marhitych on 31.05.2026.
//

import Foundation

final class MockWeatherService: WeatherServiceProtocol {
    
    // Protoclo conformance
    func fetchForecast(lat: Double, lon: Double) async throws -> ForecastResult {
        .kyiv
    }
    
    func searchCity(query: String) async throws -> [CityLocation] {
        CityLocation.exampleCityLocation.filter {
            $0.name.localizedCaseInsensitiveContains(query)
        }
    }
}
