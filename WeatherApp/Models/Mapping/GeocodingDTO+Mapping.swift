//
//  GeocodingDTO+Mapping.swift
//  WeatherApp
//
//  Created by Marina Marhitych on 31.05.2026.
//

import Foundation

extension GeocodingDTO {
    func toDomain() -> CityLocation {
        CityLocation(
            id: "\(lat),\(lon)",
            name: name,
            country: country,
            state: state,
            lat: lat,
            lon: lon
        )
    }
}
