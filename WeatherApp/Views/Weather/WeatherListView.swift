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
                    cityRow(for: city)
                        .listRowBackground(Color.clear)
                        .listRowSeparator(.hidden)
                        .listRowInsets(.init(top: 6, leading: 16, bottom: 6, trailing: 16))
                }
                .onDelete { cityStore.remove(at: $0) }
            }
            .listStyle(.plain)
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
    private func cityRow(for city: SavedCity) -> some View {
        let state = weatherViewModel.results[city.id] ?? .idle

        switch state {
        case .idle:
            EmptyView()

        case .loading:
            loadingCard(name: city.name)

        case .loaded(let forecast):
            Button {
                selectedCity = city
            } label: {
                WeatherCityCard(forecast: forecast)
            }
            .buttonStyle(.plain)

        case .error(let message):
            errorCard(name: city.name, message: message)
        }
    }

    private func loadingCard(name: String) -> some View {
        HStack {
            Text(name)
                .font(.title3.weight(.semibold))
            Spacer()
            ProgressView()
                .tint(.secondary)
        }
        .padding(20)
        .frame(maxWidth: .infinity, minHeight: 80)
        .glassEffect(.regular, in: .rect(cornerRadius: 20))
    }

    private func errorCard(name: String, message: String) -> some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(name)
                    .font(.title3.weight(.semibold))
                Text(message)
                    .font(.caption)
                    .foregroundStyle(.red.opacity(0.8))
            }
            Spacer()
            Image(systemName: "exclamationmark.triangle.fill")
                .foregroundStyle(.red.opacity(0.7))
        }
        .padding(20)
        .frame(maxWidth: .infinity, minHeight: 80)
        .glassEffect(.regular, in: .rect(cornerRadius: 20))
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
