//
//  WeatherPageView.swift
//  WeatherApp
//
//  Created by Marina Marhitych on 05.06.2026.
//

import SwiftUI

struct WeatherPageView: View {
    @Environment(CityStore.self) private var cityStore
    
    var body: some View {
        NavigationStack {
            Group {
                if cityStore.cities.isEmpty {
                    ContentUnavailableView(
                        "No Favorites",
                        systemImage: "heart",
                        description: Text("Add a city to favorites.")
                    )
                } else {
                    TabView {
                        ForEach(cityStore.cities) { city in
                            WeatherDetailView(city: city)
                                .tag(city.id)
                        }
                    }
                    .tabViewStyle(.page(indexDisplayMode: .always))
                    .indexViewStyle(.page(backgroundDisplayMode: .always))
                }
            }
            .navigationTitle("Weather")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

#Preview {
    let mockStore: CityStore = {
        let store = CityStore()
        let mockCity = SavedCity(id: "1", name: "London", country: "GB", lat: 51.50, lon: -0.12, isCurrentLocation: false)
        if !store.contains(mockCity) {
            store.add(mockCity)
        }
        return store
    }()
    
    WeatherPageView()
        .environment(mockStore)
}
