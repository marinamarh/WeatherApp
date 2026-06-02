//
//  WeatherCondition.swift
//  WeatherApp
//
//  Created by Marina Marhitych on 31.05.2026.
//

import SwiftUI

enum WeatherCondition {
    case clear
    case clouds
    case rain
    case snow
    case thunderstorm
    case other

    init(iconCode: String) {
        switch iconCode.prefix(2) {
        case "01": self = .clear
        case "02", "03", "04": self = .clouds
        case "09", "10": self = .rain
        case "13": self = .snow
        case "11": self = .thunderstorm
        default: self = .other
        }
    }

    var color: Color {
        switch self {
        case .clear:       return Color(red: 1.0, green: 0.78, blue: 0.24)
        case .clouds:      return Color(red: 0.65, green: 0.68, blue: 0.80)
        case .rain:        return Color(red: 0.24, green: 0.55, blue: 1.0)
        case .snow:        return Color(red: 0.78, green: 0.88, blue: 1.0)
        case .thunderstorm:return Color(red: 0.55, green: 0.35, blue: 1.0)
        case .other:       return Color(red: 0.65, green: 0.68, blue: 0.80)
        }
    }

    var emoji: String {
        switch self {
        case .clear:        return "☀️"
        case .clouds:       return "⛅"
        case .rain:         return "🌧"
        case .snow:         return "🌨"
        case .thunderstorm: return "⛈️"
        case .other:        return "🌤"
        }
    }
}
