//
//  WeatherSunCard.swift
//  WeatherApp
//
//  Created by Marina Marhitych on 12.06.2026.
//


import SwiftUI

struct WeatherSunCard: View {
    let weather: CityWeather

    var body: some View {
        HStack(spacing: 12) {
            SunTile(icon: "sunrise.fill", label: "SUNRISE",
                    time: weather.sunrise)
            SunTile(icon: "sunset.fill",  label: "SUNSET",
                    time: weather.sunset)
        }
    }
}

private struct SunTile: View {
    let icon: String
    let label: String
    let time: Date

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack(spacing: 6) {
                Image(systemName: icon)
                    .foregroundStyle(.white.opacity(0.6))
                    .font(.caption.weight(.semibold))
                
                Text(label)
                    .font(.caption.weight(.semibold))
                    .tracking(0.4)
                    .foregroundStyle(.white.opacity(0.6))
            }

            Divider().overlay(.white.opacity(0.2))

            Text(time, format: .dateTime.hour().minute())
                .font(.system(size: 30, weight: .light))
                .foregroundStyle(.white)

            Spacer(minLength: 0)
        }
        .padding(16)
        .frame(maxWidth: .infinity, minHeight: 100, alignment: .leading)
    }
}


#Preview {
    ZStack {
        Color.blue.ignoresSafeArea()
        WeatherSunCard(weather: ForecastResult.kyiv.current)
        .padding()
    }
}
