//
//  SavedCity.swift
//  WeatherApp
//
//  Created by Marina Marhitych on 31.05.2026.
//

import Foundation

struct SavedCity: Codable, Identifiable, Hashable {
    let id: String
    let name: String
    let country: String
    let lat: Double
    let lon: Double
    let isCurrentLocation: Bool
    
    //Preview
    static let exampleSavedCity: [SavedCity] = CityLocation.exampleCityLocation.map { $0.toSaved() }
}

extension CityLocation {
    func toSaved(isCurrentLocation: Bool = false) -> SavedCity {
        SavedCity(
            id: id,
            name: name,
            country: country,
            lat: lat,
            lon: lon,
            isCurrentLocation: isCurrentLocation
        )
    }
}
