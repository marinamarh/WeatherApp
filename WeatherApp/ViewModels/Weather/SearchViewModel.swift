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
        self.currentQuery = query
        
        guard !query.isEmpty else {
            state = .idle
            return
        }
        
        state = .loading
        try? await Task.sleep(for: .milliseconds(500))
        guard !Task.isCancelled else { return }
        
        do {
            let results = try await weatherService.searchCity(query: query)
            guard currentQuery == query else { return }
            
            state = .loaded(results)
            
        } catch {
            guard currentQuery == query else { return }
            state = .error(error.localizedDescription)
        }
    }
}
