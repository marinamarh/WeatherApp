//
//  WeatherCityCard.swift
//  WeatherApp
//
//  Created by Marina Marhitych on 12.06.2026.
//

import SwiftUI

struct WeatherCityCard: View {
    let forecast: ForecastResult

    private var weather: CityWeather { forecast.current }
    private var fg: Color        { weather.foregroundColor }
    private var secondary: Color { fg.opacity(0.7) }

    var body: some View {
        ZStack(alignment: .bottomLeading) {
            Image(weather.backgroundImageName)
                .resizable()
                .scaledToFill()
                .frame(maxWidth: .infinity)
                .frame(height: 140)
                .clipped()

            LinearGradient(
                colors: [.clear, .black.opacity(0.55)],
                startPoint: .top,
                endPoint: .bottom
            )

            HStack(alignment: .bottom) {
                VStack(alignment: .leading, spacing: 2) {
                    Text(weather.cityName)
                        .font(.title3.weight(.semibold))
                    Text(weather.description.capitalized)
                        .font(.subheadline)
                        .foregroundStyle(secondary)
                }
                Spacer()
                VStack(alignment: .trailing, spacing: 2) {
                    Text("\(Int(weather.temperature))°")
                        .font(.system(size: 48, weight: .thin, design: .rounded))
                    Text("H:\(Int(weather.tempMax))°  L:\(Int(weather.tempMin))°")
                        .font(.caption)
                        .foregroundStyle(secondary)
                }
            }
            .foregroundStyle(fg)
            .padding(16)
        }
        .cardShape()
    }
}

struct WeatherCityCardSkeleton: View {
    let name: String

    var body: some View {
        ZStack(alignment: .bottomLeading) {
            Color(.systemGray5)

            HStack(alignment: .bottom) {
                VStack(alignment: .leading, spacing: 6) {
                    Text(name)
                        .font(.title3.weight(.semibold))
                        .foregroundStyle(Color(.systemGray2))
                    Capsule().fill(Color(.systemGray4)).frame(width: 90, height: 12)
                }
                Spacer()
                VStack(alignment: .trailing, spacing: 6) {
                    Capsule().fill(Color(.systemGray4)).frame(width: 56, height: 44)
                    Capsule().fill(Color(.systemGray4)).frame(width: 80, height: 12)
                }
            }
            .padding(16)
        }
        .cardShape()
        .shimmer()
    }
}

struct WeatherCityCardError: View {
    let name: String
    let message: String

    var body: some View {
        ZStack(alignment: .bottomLeading) {
            Color(.systemGray6)

            HStack(alignment: .bottom) {
                VStack(alignment: .leading, spacing: 4) {
                    Text(name)
                        .font(.title3.weight(.semibold))
                    Text(message)
                        .font(.caption)
                        .foregroundStyle(.red.opacity(0.8))
                }
                Spacer()
                Image(systemName: "exclamationmark.triangle.fill")
                    .font(.title2)
                    .foregroundStyle(.red.opacity(0.7))
            }
            .padding(16)
        }
        .cardShape()
    }
}

private extension View {
    func cardShape() -> some View {
        self
            .frame(maxWidth: .infinity)
            .frame(height: 140)
            .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
            .glassEffect(.regular, in: .rect(cornerRadius: 20))
    }
}

#Preview {
    ZStack {
        Color(hex: "1A1A2E").ignoresSafeArea()
        VStack(spacing: 12) {
            WeatherCityCard(forecast: .kyiv)
            WeatherCityCardSkeleton(name: "London")
            WeatherCityCardError(name: "Dubai", message: "Failed to load")
        }
        .padding()
    }
}
