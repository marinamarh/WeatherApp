//
//  ForecastResult.swift
//  WeatherApp
//
//  Created by Marina Marhitych on 31.05.2026.
//

import Foundation

struct ForecastResult: Sendable, Equatable {
    let current: CityWeather
    let hourly: [Forecast]          
    let daily: [DailyForecast]
}

// Preview
extension ForecastResult {
    static let kyiv = ForecastResult(
        current: CityWeather(
            id: "50.45,30.52",
            cityName: "Kyiv",
            country: "UA",
            temperature: 18.5,
            feelsLike: 17.2,
            tempMin: 14.0,
            tempMax: 21.3,
            humidity: 62,
            pressure: 1013,
            windSpeed: 4.2,
            windDeg: 210,
            description: "partly cloudy",
            iconCode: "02d",
            date: Date(),
            sunrise: Calendar.current.date(bySettingHour: 5, minute: 12, second: 0, of: Date())!,
            sunset: Calendar.current.date(bySettingHour: 20, minute: 48, second: 0, of: Date())!,
            timezone: 10800
        ),
        hourly: [
            Forecast(id: 0, date: Date(),
                     temperature: 18.5, feelsLike: 17.2, tempMin: 14.0, tempMax: 21.3,
                     description: "partly cloudy", iconCode: "02d",
                     pop: 0.1, windSpeed: 4.2, humidity: 62),
            Forecast(id: 1, date: Date().addingTimeInterval(3600),
                     temperature: 19.0, feelsLike: 17.8, tempMin: 14.0, tempMax: 21.3,
                     description: "few clouds", iconCode: "02d",
                     pop: 0.1, windSpeed: 3.9, humidity: 60),
            Forecast(id: 2, date: Date().addingTimeInterval(7200),
                     temperature: 20.1, feelsLike: 18.5, tempMin: 14.0, tempMax: 21.3,
                     description: "clear sky", iconCode: "01d",
                     pop: 0.0, windSpeed: 3.5, humidity: 58),
        ],
        daily: [
            DailyForecast(id: "kyiv-0", date: Date(),
                          tempMin: 13.0, tempMax: 21.0,
                          description: "partly cloudy", iconCode: "02d", pop: 0.1),
            DailyForecast(id: "kyiv-1", date: Date().addingTimeInterval(86400),
                          tempMin: 14.0, tempMax: 22.0,
                          description: "clear sky", iconCode: "01d", pop: 0.0),
            DailyForecast(id: "kyiv-2", date: Date().addingTimeInterval(172800),
                          tempMin: 12.0, tempMax: 19.0,
                          description: "light rain", iconCode: "10d", pop: 0.5),
        ]
    )

    static let london = ForecastResult(
        current: CityWeather(
            id: "51.50,-0.12",
            cityName: "London",
            country: "GB",
            temperature: 13.0,
            feelsLike: 11.5,
            tempMin: 10.0,
            tempMax: 15.0,
            humidity: 78,
            pressure: 1008,
            windSpeed: 6.7,
            windDeg: 270,
            description: "light rain",
            iconCode: "10d",
            date: Date(),
            sunrise: Calendar.current.date(bySettingHour: 4, minute: 52, second: 0, of: Date())!,
            sunset: Calendar.current.date(bySettingHour: 21, minute: 15, second: 0, of: Date())!,
            timezone: 3600
        ),
        hourly: [
            Forecast(id: 0, date: Date(),
                     temperature: 13.0, feelsLike: 11.5, tempMin: 10.0, tempMax: 15.0,
                     description: "light rain", iconCode: "10d",
                     pop: 0.7, windSpeed: 6.7, humidity: 78),
            Forecast(id: 1, date: Date().addingTimeInterval(3600),
                     temperature: 12.5, feelsLike: 11.0, tempMin: 10.0, tempMax: 15.0,
                     description: "moderate rain", iconCode: "10d",
                     pop: 0.8, windSpeed: 7.1, humidity: 82),
            Forecast(id: 2, date: Date().addingTimeInterval(7200),
                     temperature: 13.5, feelsLike: 12.0, tempMin: 10.0, tempMax: 15.0,
                     description: "overcast clouds", iconCode: "04d",
                     pop: 0.5, windSpeed: 6.3, humidity: 75),
        ],
        daily: [
            DailyForecast(id: "london-0", date: Date(),
                          tempMin: 9.0, tempMax: 15.0,
                          description: "light rain", iconCode: "10d", pop: 0.7),
            DailyForecast(id: "london-1", date: Date().addingTimeInterval(86400),
                          tempMin: 10.0, tempMax: 14.0,
                          description: "overcast clouds", iconCode: "04d", pop: 0.5),
            DailyForecast(id: "london-2", date: Date().addingTimeInterval(172800),
                          tempMin: 11.0, tempMax: 16.0,
                          description: "few clouds", iconCode: "02d", pop: 0.2),
        ]
    )

    static let dubai = ForecastResult(
        current: CityWeather(
            id: "25.20,55.27",
            cityName: "Dubai",
            country: "AE",
            temperature: 38.0,
            feelsLike: 41.5,
            tempMin: 34.0,
            tempMax: 40.0,
            humidity: 45,
            pressure: 1003,
            windSpeed: 3.1,
            windDeg: 90,
            description: "clear sky",
            iconCode: "01d",
            date: Date(),
            sunrise: Calendar.current.date(bySettingHour: 5, minute: 43, second: 0, of: Date())!,
            sunset: Calendar.current.date(bySettingHour: 19, minute: 10, second: 0, of: Date())!,
            timezone: 14400
        ),
        hourly: [
            Forecast(id: 0, date: Date(),
                     temperature: 38.0, feelsLike: 41.5, tempMin: 34.0, tempMax: 40.0,
                     description: "clear sky", iconCode: "01d",
                     pop: 0.0, windSpeed: 3.1, humidity: 45),
            Forecast(id: 1, date: Date().addingTimeInterval(3600),
                     temperature: 39.0, feelsLike: 42.5, tempMin: 34.0, tempMax: 40.0,
                     description: "clear sky", iconCode: "01d",
                     pop: 0.0, windSpeed: 2.8, humidity: 43),
            Forecast(id: 2, date: Date().addingTimeInterval(7200),
                     temperature: 37.5, feelsLike: 40.8, tempMin: 34.0, tempMax: 40.0,
                     description: "haze", iconCode: "50d",
                     pop: 0.0, windSpeed: 3.4, humidity: 48),
        ],
        daily: [
            DailyForecast(id: "dubai-0", date: Date(),
                          tempMin: 33.0, tempMax: 40.0,
                          description: "clear sky", iconCode: "01d", pop: 0.0),
            DailyForecast(id: "dubai-1", date: Date().addingTimeInterval(86400),
                          tempMin: 34.0, tempMax: 41.0,
                          description: "clear sky", iconCode: "01d", pop: 0.0),
            DailyForecast(id: "dubai-2", date: Date().addingTimeInterval(172800),
                          tempMin: 33.0, tempMax: 40.0,
                          description: "haze", iconCode: "50d", pop: 0.0),
        ]
    )
}
