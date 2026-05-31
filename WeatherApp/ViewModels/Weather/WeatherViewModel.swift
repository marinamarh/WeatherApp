//
//  WeatherViewModel.swift
//  WeatherApp
//
//  Created by Marina Marhitych on 31.05.2026.
//

// WeatherViewModel.swift
import Foundation
import SwiftUI

@Observable
final class WeatherViewModel {

    private(set) var viewState: WeatherViewState = .idle
    private(set) var forecastResult: ForecastResult?
    private(set) var searchResults: [CityLocation] = []
    private(set) var searchState: SearchState = .idle

    var searchQuery: String = ""

    var isSearching: Bool {
        !searchQuery.isEmpty
    }

    var current: CityWeather? {
        forecastResult?.current
    }

    var hourly: [Forecast] {
        forecastResult?.hourly ?? []
    }

    var daily: [DailyForecast] {
        forecastResult?.daily ?? []
    }

    private let weatherService: WeatherServiceProtocol

    init(weatherService: WeatherServiceProtocol = WeatherService()) {
        self.weatherService = weatherService
    }

    func loadWeather(lat: Double, lon: Double) async {
        viewState = .loading

        do {
            forecastResult = try await weatherService.fetchForecast(lat: lat, lon: lon)
            viewState = .loaded
        } catch {
            viewState = .error(error.localizedDescription)
        }
    }

    func search() async {
        let query = searchQuery.trimmingCharacters(in: .whitespaces)
        guard !query.isEmpty else {
            clearSearch()
            return
        }

        searchState = .loading

        do {
            let results = try await weatherService.searchCity(query: query)
            searchResults = results
            searchState = results.isEmpty ? .empty : .loaded
        } catch {
            searchState = .error(error.localizedDescription)
        }
    }

    func clearSearch() {
        searchQuery = ""
        searchResults = []
        searchState = .idle
    }
}
