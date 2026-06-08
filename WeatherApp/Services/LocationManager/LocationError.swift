//
//  LocationError.swift
//  WeatherApp
//
//  Created by Marina Marhitych on 07.06.2026.
//

import Foundation

enum LocationError: LocalizedError {
    case denied
    case geocodingFailed
    case failed(String)
    
    var errorDescription: String? {
        switch self {
        case .denied:
            return "Location access denied. Please enable it in Settings."
        case .geocodingFailed:
            return "Could not determine your city. Try again."
        case .failed(let message):
            return "Location error: \(message)"
        }
    }
}
