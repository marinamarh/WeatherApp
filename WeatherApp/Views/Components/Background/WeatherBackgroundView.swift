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
        GeometryReader { geo in
            Image(weather.backgroundImageName)
                .resizable()
                .scaledToFill()
                .frame(width: geo.size.width, height: geo.size.height)
                .clipped()
                .overlay {
                    Color.black.opacity(0.15)
                }
                .animation(.easeInOut(duration: 0.8), value: weather.iconCode)
        }
        .ignoresSafeArea()
    }
}

#Preview {
    WeatherBackgroundView(weather: ForecastResult.kyiv.current)
}
