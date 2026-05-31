//
//  ForecastResult.swift
//  WeatherApp
//
//  Created by Marina Marhitych on 31.05.2026.
//

import Foundation

struct ForecastResult: Sendable {
    let current: CityWeather
    let hourly: [Forecast]          
    let daily: [DailyForecast]
}


