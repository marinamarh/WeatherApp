//
//  ForecastResponseDTO+Mapping.swift
//  WeatherApp
//
//  Created by Marina Marhitych on 31.05.2026.
//

import Foundation

extension ForecastResponseDTO {
    enum MappingError: Error {
        case emptyForecastList
    }
    
    func toDomain() throws -> ForecastResult {
        guard let firstItem = list.first else {
            throw MappingError.emptyForecastList
        }
        
        return ForecastResult(
            current: CityWeather(from: firstItem, city: city),
            hourly: list.map { $0.toDomain() },
            daily: buildDailyForecasts()
        )
    }
    
    private func buildDailyForecasts() -> [DailyForecast] {
        guard !list.isEmpty else { return [] }
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        formatter.timeZone = TimeZone(secondsFromGMT: city.timezone)
        
        var groups: [String: [ForecastItemDTO]] = [:]
        for item in list {
            let key = formatter.string(from: Date(timeIntervalSince1970: TimeInterval(item.dt)))
            groups[key, default: []].append(item)
        }
        
        return groups
            .sorted { $0.key < $1.key }
            .compactMap { key, slots in
                guard let date = formatter.date(from: key) else { return nil }
                
                let representative = slots.first { $0.dtTxt.hasSuffix("12:00:00") }
                ?? slots[slots.count / 2]
                
                return DailyForecast(
                    id: key,
                    date: date,
                    tempMin: slots.map(\.main.tempMin).min() ?? representative.main.temp,
                    tempMax: slots.map(\.main.tempMax).max() ?? representative.main.temp,
                    description: representative.weather.first?.description ?? "",
                    iconCode: representative.weather.first?.icon ?? "01d",
                    pop: slots.map(\.pop).max() ?? 0
                )
            }
    }
}
