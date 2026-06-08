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
    
    // Preview
    static let exampleCityLocation: [CityLocation] = [
        CityLocation(
            id: "50.45,30.52",
            name: "Kyiv",
            country: "UA",
            state: nil,
            lat: 50.4501,
            lon: 30.5234
        ),
        CityLocation(
            id: "49.84,24.03",
            name: "Lviv",
            country: "UA",
            state: nil,
            lat: 49.8397,
            lon: 24.0297
        ),
        CityLocation(
            id: "46.48,30.72",
            name: "Odesa",
            country: "UA",
            state: nil,
            lat: 46.4825,
            lon: 30.7233
        ),
        CityLocation(
            id: "51.50,-0.12",
            name: "London",
            country: "GB",
            state: nil,
            lat: 51.5074,
            lon: -0.1278
        ),
        CityLocation(
            id: "25.20,55.27",
            name: "Dubai",
            country: "AE",
            state: nil,
            lat: 25.2048,
            lon: 55.2708
        ),
        CityLocation(
            id: "48.85,2.35",
            name: "Paris",
            country: "FR",
            state: "Île-de-France",
            lat: 48.8566,
            lon: 2.3522
        )
    ]
}
