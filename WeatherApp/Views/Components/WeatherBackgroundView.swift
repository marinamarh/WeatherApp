//
//  WeatherBackgroundView.swift
//  WeatherApp
//
//  Created by Marina Marhitych on 09.06.2026.
//

import SwiftUI

struct WeatherBackgroundView: View {
    let weather: CityWeather

    var body: some View {
        Image(weather.backgroundImageName)
            .resizable()
            .scaledToFill()
            .ignoresSafeArea()
            .overlay {
                Color.black.opacity(weather.isDay ? 0.25 : 0.45)
                    .ignoresSafeArea()
            }
            .animation(.easeInOut(duration: 0.8), value: weather.iconCode)
    }
}

#Preview {
    WeatherBackgroundView(weather: ForecastResult.kyiv.current)
}
