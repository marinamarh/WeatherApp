//
//  WeatherConditionsCard.swift
//  WeatherApp
//
//  Created by Marina Marhitych on 12.06.2026.
//

import SwiftUI

struct WeatherConditionsCard: View {
    let weather: CityWeather
        
    var body: some View {
        LazyVGrid(
            columns: [GridItem(.flexible()), GridItem(.flexible())],
            spacing: 12
        ) {
            ConditionTile(
                icon: "humidity.fill",
                label: "Humidity",
                value: "\(weather.humidity)%"
            )
            ConditionTile(
                icon: "wind",
                label: "Wind",
                value: String( format: "%.1f m/s", weather.windSpeed)
            )
            ConditionTile(
                icon: "gauge.medium",
                label: "Pressure",
                value: "\(weather.pressure) hPa"
            )
            ConditionTile(
                icon: "location.north.fill",
                label: "Direction",
                value: weather.windDirection
            )
        }
    }
}

private struct ConditionTile: View {
    let icon: String
    let label: String
    let value: String

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Label(label, systemImage: icon)
                .foregroundStyle(.white.opacity(0.6))
                .font(.caption.weight(.semibold))

            Text(value)
                .font(.system(size: 30, weight: .light))
                .foregroundStyle(.white)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(14)
    }
}

#Preview {
    ZStack {
        Color.blue.ignoresSafeArea()
        WeatherConditionsCard(
            weather: ForecastResult.kyiv.current
        )
        .padding()
    }
}
