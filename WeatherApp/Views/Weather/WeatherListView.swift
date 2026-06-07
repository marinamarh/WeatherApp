//
//  WeatherListView.swift
//  WeatherApp
//
//  Created by Marina Marhitych on 04.06.2026.
//

import SwiftUI

struct WeatherListView: View {
    @Environment(CityStore.self) private var cityStore
    
    var body: some View {
        NavigationStack {
            List {
                if cityStore.cities.isEmpty {
                    ContentUnavailableView(
                        "No Cities",
                        systemImage: "building.2.crop.circle",
                        description: Text("Search for a city.")
                    )
                    .listRowBackground(Color.clear)
                    .listRowSeparator(.hidden)
                } else {
                    ForEach(cityStore.cities) { city in
                        NavigationLink(value: city) {
                            VStack(alignment: .leading) {
                                Text(city.name).font(.headline)
                                Text(city.country).font(.subheadline).foregroundStyle(.secondary)
                            }
                        }
                    }
                    .onDelete(perform: cityStore.remove)
                }
            }
            .navigationTitle("Cities")
            .navigationDestination(for: SavedCity.self) { selectedCity in
                WeatherDetailView(city: selectedCity)
            }
        }
    }
}

#Preview {
    let mockStore: CityStore = {
        let store = CityStore()
        let mockCity = SavedCity(id: "1", name: "Kyiv", country: "UA", lat: 50.45, lon: 30.52, isCurrentLocation: false)
        if !store.contains(mockCity) {
            store.add(mockCity)
        }
        return store
    }()
    
    WeatherListView()
        .environment(mockStore)
}
