//
//  WeatherService.swift
//  WeatherAppAssignment
//
//  Created by Amruth Kallyam on 2/2/26.
//

import Foundation

protocol WeatherServiceProtocol {
    func fetchWeather(city: String) async throws -> Weather
    func fetchWeather(latitude: Double, longitude: Double) async throws -> Weather
}

final class WeatherService: WeatherServiceProtocol {

    private let apiKey = "488722e6f15c52df1aba91e65c8bc6ca"

    func fetchWeather(city: String) async throws -> Weather {
        let encodedCity = city.addingPercentEncoding(
            withAllowedCharacters: .urlQueryAllowed
        ) ?? city

        let url = URL(
            string: "https://api.openweathermap.org/data/2.5/weather?q=\(encodedCity),US&units=imperial&appid=\(apiKey)"
        )!

        return try await request(url)
    }

    func fetchWeather(latitude: Double, longitude: Double) async throws -> Weather {
        let url = URL(
            string: "https://api.openweathermap.org/data/2.5/weather?lat=\(latitude)&lon=\(longitude)&units=imperial&appid=\(apiKey)"
        )!

        return try await request(url)
    }

    private func request(_ url: URL) async throws -> Weather {
        let (data, _) = try await URLSession.shared.data(from: url)
        let response = try JSONDecoder().decode(WeatherResponse.self, from: data)
        return response.toWeather()
    }
}
