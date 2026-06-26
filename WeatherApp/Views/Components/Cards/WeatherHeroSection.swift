//
//  WeatherHeroSection.swift
//  WeatherApp
//
//  Created by Marina Marhitych on 12.06.2026.
//

import SwiftUI

struct WeatherHeroSection: View {
    let weather: CityWeather

    @State private var appeared = false

    var body: some View {
        VStack(spacing: 4) {
            Image(systemName: weather.symbolName)
                .symbolRenderingMode(.multicolor)
                .font(.system(size: 72))
                .shadow(color: .black.opacity(0.3), radius: 8, y: 4)
                .frame(width: 96, height: 96)

            Text("\(Int(weather.temperature))°")
                .font(.system(size: 96, weight: .thin))
                .foregroundStyle(.white)

            Text(weather.description.capitalized)
                .font(.title2.weight(.medium))
                .foregroundStyle(.white.opacity(0.6))

            HStack(spacing: 12) {
                Label("Feels \(Int(weather.feelsLike))°", systemImage: "thermometer.medium")
                Rectangle()
                    .fill(.secondary)
                    .frame(width: 1, height: 14)
                Text("H:\(Int(weather.tempMax))°  L:\(Int(weather.tempMin))°")
            }
            .labelStyle(.titleAndIcon)
            .font(.title2.weight(.medium))
            .foregroundStyle(.white)
        }
        .frame(maxWidth: .infinity)
        .padding(.top, 8)
        .opacity(appeared ? 1 : 0)
        .scaleEffect(appeared ? 1 : 0.9)
        .animation(.spring(duration: 0.6, bounce: 0.1), value: appeared)
        .onAppear { appeared = true }
    }
}

#Preview {
    ZStack {
        Color.blue.ignoresSafeArea()
        WeatherHeroSection(weather: ForecastResult.kyiv.current)
    }
}
