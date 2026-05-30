//
//  Forecast.swift
//  WeatherApp
//
//  Created by Marina Marhitych on 30.05.2026.
//

import Foundation

struct Forecast: Identifiable, Hashable {
    let id = UUID()
    let date: Date
    let temperature: Double
    let description: String
    let icon: String
    let precipitationProbability: Int
    
    var temperatureString: String {
        "\(Int(temperature.rounded()))°C"
    }
    
    var timeString: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        return formatter.string(from: date)
    }
    
    var dayString: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE, d MMM"
        formatter.locale = Locale.current
        return formatter.string(from: date).capitalized
    }
    
    var iconURL: URL? {
        URL(string: "https://openweathermap.org/img/wn/\(icon)@2x.png")
    }
}
