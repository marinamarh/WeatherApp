//
//  orecastItemDTO+Mapping.swift
//  WeatherApp
//
//  Created by Marina Marhitych on 31.05.2026.
//

import Foundation

extension ForecastItemDTO {
    func toDomain() -> Forecast {
        Forecast(
            id: dt,
            date: Date(timeIntervalSince1970: TimeInterval(dt)),
            temperature: main.temp,
            feelsLike: main.feelsLike,
            tempMin: main.tempMin,
            tempMax: main.tempMax,
            description: weather.first?.description ?? "",
            iconCode: weather.first?.icon ?? "01d",
            pop: pop,
            windSpeed: wind.speed,
            humidity: main.humidity
        )
    }
}
