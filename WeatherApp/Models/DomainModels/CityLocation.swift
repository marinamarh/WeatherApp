//
//  CityLocation.swift
//  WeatherApp
//
//  Created by Marina Marhitych on 31.05.2026.
//

import Foundation

struct CityLocation: Identifiable, Hashable, Sendable, Equatable {
    let id: String 
    let name: String
    let country: String
    let state: String?
    let lat: Double
    let lon: Double
}
