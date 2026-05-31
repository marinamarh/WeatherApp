//
//  ForecastCityDTO.swift
//  WeatherApp
//
//  Created by Marina Marhitych on 29.05.2026.
//

import Foundation

struct ForecastCityDTO: Decodable, Sendable {
    let name: String
    let country: String
    let timezone: Int
    let sunrise: Int
    let sunset: Int
}
