//
//  GeocodingDTO.swift
//  WeatherApp
//
//  Created by Marina Marhitych on 29.05.2026.
//

import Foundation

struct GeocodingDTO: Decodable, Sendable {
    let name: String
    let lat: Double
    let lon: Double
    let country: String
    let state: String?
    let localNames: [String: String]?
    
    enum CodingKeys: String, CodingKey {
        case name, lat, lon, country, state
        case localNames = "local_names"
    }
}
