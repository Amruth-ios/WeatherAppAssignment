//
//  PersistenceService.swift
//  WeatherAppAssignment
//
//  Created by Amruth Kallyam on 2/2/26.
//

import Foundation


protocol PersistenceServiceProtocol {
    func saveLastCity(_ city: String)
    func loadLastCity() -> String?
}

final class PersistenceService: PersistenceServiceProtocol {

    private let lastCityKey = "lastCity"

    func saveLastCity(_ city: String) {
        UserDefaults.standard.set(city, forKey: lastCityKey)
    }

    func loadLastCity() -> String? {
        UserDefaults.standard.string(forKey: lastCityKey)
    }
}
