//
//  WeatherServiceProtocol.swift
//  WeatherApp
//
//  Created by Marina Marhitych on 30.05.2026.
//

import Foundation

protocol WeatherServiceProtocol: Sendable {
    func fetchForecast(lat: Double, lon: Double) async throws -> ForecastResult
    func searchCity(query: String) async throws -> [CityLocation]
}
