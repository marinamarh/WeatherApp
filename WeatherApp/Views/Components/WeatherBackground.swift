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

    var backgroundGradient: LinearGradient {
        let code = String(iconCode.dropLast())

        switch (code, isDay) {
        case ("01", true):
            return .init(colors: [Color(hex: "FFD86F"), Color(hex: "FC6262")],
                         startPoint: .topLeading, endPoint: .bottomTrailing)
        case ("01", false):
            return .init(colors: [Color(hex: "0F2027"), Color(hex: "203A43"), Color(hex: "2C5364")],
                         startPoint: .top, endPoint: .bottom)
        case ("02", true):
            return .init(colors: [Color(hex: "56CCF2"), Color(hex: "2F80ED")],
                         startPoint: .topLeading, endPoint: .bottomTrailing)
        case ("02", false):
            return .init(colors: [Color(hex: "141E30"), Color(hex: "243B55")],
                         startPoint: .top, endPoint: .bottom)
        case ("03", true), ("04", true):
            return .init(colors: [Color(hex: "757F9A"), Color(hex: "D7DDE8")],
                         startPoint: .topLeading, endPoint: .bottomTrailing)
        case ("03", false), ("04", false):
            return .init(colors: [Color(hex: "1c1c2e"), Color(hex: "2d2d44")],
                         startPoint: .top, endPoint: .bottom)
        case ("09", true), ("10", true):
            return .init(colors: [Color(hex: "4B6CB7"), Color(hex: "182848")],
                         startPoint: .topLeading, endPoint: .bottomTrailing)
        case ("09", false), ("10", false):
            return .init(colors: [Color(hex: "0f0c29"), Color(hex: "302b63"), Color(hex: "24243e")],
                         startPoint: .top, endPoint: .bottom)
        case ("11", _):
            return .init(colors: [Color(hex: "1a1a2e"), Color(hex: "16213e"), Color(hex: "0f3460")],
                         startPoint: .top, endPoint: .bottom)
        case ("13", true):
            return .init(colors: [Color(hex: "E0EAFC"), Color(hex: "CFDEF3")],
                         startPoint: .topLeading, endPoint: .bottomTrailing)
        case ("13", false):
            return .init(colors: [Color(hex: "2C3E50"), Color(hex: "4CA1AF")],
                         startPoint: .top, endPoint: .bottom)
        case ("50", true):
            return .init(colors: [Color(hex: "B8C6DB"), Color(hex: "F5F7FA")],
                         startPoint: .topLeading, endPoint: .bottomTrailing)
        case ("50", false):
            return .init(colors: [Color(hex: "3D4E5C"), Color(hex: "6B7B8D")],
                         startPoint: .top, endPoint: .bottom)
        default:
            return .init(colors: [Color(hex: "56CCF2"), Color(hex: "2F80ED")],
                         startPoint: .topLeading, endPoint: .bottomTrailing)
        }
    }

    var foregroundColor: Color {
        let lightBgCodes = ["13d", "03d", "04d", "50d"]
        return lightBgCodes.contains(iconCode) ? .black.opacity(0.75) : .white
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
