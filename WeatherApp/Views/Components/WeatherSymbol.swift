//
//  WeatherSymbol.swift
//  WeatherApp
//
//  Created by Marina Marhitych on 11.06.2026.
//

import Foundation

func weatherSymbol(for iconCode: String) -> String {
    let code = String(iconCode.dropLast())
    let isNight = iconCode.hasSuffix("n")
    switch code {
    case "01": return isNight ? "moon.stars.fill"      : "sun.max.fill"
    case "02": return isNight ? "cloud.moon.fill"      : "cloud.sun.fill"
    case "03": return "cloud.fill"
    case "04": return "smoke.fill"
    case "09": return "cloud.drizzle.fill"
    case "10": return isNight ? "cloud.moon.rain.fill" : "cloud.sun.rain.fill"
    case "11": return "cloud.bolt.rain.fill"
    case "13": return "snowflake"
    case "50": return "cloud.fog.fill"
    default:   return "cloud.fill"
    }
}

func compassPoint(for degrees: Int) -> String {
    let pts = ["N", "NE", "E", "SE", "S", "SW", "W", "NW"]
    return pts[Int((Double(degrees) / 45).rounded()) % 8]
}
