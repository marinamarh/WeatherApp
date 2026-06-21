//
//  WeatherBackground.swift
//  WeatherApp
//
//  Created by Marina Marhitych on 09.06.2026.
//

import Foundation
import SwiftUI

extension CityWeather {

    var isDay: Bool {
        iconCode.last == "d"
    }

    var backgroundImageName: String {
        let code = String(iconCode.dropLast())
        let time = isDay ? "day" : "night"

        switch code {
        case "01":          return "bg_clear_\(time)"
        case "02",
             "03", "04":   return "bg_cloudy_\(time)"
        case "09", "10":   return "bg_rain_\(time)"
        case "11":         return "bg_storm_\(time)"
        case "13":         return "bg_snow_\(time)"
        case "50":         return "bg_fog_\(time)"
        default:           return "bg_clear_\(time)"
        }
    }

    var foregroundColor: Color {
        let lightBgCodes = ["13d", "03d", "04d", "50d"]
        return lightBgCodes.contains(iconCode) ? .black.opacity(0.75) : .white
    }

    var windDirection: String {
        let pts = ["N", "NE", "E", "SE", "S", "SW", "W", "NW"]
        return pts[Int((Double(windDeg) / 45).rounded()) % 8]
    }
}

extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        if let int = UInt64(hex, radix: 16) {
            let r = Double((int >> 16) & 0xFF) / 255
            let g = Double((int >> 8) & 0xFF) / 255
            let b = Double(int & 0xFF) / 255
            self.init(red: r, green: g, blue: b)
        } else {
            self.init(.gray)
        }
    }
}
