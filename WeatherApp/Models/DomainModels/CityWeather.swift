//
//  CityWeather.swift
//  WeatherApp
//
//  Created by Marina Marhitych on 30.05.2026.
//

import Foundation

struct CityWeather: Identifiable, Hashable, Sendable, Equatable {
    let id: String
    let cityName: String
    let country: String
    let temperature: Double
    let feelsLike: Double
    let tempMin: Double
    let tempMax: Double
    let humidity: Int
    let pressure: Int
    let windSpeed: Double
    let windDeg: Int
    let description: String
    let iconCode: String
    let date: Date
    let sunrise: Date
    let sunset: Date
    let timezone: Int      

    var iconURL: URL? {
        URL(string: "https://openweathermap.org/img/wn/\(iconCode)@2x.png")
    }
}
