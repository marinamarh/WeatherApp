//
//  WeatherMapView.swift
//  WeatherApp
//
//  Created by Marina Marhitych on 05.06.2026.
//

import SwiftUI
import MapKit

struct WeatherMapView: View {
    var body: some View {
        NavigationStack {
            Map()
                .navigationTitle("Weather map")
                .navigationBarTitleDisplayMode(.inline)
        }
    }
}

#Preview {
    WeatherMapView()
}
