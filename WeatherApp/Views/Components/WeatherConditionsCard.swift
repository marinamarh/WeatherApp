//
//  WeatherConditionsCard.swift
//  WeatherApp
//
//  Created by Marina Marhitych on 12.06.2026.
//

import SwiftUI

struct WeatherConditionsCard: View {
    let weather: CityWeather
    let fg: Color
    let secondary: Color

    @State private var appeared = false

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            CardHeader(icon: "info.circle", title: "CONDITIONS", color: secondary)
            Divider().overlay(fg.opacity(0.2))

            LazyVGrid(
                columns: [GridItem(.flexible()), GridItem(.flexible())],
                spacing: 12
            ) {
                ConditionTile(icon: "humidity.fill", label: "Humidity",
                              value: "\(weather.humidity)%",
                              fg: fg, secondary: secondary)
                ConditionTile(icon: "wind", label: "Wind",
                              value: String(format: "%.1f m/s", weather.windSpeed),
                              fg: fg, secondary: secondary)
                ConditionTile(icon: "gauge.medium", label: "Pressure",
                              value: "\(weather.pressure) hPa",
                              fg: fg, secondary: secondary)
                ConditionTile(icon: "location.north.fill", label: "Direction",
                              value: compassPoint(for: weather.windDeg),
                              fg: fg, secondary: secondary)
            }
        }
        .padding(16)
        .frame(maxWidth: .infinity)
        .glassEffect(.regular, in: .rect(cornerRadius: 20))
        .slideIn(appeared: appeared, delay: 0.30)
        .onAppear { appeared = true }
    }
}

private struct ConditionTile: View {
    let icon: String
    let label: String
    let value: String
    let fg: Color
    let secondary: Color

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Label(label, systemImage: icon)
                .font(.caption.weight(.semibold))
                .foregroundStyle(secondary)

            Text(value)
                .font(.system(size: 26, weight: .thin, design: .rounded))
                .foregroundStyle(fg)
                .minimumScaleFactor(0.7)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(14)
        .glassEffect(.regular, in: .rect(cornerRadius: 14))
    }
}

#Preview {
    ZStack {
        Color(hex: "455A64").ignoresSafeArea()
        WeatherConditionsCard(
            weather: ForecastResult.kyiv.current,
            fg: .white,
            secondary: .white.opacity(0.7)
        )
        .padding()
    }
}
