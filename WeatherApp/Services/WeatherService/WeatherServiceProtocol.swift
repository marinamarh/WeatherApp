//
//  WeatherServiceProtocol.swift
//  WeatherApp
//
//  Created by Marina Marhitych on 30.05.2026.
//

import Foundation

protocol WeatherServiceProtocol {
    func fetchCurrentWeather(lat: Double, lon: Double) async throws -> CityWeather
    func searchCity(query: String) async throws -> [GeocodingDTO]
    func fetchForecast(lat: Double, lon: Double) async throws -> [Forecast]
}
