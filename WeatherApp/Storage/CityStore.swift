//
//  CityStore.swift
//  WeatherApp
//
//  Created by Marina Marhitych on 31.05.2026.
//

import Foundation
import SwiftUI

@Observable
final class CityStore {
    private(set) var cities: [SavedCity] = []

    private let key = "saved_cities"

    init() {
        load()
    }

    func add(_ city: SavedCity) {
        guard !cities.contains(where: { $0.id == city.id }) else { return }
        cities.append(city)
        save()
    }

    func remove(_ city: SavedCity) {
        cities.removeAll { $0.id == city.id }
        save()
    }

    func contains(_ city: SavedCity) -> Bool {
        cities.contains { $0.id == city.id }
    }

    private func save() {
        guard let data = try? JSONEncoder().encode(cities) else { return }
        UserDefaults.standard.set(data, forKey: key)
    }

    private func load() {
        guard
            let data = UserDefaults.standard.data(forKey: key),
            let saved = try? JSONDecoder().decode([SavedCity].self, from: data)
        else { return }
        cities = saved
    }
}
