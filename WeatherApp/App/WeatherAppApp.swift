//
//  WeatherAppApp.swift
//  WeatherApp
//
//  Created by Marina Marhitych on 29.05.2026.
//

import SwiftUI

@main
struct WeatherAppApp: App {
    @State private var weatherViewModel = WeatherViewModel()
    @State private var cityStore = CityStore()
    var body: some Scene {
        WindowGroup {
            MainWeatherView()
                .environment(weatherViewModel)
                .environment(cityStore)
        }
    }
}
