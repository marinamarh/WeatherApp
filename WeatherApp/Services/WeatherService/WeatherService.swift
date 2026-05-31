//
//  WeatherService.swift
//  WeatherApp
//
//  Created by Marina Marhitych on 30.05.2026.
//

import Foundation

final class WeatherService: WeatherServiceProtocol {
    private let apiClient: APIClientProtocol
    private let apiKey = "379dfe28c1c0a7c276f4675222f47529"
    
    init(apiClient: APIClientProtocol = APIClient()) {
        self.apiClient = apiClient
    }
    
    func fetchCurrentWeather(lat: Double, lon: Double) async throws -> CityWeather {
        var components = URLComponents(string: "https://api.openweathermap.org/data/2.5/weather")!
        components.queryItems = [
            URLQueryItem(name: "lat", value: String(lat)),
            URLQueryItem(name: "lon", value: String(lon)),
            URLQueryItem(name: "appid", value: apiKey),
            URLQueryItem(name: "units", value: "metric"),
            URLQueryItem(name: "lang", value: "en")
        ]
        
        guard let url = components.url else { throw APIError.invalidURL }
        
        let dto: CurrentWeatherDTO = try await apiClient.fetch(url: url)
        return dto.toDomain()
    }
    
    func searchCity(query: String) async throws -> [GeocodingDTO] {
        var components = URLComponents(string: "https://api.openweathermap.org/geo/1.0/direct")!
        components.queryItems = [
            URLQueryItem(name: "q", value: query),
            URLQueryItem(name: "limit", value: "5"),
            URLQueryItem(name: "appid", value: apiKey)
        ]
        
        guard let url = components.url else { throw APIError.invalidURL }
        
        return try await apiClient.fetch(url: url)
    }
    
    func fetchForecast(lat: Double, lon: Double) async throws -> [Forecast] {
        var components = URLComponents(string: "https://api.openweathermap.org/data/2.5/forecast")!
        components.queryItems = [
            URLQueryItem(name: "lat", value: String(lat)),
            URLQueryItem(name: "lon", value: String(lon)),
            URLQueryItem(name: "appid", value: apiKey),
            URLQueryItem(name: "units", value: "metric"),
            URLQueryItem(name: "lang", value: "en")
        ]
        
        guard let url = components.url else { throw APIError.invalidURL }
        
        let responseDTO: ForecastResponseDTO = try await apiClient.fetch(url: url)
        return responseDTO.list.map { $0.toDomain() }
    }
}
