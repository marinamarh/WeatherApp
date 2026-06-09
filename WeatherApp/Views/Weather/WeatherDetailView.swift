//
//  WeatherDetailView.swift
//  WeatherApp
//
//  Created by Marina Marhitych on 04.06.2026.
//

import SwiftUI

struct WeatherDetailView: View {
    let forecast: ForecastResult

    var body: some View {
        List {
            Section {
                VStack(alignment: .leading, spacing: 8) {
                    Text("\(Int(forecast.current.temperature))°")
                        .font(.largeTitle)
                    Text(forecast.current.description)
                        .foregroundStyle(.secondary)
                    Text("Feels like \(Int(forecast.current.feelsLike))°")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
            } header: {
                Text(forecast.current.cityName)
            }

            Section("Hourly") {
                ScrollView(.horizontal) {
                    HStack {
                        ForEach(forecast.hourly) { item in
                            VStack {
                                Text(item.date, format: .dateTime.hour())
                                    .font(.caption)
                                Text("\(Int(item.temperature))°")
                            }
                            .padding(.horizontal, 8)
                        }
                    }
                }
            }

            Section("Daily") {
                ForEach(forecast.daily) { item in
                    HStack {
                        Text(item.date, format: .dateTime.weekday(.wide))
                        Spacer()
                        Text("\(Int(item.tempMin))° / \(Int(item.tempMax))°")
                    }
                }
            }
        }
        .navigationTitle(forecast.current.cityName)
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    NavigationStack {
        WeatherDetailView(forecast: .kyiv)
    }
}
