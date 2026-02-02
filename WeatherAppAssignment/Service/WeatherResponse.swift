//
//  WeatherResponse.swift
//  WeatherAppAssignment
//
//  Created by Amruth Kallyam on 2/2/26.
//

import Foundation

struct WeatherResponse: Decodable {
    let name: String
    let main: Main
    let weather: [Condition]

    struct Main: Decodable {
        let temp: Double
    }

    struct Condition: Decodable {
        let description: String
        let icon: String
    }

    func toWeather() -> Weather {
        Weather(
            city: name,
            temperature: main.temp,
            description: weather.first?.description ?? "",
            icon: weather.first?.icon ?? ""
        )
    }
}
