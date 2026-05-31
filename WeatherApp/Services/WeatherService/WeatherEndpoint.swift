//
//  WeatherEndpoint.swift
//  WeatherApp
//
//  Created by Marina Marhitych on 31.05.2026.
//

import Foundation

enum WeatherEndpoint {
    case forecast(lat: Double, lon: Double)
    case geocoding(query: String)

    private static let baseURL = "https://api.openweathermap.org"
    private static let apiKey = "379dfe28c1c0a7c276f4675222f47529"

    var url: URL? {
        var components = URLComponents(string: Self.baseURL)

        switch self {
        case .forecast(let lat, let lon):
            components?.path = "/data/2.5/forecast"
            components?.queryItems = [
                URLQueryItem(name: "lat",   value: String(lat)),
                URLQueryItem(name: "lon",   value: String(lon)),
                URLQueryItem(name: "appid", value: Self.apiKey),
                URLQueryItem(name: "units", value: "metric"),
                URLQueryItem(name: "lang",  value: "en")
            ]

        case .geocoding(let query):
            components?.path = "/geo/1.0/direct"
            components?.queryItems = [
                URLQueryItem(name: "q",     value: query),
                URLQueryItem(name: "limit", value: "5"),
                URLQueryItem(name: "appid", value: Self.apiKey)
            ]
        }

        return components?.url
    }
}
