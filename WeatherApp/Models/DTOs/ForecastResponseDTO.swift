//
//  ForecastResponseDTO.swift
//  WeatherApp
//
//  Created by Marina Marhitych on 29.05.2026.
//

import Foundation

struct ForecastResponseDTO: Decodable, Sendable {
    let list: [ForecastItemDTO]
    let city: ForecastCityDTO
}
