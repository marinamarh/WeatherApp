//
//  ContentView.swift
//  WeatherApp
//
//  Created by Marina Marhitych on 29.05.2026.
//

import SwiftUI

struct MainWeatherView: View {
    @Environment(WeatherViewModel.self) private var weatherViewModel
    @Environment(CityStore.self) private var cityStore

    var body: some View {
        TabView {
            Tab("Weather", systemImage: "cloud.sun.fill") {
                WeatherListView()
            }
            Tab("Map", systemImage: "map") {
                WeatherMapView()
            }
            Tab(role: .search) {
                SearchCityView()
            }
        }
        .task {
            await weatherViewModel.loadWeatherForCurrentLocation()
            if let location = weatherViewModel.locationManager.currentLocation {
                cityStore.add(location.toSaved(isCurrentLocation: true))
            }
        }
        .task(id: cityStore.cities.count) {
            await weatherViewModel.loadWeather(for: cityStore.cities)
        }
    }
}

#Preview {
    MainWeatherView()
        .environment(WeatherViewModel.example)
        .environment({
            let store = CityStore()
            SavedCity.exampleSavedCity.forEach { store.add($0) }
            return store
        }())
}
