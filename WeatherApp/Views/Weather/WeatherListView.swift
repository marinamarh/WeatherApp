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

    @State private var selectedCity: SavedCity?

    var body: some View {
        NavigationStack {
            List {
                ForEach(cityStore.cities) { city in
                    weatherRow(for: city)
                }
                .onDelete { cityStore.remove(at: $0) }
            }
            .navigationTitle("Weather")
            .sheet(item: $selectedCity) { city in
                if let forecast = weatherViewModel.results[city.id]?.data {
                    WeatherDetailView(forecast: forecast)
                        .presentationDetents([.large])
                        .presentationDragIndicator(.hidden)
                }
            }
        }
    }

    @ViewBuilder
    private func weatherRow(for city: SavedCity) -> some View {
        let state = weatherViewModel.results[city.id] ?? .idle

        switch state {
        case .idle:
            EmptyView()
        case .loading:
            HStack {
                Text(city.name)
                Spacer()
                ProgressView()
            }
        case .loaded(let forecast):
            Button {
                selectedCity = city
            } label: {
                HStack {
                    VStack(alignment: .leading) {
                        Text(city.name)
                            .font(.headline)
                        Text(forecast.current.description)
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                    Spacer()
                    Text("\(Int(forecast.current.temperature))°")
                        .font(.title2)
                }
            }
            .tint(.primary)
        case .error(let message):
            HStack {
                Text(city.name)
                Spacer()
                Text(message)
                    .font(.caption)
                    .foregroundStyle(.red)
            }
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
