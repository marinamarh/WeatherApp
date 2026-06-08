//
//  WeatherViewModel.swift
//  WeatherApp
//
//  Created by Marina Marhitych on 02.06.2026.
//

import Foundation
import CoreLocation

@Observable
@MainActor
final class WeatherViewModel {
    private let weatherService: WeatherServiceProtocol
    let locationManager: LocationManager

    var results: [String: LoadingState<ForecastResult>] = [:]

    init(
        weatherService: WeatherServiceProtocol = WeatherService(),
        locationManager: LocationManager = LocationManager()
    ) {
        self.weatherService = weatherService
        self.locationManager = locationManager
    }

    func loadWeather(for cities: [SavedCity]) async {
        await withTaskGroup(of: (String, LoadingState<ForecastResult>).self) { group in
            for city in cities {
                guard results[city.id]?.isLoading != true else { continue }

                results[city.id] = .loading
                group.addTask {
                    do {
                        let forecast = try await self.weatherService.fetchForecast(
                            lat: city.lat,
                            lon: city.lon
                        )
                        return (city.id, .loaded(forecast))
                    } catch let error as APIError {
                        return (city.id, .error(error.errorDescription ?? "unknown error"))
                    } catch {
                        return (city.id, .error("unknown error"))
                    }
                }
            }
            for await (id, state) in group {
                results[id] = state
            }
        }
    }

    func loadWeatherForCurrentLocation() async {
        guard locationManager.currentLocation.map({ results[$0.id]?.isLoading != true }) ?? true else { return }

        do {
            let location = try await locationManager.resolveCurrentLocation()
            let city = location.toSaved(isCurrentLocation: true)
            results[city.id] = .loading
            let forecast = try await weatherService.fetchForecast(
                lat: location.lat,
                lon: location.lon
            )
            results[city.id] = .loaded(forecast)
        } catch let error as APIError {
            results["current"] = .error(error.errorDescription ?? "unknown error")
        } catch {
            results["current"] = .error("unknown error")
        }
    }

    // Preview
    static var example: WeatherViewModel {
        let vm = WeatherViewModel(weatherService: MockWeatherService())
        vm.results = [
            "50.45,30.52": .loaded(.kyiv),
            "51.50,-0.12": .loaded(.london),
            "25.20,55.27": .loaded(.dubai)
        ]
        return vm
    }
}
