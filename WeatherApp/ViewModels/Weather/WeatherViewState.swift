//
//  WeatherViewState.swift
//  WeatherApp
//
//  Created by Marina Marhitych on 31.05.2026.
//

import Foundation

enum WeatherViewState {
    case idle
    case loading
    case loaded
    case error(String)
}

enum SearchState {
    case idle
    case loading
    case loaded
    case empty
    case error(String)
}
