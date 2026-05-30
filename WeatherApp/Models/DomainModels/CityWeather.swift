//
//  CityWeather.swift
//  WeatherApp
//
//  Created by Marina Marhitych on 30.05.2026.
//

import Foundation

struct CityWeather: Identifiable, Hashable  {
    let id: Int
    let cityName: String
    let country: String
    let temperature: Double
    let feelsLike: Double
    let humidity: Int
    let windSpeed: Double
    let description: String
    let icon: String
    
    var temperatureString: String {
        "\(Int(temperature.rounded()))°C"
    }
    
    var feelsLikeString: String {
        "Feels like \(Int(feelsLike.rounded()))°C"
    }
    
    var humidityString: String {
        "Humidity: \(humidity)%"
    }
    
    var windString: String {
        "Wind: \(String(format: "%.1f", windSpeed)) м/с"
    }
    
    var iconURL: URL? {
        URL(string: "https://openweathermap.org/img/wn/\(icon)@2x.png")
    }
}
