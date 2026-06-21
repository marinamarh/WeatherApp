//
//  WeatherSunCard.swift
//  WeatherApp
//
//  Created by Marina Marhitych on 12.06.2026.
//

import SwiftUI

struct WeatherSunCard: View {
    let weather: CityWeather
    let fg: Color
    let secondary: Color

    @State private var appeared = false

    var body: some View {
        HStack(spacing: 12) {
            SunTile(icon: "sunrise.fill", label: "SUNRISE",
                    time: weather.sunrise, tint: Color(hex: "FFD54F"),
                    fg: fg, secondary: secondary)
            SunTile(icon: "sunset.fill",  label: "SUNSET",
                    time: weather.sunset,  tint: Color(hex: "FF7043"),
                    fg: fg, secondary: secondary)
        }
        .slideIn(appeared: appeared, delay: 0.40)
        .onAppear { appeared = true }
    }
}

private struct SunTile: View {
    let icon: String
    let label: String
    let time: Date
    let tint: Color
    let fg: Color
    let secondary: Color

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack(spacing: 6) {
                Image(systemName: icon)
                    .foregroundStyle(tint)
                    .font(.caption.weight(.semibold))
                Text(label)
                    .font(.caption.weight(.semibold))
                    .tracking(0.4)
                    .foregroundStyle(secondary)
            }

            Divider().overlay(fg.opacity(0.2))

            Text(time, format: .dateTime.hour().minute())
                .font(.system(size: 30, weight: .thin, design: .rounded))
                .foregroundStyle(fg)

            Spacer(minLength: 0)
        }
        .padding(16)
        .frame(maxWidth: .infinity, minHeight: 100, alignment: .leading)
        .glassEffect(.regular, in: .rect(cornerRadius: 20))
    }
}

#Preview {
    ZStack {
        Color(hex: "0A0E2A").ignoresSafeArea()
        WeatherSunCard(
            weather: ForecastResult.kyiv.current,
            fg: .white,
            secondary: .white.opacity(0.7)
        )
        .padding()
    }
}
