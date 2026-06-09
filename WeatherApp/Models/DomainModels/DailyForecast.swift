//
//  DailyForecast.swift
//  WeatherApp
//
//  Created by Marina Marhitych on 31.05.2026.
//

import Foundation

struct DailyForecast: Identifiable, Sendable, Equatable, Hashable {
    let id: String         
    let date: Date
    let tempMin: Double
    let tempMax: Double
    let description: String
    let iconCode: String
    let pop: Double

    var iconURL: URL? {
        URL(string: "https://openweathermap.org/img/wn/\(iconCode)@2x.png")
    }
}
