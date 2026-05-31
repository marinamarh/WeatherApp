//
//  APIClientProtocol.swift
//  WeatherApp
//
//  Created by Marina Marhitych on 30.05.2026.
//

import Foundation

protocol APIClientProtocol {
    func fetch<T: Decodable & Sendable>(url: URL) async throws -> T
}
