//
//  MockWeatherService.swift
//  WeatherApp
//
//  Created by Marina Marhitych on 31.05.2026.
//

import Foundation

final class MockWeatherService: WeatherServiceProtocol {

    func fetchForecast(lat: Double, lon: Double) async throws -> ForecastResult {
        ForecastResult(
            current: CityWeather(
                id: "kyiv-mock",
                cityName: "Kyiv",
                country: "UA",
                temperature: 22,
                feelsLike: 20,
                tempMin: 18,
                tempMax: 25,
                humidity: 60,
                pressure: 1013,
                windSpeed: 4.5,
                windDeg: 180,
                description: "clear sky",
                iconCode: "01d",
                date: .now,
                sunrise: Calendar.current.date(bySettingHour: 6, minute: 0, second: 0, of: .now)!,
                sunset: Calendar.current.date(bySettingHour: 20, minute: 0, second: 0, of: .now)!,
                timezone: 10800
            ),
            hourly: (0..<8).map { i in
                Forecast(
                    id: i,
                    date: .now.addingTimeInterval(TimeInterval(i * 3 * 3600)),
                    temperature: Double.random(in: 18...26),
                    feelsLike: Double.random(in: 16...24),
                    tempMin: 17,
                    tempMax: 27,
                    description: i % 2 == 0 ? "clear sky" : "few clouds",
                    iconCode: i % 2 == 0 ? "01d" : "02d",
                    pop: Double.random(in: 0...0.3),
                    windSpeed: Double.random(in: 2...6),
                    humidity: Int.random(in: 50...70)
                )
            },
            daily: (0..<5).map { i in
                DailyForecast(
                    id: "day-\(i)",
                    date: .now.addingTimeInterval(TimeInterval(i * 86400)),
                    tempMin: Double.random(in: 14...18),
                    tempMax: Double.random(in: 22...28),
                    description: ["clear sky", "few clouds", "light rain", "scattered clouds", "sunny"][i],
                    iconCode: ["01d", "02d", "10d", "03d", "01d"][i],
                    pop: Double.random(in: 0...0.5)
                )
            }
        )
    }

    func searchCity(query: String) async throws -> [CityLocation] {
        let cities = [
            CityLocation(id: "50.45,30.52", name: "Kyiv",  country: "UA", state: nil, lat: 50.4501, lon: 30.5234),
            CityLocation(id: "49.84,24.03", name: "Lviv",  country: "UA", state: nil, lat: 49.8397, lon: 24.0297),
            CityLocation(id: "46.48,30.72", name: "Odesa", country: "UA", state: nil, lat: 46.4825, lon: 30.7233)
        ]
        return cities.filter { $0.name.localizedCaseInsensitiveContains(query) }
    }
}
