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
        case "01":          
            return "bg_clear_\(time)"
        case "02", "03", "04":
            return "bg_cloudy_\(time)"
        case "09", "10":   
            return "bg_rain_\(time)"
        case "11":         
            return "bg_storm_\(time)"
        case "13":         
            return "bg_snow_\(time)"
        case "50":         
            return "bg_fog_\(time)"
        default:           
            return "bg_clear_\(time)"
        }
    }

    var windDirection: String {
        let pts = ["N", "NE", "E", "SE", "S", "SW", "W", "NW"]
        return pts[Int((Double(windDeg) / 45).rounded()) % 8]
    }
}
