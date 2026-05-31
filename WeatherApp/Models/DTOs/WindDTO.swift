//
//  WindDTO.swift
//  WeatherApp
//
//  Created by Marina Marhitych on 29.05.2026.
//

import Foundation

struct WindDTO: Decodable, Sendable {
    let speed: Double
    let deg: Int
    let gust: Double?
}
