//
//  WeatherSheets.swift
//  WeatherApp
//
//  Created by Marina Marhitych on 16.06.2026.
//

import SwiftUI

extension View {
    func weatherDetailSheet(forecast: Binding<ForecastResult?>) -> some View {
        modifier(WeatherDetailSheetModifier(forecast: forecast))
    }
}

private struct WeatherDetailSheetModifier: ViewModifier {
    @Binding var forecast: ForecastResult?

    private var isPresented: Binding<Bool> {
        Binding(
            get: { forecast != nil },
            set: { if !$0 { forecast = nil } }
        )
    }

    func body(content: Content) -> some View {
        content
            .fullScreenSheet(isPresented: isPresented) { safeArea in
                if let forecast {
                    WeatherDetailView(forecast: forecast, safeArea: safeArea)
                }
            } background: {
                if let forecast {
                    WeatherBackgroundView(weather: forecast.current)
                }
            }
    }
}

extension View {
    func cityPreviewSheet(
        location: Binding<CityLocation?>,
        using weatherViewModel: WeatherViewModel,
        cityStore: CityStore,
        onAdd: @escaping () -> Void
    ) -> some View {
        modifier(CityPreviewSheetModifier(
            location: location,
            weatherViewModel: weatherViewModel,
            cityStore: cityStore,
            onAdd: onAdd
        ))
    }
}

private struct CityPreviewSheetModifier: ViewModifier {
    @Binding var location: CityLocation?
    var weatherViewModel: WeatherViewModel
    var cityStore: CityStore
    var onAdd: () -> Void

    @State private var forecast: LoadingState<ForecastResult> = .idle

    func body(content: Content) -> some View {
        content
            .sheet(item: $location) { location in
                NavigationStack {
                    switch forecast {
                    case .idle, .loading:
                        ProgressView()
                            .frame(maxWidth: .infinity, maxHeight: .infinity)

                    case .loaded(let data):
                        WeatherDetailView(forecast: data)
                            .toolbar {
                                ToolbarItem(placement: .cancellationAction) {
                                    Button {
                                        self.location = nil
                                        forecast = .idle
                                    } label: {
                                        Image(systemName: "xmark").fontWeight(.medium)
                                    }
                                    .tint(.primary)
                                }
                                ToolbarItem(placement: .confirmationAction) {
                                    Button {
                                        cityStore.add(location.toSaved())
                                        onAdd()
                                        self.location = nil
                                        forecast = .idle
                                    } label: {
                                        Image(systemName: "plus").fontWeight(.bold)
                                    }
                                }
                            }

                    case .error(let message):
                        ContentUnavailableView(
                            "Error",
                            systemImage: "exclamationmark.triangle",
                            description: Text(message)
                        )
                    }
                }
                .task {
                    forecast = .loading
                    forecast = await weatherViewModel.fetchWeatherForSearch(for: location)
                }
            }
    }
}
