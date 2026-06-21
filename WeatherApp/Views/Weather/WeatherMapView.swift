//
//  WeatherMapView.swift
//  WeatherApp
//
//  Created by Marina Marhitych on 05.06.2026.
//

import SwiftUI
import MapKit

struct WeatherMapView: View {
    @Environment(WeatherViewModel.self) private var weatherViewModel
    @Environment(CityStore.self) private var cityStore

    @State private var mapPosition: MapCameraPosition = .automatic

    // Точка тапу на екрані
    @State private var tapPoint: CGPoint = .zero
    // Локація для превʼю-карточки
    @State private var previewLocation: CityLocation?
    // Стан погоди для карточки
    @State private var previewState: LoadingState<ForecastResult> = .idle
    // Sheet з деталями
    @State private var detailLocation: CityLocation?

    var body: some View {
        NavigationStack {
            MapReader { proxy in
                Map(position: $mapPosition) {
                    if let loc = weatherViewModel.locationManager.currentLocation {
                        Annotation("My Location", coordinate: CLLocationCoordinate2D(
                            latitude: loc.lat, longitude: loc.lon)
                        ) {
                            LocationAnnotation()
                        }
                    }
                }
                .mapStyle(.standard(elevation: .realistic, pointsOfInterest: .excludingAll))
                .mapControls {
                    MapUserLocationButton()
                    MapCompass()
                    MapScaleView()
                }
                .onTapGesture { screenPoint in
                    guard let coord = proxy.convert(screenPoint, from: .local) else { return }
                    tapPoint = screenPoint
                    reverseGeocode(coord)
                }
            }
            .navigationTitle("Weather Map")
            .navigationBarTitleDisplayMode(.inline)
            .overlay(alignment: .topLeading) {
                if let location = previewLocation {
                    GeometryReader { geo in
                        let cardWidth: CGFloat = geo.size.width - 32
                        let cardHeight: CGFloat = 140 + 56 + 8 // card + menu + gap
                        let x = min(max(tapPoint.x - cardWidth / 2, 16), geo.size.width - cardWidth - 16)
                        let y: CGFloat = {
                            // Якщо місце є — показуємо вище, інакше нижче
                            let above = tapPoint.y - cardHeight - 12
                            return above > 60 ? above : tapPoint.y + 12
                        }()

                        VStack(spacing: 8) {
                            WeatherCityCard(state: previewState.toCardState(cityName: location.name))

                            MapActionMenu(
                                isSaved: cityStore.cities.contains(where: { $0.id == location.id }),
                                onAdd: {
                                    cityStore.add(location.toSaved())
                                    withAnimation { previewLocation = nil; previewState = .idle }
                                },
                                onViewWeather: { detailLocation = location },
                                onDismiss: {
                                    withAnimation { previewLocation = nil; previewState = .idle }
                                }
                            )
                        }
                        .frame(width: cardWidth)
                        .position(x: x + cardWidth / 2, y: y + cardHeight / 2)
                        .transition(.scale(scale: 0.9, anchor: .bottom).combined(with: .opacity))
                    }
                }
            }
            .cityPreviewSheet(
                location: $detailLocation,
                using: weatherViewModel,
                cityStore: cityStore,
                onAdd: {}
            )
        }
    }

    // MARK: - Reverse geocode + fetch weather

    private func reverseGeocode(_ coord: CLLocationCoordinate2D) {
        let geocoder = CLGeocoder()
        let clLocation = CLLocation(latitude: coord.latitude, longitude: coord.longitude)

        geocoder.reverseGeocodeLocation(clLocation) { placemarks, _ in
            guard let place = placemarks?.first else { return }

            let name = place.locality
                ?? place.administrativeArea
                ?? place.country
                ?? "Unknown"

            let location = CityLocation(
                id: "\(String(format: "%.2f", coord.latitude)),\(String(format: "%.2f", coord.longitude))",
                name: name,
                country: place.isoCountryCode ?? "",
                state: place.administrativeArea,
                lat: coord.latitude,
                lon: coord.longitude
            )

            Task { @MainActor in
                withAnimation(.spring(duration: 0.3)) {
                    self.previewLocation = location
                    self.previewState = .loading
                }

                let result = await self.weatherViewModel.fetchWeatherForSearch(for: location)
                withAnimation {
                    self.previewState = result
                }
            }
        }
    }
}

// MARK: - LoadingState → WeatherCityCardState

private extension LoadingState where T == ForecastResult {
    func toCardState(cityName: String) -> WeatherCityCardState {
        switch self {
        case .idle, .loading:
            return .loading(cityName: cityName)
        case .loaded(let forecast):
            return .loaded(forecast)
        case .error(let message):
            return .error(cityName: cityName, message: message)
        }
    }
}

// MARK: - Action Menu

private struct MapActionMenu: View {
    let isSaved: Bool
    let onAdd: () -> Void
    let onViewWeather: () -> Void
    let onDismiss: () -> Void

    @State private var progress: CGFloat = 0

    var body: some View {
        HStack {
            // Закрити
            Button(action: onDismiss) {
                Image(systemName: "xmark")
                    .font(.title3)
                    .frame(width: 55, height: 55)
            }
            .buttonStyle(.plain)
            .glassEffect(.regular, in: .circle)

            Spacer()

            // Expandable glass menu
            ExpandableGlassMenu(
                alignment: .bottomTrailing,
                progress: progress,
                labelSize: CGSize(width: 55, height: 55)
            ) {
                VStack(alignment: .leading, spacing: 0) {
                    // Подивитися погоду
                    Button(action: {
                        withAnimation(.bouncy(duration: 0.75, extraBounce: 0.02)) {
                            progress = 0
                        }
                        onViewWeather()
                    }) {
                        menuRow("cloud.sun.fill", "View Weather")
                    }
                    .buttonStyle(.plain)

                    Divider().padding(.horizontal, 12)

                    // Додати / вже додано
                    if isSaved {
                        menuRow("checkmark.circle.fill", "Added")
                            .foregroundStyle(.secondary)
                    } else {
                        Button(action: {
                            withAnimation(.bouncy(duration: 0.75, extraBounce: 0.02)) {
                                progress = 0
                            }
                            onAdd()
                        }) {
                            menuRow("plus.circle.fill", "Add to List")
                        }
                        .buttonStyle(.plain)
                    }
                }
            } label: {
                Image(systemName: "ellipsis")
                    .font(.title3)
                    .frame(width: 55, height: 55)
                    .contentShape(.rect)
                    .onTapGesture {
                        withAnimation(.bouncy(duration: 0.75, extraBounce: 0.02)) {
                            progress = 1
                        }
                    }
            }
        }
        // Закриваємо меню при тапі поза ним
        .onTapGesture {
            if progress > 0 {
                withAnimation(.bouncy(duration: 0.75, extraBounce: 0.02)) {
                    progress = 0
                }
            }
        }
    }

    @ViewBuilder
    private func menuRow(_ icon: String, _ title: String) -> some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .font(.body)
                .symbolVariant(.fill)
                .frame(width: 32, height: 32)
                .background(.background, in: .circle)
            Text(title)
                .font(.subheadline.weight(.medium))
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 10)
    }
}

// MARK: - Location Annotation

private struct LocationAnnotation: View {
    var body: some View {
        ZStack {
            Circle()
                .fill(.blue.opacity(0.2))
                .frame(width: 32, height: 32)
            Circle()
                .fill(.blue)
                .frame(width: 14, height: 14)
            Circle()
                .stroke(.white, lineWidth: 2.5)
                .frame(width: 14, height: 14)
        }
    }
}

// MARK: - Preview

#Preview {
    WeatherMapView()
        .environment(WeatherViewModel.example)
        .environment({
            let store = CityStore()
            SavedCity.exampleSavedCity.forEach { store.add($0) }
            return store
        }())
}
