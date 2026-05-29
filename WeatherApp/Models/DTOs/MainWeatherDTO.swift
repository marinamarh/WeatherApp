//
//  MainWeatherDTO.swift
//  WeatherApp
//
//  Created by Marina Marhitych on 29.05.2026.
//

import Foundation

struct MainWeatherDTO: Codable {
    let temp: Double
    let feelsLike: Double
    let tempMin: Double?
    let tempMax: Double?
    let humidity: Int
    let pressure: Int?
    
    enum CodingKeys: String, CodingKey {
        case temp
        case feelsLike = "feels_like"
        case tempMin = "temp_min"
        case tempMax = "temp_max"
        case humidity
        case pressure
    }
}
