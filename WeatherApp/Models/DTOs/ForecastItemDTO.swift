//
//  ForecastItemDTO.swift
//  WeatherApp
//
//  Created by Marina Marhitych on 29.05.2026.
//

import Foundation

struct ForecastItemDTO: Codable {
    let dt: TimeInterval
    let main: MainWeatherDTO
    let weather: [WeatherConditionDTO]
    let wind: WindDTO
    let pop: Double
    let dtTxt: String
    
    enum CodingKeys: String, CodingKey {
        case dt, main, weather, wind, pop
        case dtTxt = "dt_txt"
    }
}
