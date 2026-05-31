//
//  APIError.swift
//  WeatherApp
//
//  Created by Marina Marhitych on 30.05.2026.
//

import Foundation

enum APIError: Error, LocalizedError {
    case invalidURL
    case serverError(Int)
    case decodingError(Error)
    case unknown
    
    var errorDescription: String? {
        switch self {
        case .invalidURL: return "Invalid request URL."
        case .serverError(let code): return "Server error. Code: \(code)"
        case .decodingError(let error): return "Data processing error: \(error.localizedDescription)"
        case .unknown: return "Unknown network error."
        }
    }
}
