//
//  ContentView.swift
//  WeatherApp
//
//  Created by Marina Marhitych on 29.05.2026.
//

import SwiftUI

struct MainWeatherView: View {
    @Environment(CityStore.self) private var cityStore
    
    var body: some View {
        TabView {
            Tab("Cities", systemImage: "list.bullet") {
                WeatherListView()
            }
            
            Tab("Favorites", systemImage: "heart.fill") {
                FavoritesView()
            }
            
            Tab("Map", systemImage: "map") {
                WeatherMapView()
            }
            
            Tab("Search", systemImage: "magnifyingglass", role: .search) {
                SearchCityView()
            }
        }
    }
}

#Preview {
    
}
