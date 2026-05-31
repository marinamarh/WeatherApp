//
//  ForecastItemDTO.swift
//  WeatherApp
//
//  Created by Marina Marhitych on 29.05.2026.
//

import Foundation

struct ForecastItemDTO: Decodable, Sendable {
    let dt: Int
    let main: MainWeatherDTO
    let weather: [WeatherConditionDTO]
    let wind: WindDTO
    let visibility: Int?
    let pop: Double
    let dtTxt: String

    enum CodingKeys: String, CodingKey {
        case dt, main, weather, wind, visibility, pop
        case dtTxt = "dt_txt"
    }
}
