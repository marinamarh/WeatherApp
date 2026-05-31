//
//  LocationStatus.swift
//  WeatherApp
//
//  Created by Marina Marhitych on 31.05.2026.
//


enum LocationStatus {
    case notDetermined
    case loading
    case ready
    case denied
    case failed(String)
}
