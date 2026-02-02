//
//  MockWeatherService.swift
//  WeatherAppAssignmentTests
//
//  Created by Amruth Kallyam on 2/2/26.
//

import Foundation

@testable import WeatherAppAssignment

final class MockWeatherService: WeatherServiceProtocol {

    var result: Result<Weather, Error>!

    func fetchWeather(city: String) async throws -> Weather {
        try result.get()
    }

    func fetchWeather(latitude: Double, longitude: Double) async throws -> Weather {
        try result.get()
    }
}
