//
//  GeocodingDTO.swift
//  WeatherApp
//
//  Created by Marina Marhitych on 29.05.2026.
//

import Foundation

struct GeocodingDTO: Codable {
    let name: String
    let lat: Double
    let lon: Double
    let country: String
    let localNames: [String: String]? 
    
    enum CodingKeys: String, CodingKey {
        case name, lat, lon, country
        case localNames = "local_names"
    }
}
