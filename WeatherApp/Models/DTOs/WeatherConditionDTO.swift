//
//  WeatherConditionDTO.swift
//  WeatherApp
//
//  Created by Marina Marhitych on 29.05.2026.
//

import Foundation

struct WeatherConditionDTO: Codable {
    let id: Int
    let main: String
    let description: String
    let icon: String
}
