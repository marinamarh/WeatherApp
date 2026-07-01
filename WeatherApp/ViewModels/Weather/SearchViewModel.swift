//
//  SearchViewModel.swift
//  WeatherApp
//
//  Created by Marina Marhitych on 04.06.2026.
//


import Foundation

@Observable
@MainActor
final class SearchViewModel {
    private let weatherService: WeatherServiceProtocol
    
    var state: LoadingState<[CityLocation]> = .idle
    private var currentQuery: String = ""
    
    init(weatherService: WeatherServiceProtocol = WeatherService()) {
        self.weatherService = weatherService
    }
    
    func search(query: String) async {
        currentQuery = query
        
        guard !query.isEmpty else {
            state = .idle
            return
        }
        
        do {
            try await Task.sleep(for: .milliseconds(500))
        } catch {
            return
        }
        
        guard currentQuery == query else { return }
        
        state = .loading
        
        do {
            let results = try await weatherService.searchCity(query: query)
            guard currentQuery == query else { return }
            state = results.isEmpty ? .idle : .loaded(results)
        } catch let error as APIError {
            guard currentQuery == query else { return }
            state = .error(error.errorDescription ?? "unknown error")
        } catch {
            guard currentQuery == query else { return }
            state = .error("unknown error")
        }
    }
    
    func reset() {
        currentQuery = ""
        state = .idle
    }
}
