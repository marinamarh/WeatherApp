//
//  WeatherCityCard.swift
//  WeatherApp
//
//  Created by Marina Marhitych on 12.06.2026.
//


import SwiftUI

enum WeatherCityCardState {
    case loading(cityName: String)
    case loaded(ForecastResult)
    case error(cityName: String, message: String)
}

struct WeatherCityCard: View {
    let state: WeatherCityCardState
    var isCurrentLocation: Bool = false

    var body: some View {
        ZStack(alignment: .bottomLeading) {
            cardBackground
            cardContent
        }
        .cardShape()
    }

    @ViewBuilder
    private var cardBackground: some View {
        switch state {
        case .loaded(let forecast):
            Image(forecast.current.backgroundImageName)
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

        case .loading:
            Color(.systemGray5)
                .skeleton(isRedacted: true)

        case .error:
            Color(.systemGray6)
        }
    }

    @ViewBuilder
    private var cardContent: some View {
        switch state {
        case .loaded(let forecast):
            let weather = forecast.current

            VStack(alignment: .leading, spacing: 0) {
                HStack(alignment: .top) {
                    VStack(alignment: .leading, spacing: 2) {
                        Text(weather.cityName)
                            .font(.title2.weight(.bold))
                        
                        if isCurrentLocation {
                            Text("My Location")
                                .font(.subheadline.weight(.semibold))
                                .foregroundStyle(.white.opacity(0.9))
                        }
                    }
                    Spacer()
                    
                    Text("\(Int(weather.temperature))°")
                        .font(.system(size: 54, weight: .light))
                        .monospacedDigit()
                }

                Spacer()

                HStack(alignment: .bottom) {
                    Text(weather.description.capitalized)
                        .font(.subheadline.weight(.medium))
                    
                    Spacer()
                    
                    Text("H:\(Int(weather.tempMax))°  L:\(Int(weather.tempMin))°")
                        .font(.subheadline.weight(.medium))
                }
            }
            .foregroundStyle(.white)
            .padding(16)
            .shadow(color: .black.opacity(0.3), radius: 4, x: 0, y: 1)

        case .loading(let name):
            VStack(alignment: .leading, spacing: 0) {
                HStack(alignment: .top) {
                    Text(name)
                        .font(.title2.weight(.bold))
                        .foregroundStyle(Color(.systemGray2))
                    Spacer()
                    Capsule()
                        .fill(Color(.systemGray4))
                        .frame(width: 56, height: 44)
                }
                Spacer()
                Capsule()
                    .fill(Color(.systemGray4))
                    .frame(width: 100, height: 12)
            }
            .padding(16)

        case .error(let name, let message):
            VStack(alignment: .leading, spacing: 0) {
                HStack(alignment: .top) {
                    Text(name)
                        .font(.title2.weight(.bold))
                    Spacer()
                    Image(systemName: "exclamationmark.triangle.fill")
                        .font(.title2)
                        .foregroundStyle(.red.opacity(0.7))
                }
                Spacer()
                Text(message)
                    .font(.subheadline.weight(.medium)) 
                    .foregroundStyle(.red.opacity(0.8))
            }
            .padding(16)
        }
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
        Color.blue.ignoresSafeArea()
        VStack(spacing: 12) {
            WeatherCityCard(state: .loaded(.kyiv))
            WeatherCityCard(state: .loading(cityName: "London"))
            WeatherCityCard(state: .error(cityName: "Dubai", message: "Failed to load"))
        }
        .padding()
    }
}
