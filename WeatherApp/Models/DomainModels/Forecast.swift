//
//  Forecast.swift
//  WeatherApp
//
//  Created by Marina Marhitych on 30.05.2026.
//

import Foundation

struct Forecast: Identifiable, Hashable, Sendable, Equatable{
    let id: Int
    let date: Date
    let temperature: Double
    let feelsLike: Double
    let tempMin: Double
    let tempMax: Double
    let description: String
    let iconCode: String
    let pop: Double
    let windSpeed: Double
    let humidity: Int

    var iconURL: URL? {
        URL(string: "https://openweathermap.org/img/wn/\(iconCode)@2x.png")
    }
}

