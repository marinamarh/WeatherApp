//
//  WeatherDetailView.swift
//  WeatherApp
//
//  Created by Marina Marhitych on 04.06.2026.
//

//
//  WeatherDetailView.swift
//  WeatherApp
//

import SwiftUI

struct WeatherDetailView: View {
    let forecast: ForecastResult

    private var weather: CityWeather { forecast.current }
    private var fg: Color        { weather.foregroundColor }
    private var secondary: Color { fg.opacity(0.7) }

    var body: some View {
        ZStack {
            WeatherBackgroundView(weather: weather)

            LinearGradient(
                colors: [.clear, .black.opacity(weather.isDay ? 0.2 : 0.4)],
                startPoint: .top, endPoint: .bottom
            )
            .ignoresSafeArea()
            .allowsHitTesting(false)

            ScrollView(showsIndicators: false) {
                VStack(spacing: 16) {
                    WeatherHeroSection(weather: weather)
                    WeatherHourlyCard(items: forecast.hourly, fg: fg, secondary: secondary)
                    WeatherDailyCard(days: forecast.daily, fg: fg, secondary: secondary)
                    WeatherConditionsCard(weather: weather, fg: fg, secondary: secondary)
                    WeatherSunCard(weather: weather, fg: fg, secondary: secondary)
                }
                .padding(.horizontal, 16)
                .padding(.bottom, 40)
            }
        }
        .navigationTitle(weather.cityName)
        .navigationBarTitleDisplayMode(.inline)
        .toolbarColorScheme(.dark, for: .navigationBar)
    }
}

#Preview {
    NavigationStack {
        WeatherDetailView(forecast: .kyiv)
    }
}
