//
//  WeatherDetailView.swift
//  WeatherApp
//
//  Created by Marina Marhitych on 04.06.2026.
//

import SwiftUI

struct WeatherDetailView: View {
    let forecast: ForecastResult
    var safeArea: UIEdgeInsets = .zero

    private var weather: CityWeather { forecast.current }
    private var fg: Color { weather.foregroundColor }
    private var secondary: Color { fg.opacity(0.7) }

    private var isFullScreen: Bool { safeArea != .zero }

    var body: some View {
        ZStack {
            if !isFullScreen {
                WeatherBackgroundView(weather: weather)
            }

            LinearGradient(
                colors: [.clear, .black.opacity(weather.isDay ? 0.2 : 0.4)],
                startPoint: .top, endPoint: .bottom
            )
            .ignoresSafeArea()
            .allowsHitTesting(false)

            ScrollView(showsIndicators: false) {
                LazyVStack(spacing: 16) {
                    WeatherHeroSection(weather: weather)

                    // HOURLY
                    StickySection {
                        WeatherHourlyCard(items: forecast.hourly, fg: fg, secondary: secondary)
                    } header: {
                        CardHeader(icon: "clock", title: "HOURLY FORECAST", color: secondary)
                    } minimisedHeader: {
                        CardHeader(icon: "clock", title: "HOURLY FORECAST", color: secondary)
                    }

                    // 7-DAY
                    StickySection {
                        WeatherDailyCard(days: forecast.daily, fg: fg, secondary: secondary)
                    } header: {
                        CardHeader(icon: "calendar", title: "7-DAY FORECAST", color: secondary)
                    } minimisedHeader: {
                        CardHeader(icon: "calendar", title: "7-DAY FORECAST", color: secondary)
                    }

                    // CONDITIONS
                    StickySection {
                        WeatherConditionsCard(weather: weather, fg: fg, secondary: secondary)
                    } header: {
                        CardHeader(icon: "info.circle", title: "CONDITIONS", color: secondary)
                    } minimisedHeader: {
                        CardHeader(icon: "info.circle", title: "CONDITIONS", color: secondary)
                    }

                    // SUN
                    StickySection {
                        WeatherSunCard(weather: weather, fg: fg, secondary: secondary)
                    } header: {
                        CardHeader(icon: "sun.horizon", title: "SUN & MOON", color: secondary)
                    } minimisedHeader: {
                        CardHeader(icon: "sun.horizon", title: "SUN & MOON", color: secondary)
                    }
                }
                .padding(.top, safeArea.top)
                .padding(.horizontal, 16)
                .padding(.bottom, safeArea.bottom + 40)
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
