//
//  CurrentWeatherDTO.swift
//  WeatherApp
//
//  Created by Marina Marhitych on 29.05.2026.
//

import Foundation

struct CurrentWeatherDTO: Codable {
    let id: Int
    let name: String
    let weather: [WeatherConditionDTO]
    let main: MainWeatherDTO
    let wind: WindDTO
    let sys: SysDTO
}

extension CurrentWeatherDTO {
    func toDomain() -> CityWeather {
        CityWeather(
            id: id,
            cityName: name,
            country: sys.country ?? "",
            temperature: main.temp,
            feelsLike: main.feelsLike,
            humidity: main.humidity,
            windSpeed: wind.speed,
            description: weather.first?.description.capitalized ?? "Unknown",
            icon: weather.first?.icon ?? "01d"
        )
    }
}
