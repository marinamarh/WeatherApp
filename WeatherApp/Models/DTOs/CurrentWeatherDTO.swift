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
