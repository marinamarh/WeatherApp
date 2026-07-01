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

    @State private var tapPoint: CGPoint = .zero
    @State private var previewLocation: CityLocation?
    @State private var previewState: LoadingState<ForecastResult> = .idle
    @State private var detailLocation: CityLocation?
    @State private var menuProgress: CGFloat = 0

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
                    if menuProgress > 0 {
                        withAnimation(.bouncy(duration: 0.75, extraBounce: 0.02)) {
                            menuProgress = 0
                        }
                        return
                    }
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
                        let cardHeight: CGFloat = 140 + 56 + 8
                        let x = min(max(tapPoint.x - cardWidth / 2, 16), geo.size.width - cardWidth - 16)
                        let y: CGFloat = {
                            let above = tapPoint.y - cardHeight - 12
                            return above > 60 ? above : tapPoint.y + 12
                        }()

                        VStack(spacing: 8) {
                            WeatherCityCard(state: previewState.toCardState(cityName: location.name))

                            MapActionMenu(
                                isSaved: cityStore.cities.contains(where: { $0.id == location.id }),
                                progress: $menuProgress,
                                onAdd: {
                                    cityStore.add(location.toSaved())
                                    withAnimation { previewLocation = nil; previewState = .idle }
                                },
                                onViewWeather: { detailLocation = location },
                                onDismiss: {
                                    withAnimation { previewLocation = nil; previewState = .idle; menuProgress = 0 }
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

private struct MapActionMenu: View {
    let isSaved: Bool
    @Binding var progress: CGFloat
    let onAdd: () -> Void
    let onViewWeather: () -> Void
    let onDismiss: () -> Void

    var body: some View {
        HStack {
            Button(action: onDismiss) {
                Image(systemName: "xmark")
                    .font(.title3)
                    .frame(width: 55, height: 55)
            }
            .buttonStyle(.plain)
            .glassEffect(.clear, in: .circle)

            Spacer()

            ExpandableGlassMenu(
                alignment: .bottomTrailing,
                progress: progress,
                labelSize: CGSize(width: 55, height: 55)
            ) {
                VStack(alignment: .leading, spacing: 0) {
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

#Preview {
    WeatherMapView()
        .environment(WeatherViewModel.example)
        .environment({
            let store = CityStore()
            SavedCity.exampleSavedCity.forEach { store.add($0) }
            return store
        }())
}
