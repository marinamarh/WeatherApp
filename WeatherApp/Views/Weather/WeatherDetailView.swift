//
//  WeatherDetailView.swift
//  WeatherApp
//
//  Created by Marina Marhitych on 04.06.2026.
//

import SwiftUI

struct WeatherDetailView: View {
    let city: SavedCity
    @State private var viewModel = WeatherViewModel()
    
    var body: some View {
        Text("Details")
    }
}

#Preview {
    let mockCity = SavedCity(
        id: "1",
        name: "Kyiv",
        country: "UA",
        lat: 50.4501,
        lon: 30.5234,
        isCurrentLocation: false 
    )
    
    NavigationStack {
        WeatherDetailView(city: mockCity)
    }
}
