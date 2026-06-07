//
//  WeatherService.swift
//  WeatherApp
//
//  Created by Marina Marhitych on 30.05.2026.
//

import Foundation

final class WeatherService: WeatherServiceProtocol {
    private let apiClient: APIClientProtocol

    init(apiClient: APIClientProtocol = APIClient()) {
        self.apiClient = apiClient
    }

    func fetchForecast(lat: Double, lon: Double) async throws -> ForecastResult {
        guard let url = WeatherEndpoint.forecast(lat: lat, lon: lon).url else {
            throw APIError.invalidURL
        }
        let dto: ForecastResponseDTO = try await apiClient.fetch(url: url)
        return try dto.toDomain()
    }

    func searchCity(query: String) async throws -> [CityLocation] {
        guard let url = WeatherEndpoint.geocoding(query: query).url else {
            throw APIError.invalidURL
        }
        let dtos: [GeocodingDTO] = try await apiClient.fetch(url: url)
        return dtos.map { $0.toDomain() }
    }
}
