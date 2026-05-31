//
//  CityWeather+Mapping.swift
//  WeatherApp
//
//  Created by Marina Marhitych on 31.05.2026.
//

import Foundation

extension CityWeather {
    init(from item: ForecastItemDTO, city: ForecastCityDTO) {
        self.id = "\(city.name)-\(item.dt)"
        self.cityName = city.name
        self.country = city.country
        self.temperature = item.main.temp
        self.feelsLike = item.main.feelsLike
        self.tempMin = item.main.tempMin
        self.tempMax = item.main.tempMax
        self.humidity = item.main.humidity
        self.pressure = item.main.pressure
        self.windSpeed = item.wind.speed
        self.windDeg = item.wind.deg
        self.description = item.weather.first?.description ?? ""
        self.iconCode = item.weather.first?.icon ?? "01d"
        self.date = Date(timeIntervalSince1970: TimeInterval(item.dt))
        self.sunrise = Date(timeIntervalSince1970: TimeInterval(city.sunrise))
        self.sunset = Date(timeIntervalSince1970: TimeInterval(city.sunset))
        self.timezone = city.timezone
    }
}
