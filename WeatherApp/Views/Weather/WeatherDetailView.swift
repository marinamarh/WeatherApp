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
    private var secondary: Color { Color.white.opacity(0.6) }

    private var isFullScreen: Bool { safeArea != .zero }

    var body: some View {
        ZStack {
            if !isFullScreen {
                WeatherBackgroundView(weather: weather)
            }

            ScrollView(showsIndicators: false) {
                LazyVStack(spacing: 16) {
                    WeatherHeroSection(weather: weather)

                    StickySection {
                        WeatherHourlyCard(items: forecast.hourly)
                    } header: {
                        CardHeader(icon: "clock", title: "HOURLY FORECAST", color: secondary)
                    } minimisedHeader: {
                        CardHeader(icon: "clock", title: "HOURLY FORECAST", color: secondary)
                    }

                    StickySection {
                        WeatherDailyCard(days: forecast.daily)
                    } header: {
                        CardHeader(icon: "calendar", title: "7-DAY FORECAST", color: secondary)
                    } minimisedHeader: {
                        CardHeader(icon: "calendar", title: "7-DAY FORECAST", color: secondary)
                    }

                    StickySection {
                        WeatherConditionsCard(weather: weather)
                    } header: {
                        CardHeader(icon: "info.circle", title: "CONDITIONS", color: secondary)
                    } minimisedHeader: {
                        CardHeader(icon: "info.circle", title: "CONDITIONS", color: secondary)
                    }

                    StickySection {
                        WeatherSunCard(weather: weather)
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
