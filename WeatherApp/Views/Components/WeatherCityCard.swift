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
        .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
        .glassEffect(.regular, in: .rect(cornerRadius: 20))
    }
}

#Preview {
    ZStack {
        Color(hex: "1A1A2E").ignoresSafeArea()
        VStack(spacing: 12) {
            WeatherCityCard(forecast: .dubai)
            WeatherCityCard(forecast: .london)
            WeatherCityCard(forecast: .kyiv)
        }
        .padding()
    }
}
