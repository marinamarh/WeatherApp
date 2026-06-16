//
//  WeatherListView.swift
//  WeatherApp
//
//  Created by Marina Marhitych on 04.06.2026.
//

import SwiftUI

struct WeatherListView: View {
    @Environment(WeatherViewModel.self) private var weatherViewModel
    @Environment(CityStore.self) private var cityStore

    @State private var selectedForecast: ForecastResult?

    var body: some View {
        NavigationStack {
            List {
                ForEach(cityStore.cities) { city in
                    cityRow(for: city)
                        .listRowBackground(Color.clear)
                        .listRowSeparator(.hidden)
                        .listRowInsets(.init(top: 6, leading: 16, bottom: 6, trailing: 16))
                }
                .onDelete { cityStore.remove(at: $0) }
            }
            .listStyle(.plain)
            .navigationTitle("Weather")
            .weatherDetailSheet(forecast: $selectedForecast)
        }
    }

    @ViewBuilder
    private func cityRow(for city: SavedCity) -> some View {
        switch weatherViewModel.results[city.id] ?? .idle {
        case .idle:
            EmptyView()
        case .loading:
            WeatherCityCardSkeleton(name: city.name)
        case .loaded(let forecast):
            Button { selectedForecast = forecast } label: {
                WeatherCityCard(forecast: forecast)
            }
            .buttonStyle(.plain)
        case .error(let message):
            WeatherCityCardError(name: city.name, message: message)
        }
    }
}

#Preview {
    WeatherListView()
        .environment(WeatherViewModel.example)
        .environment({
            let store = CityStore()
            SavedCity.exampleSavedCity.forEach { store.add($0) }
            return store
        }())
}
