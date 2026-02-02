//
//  MockPersistenceService.swift
//  WeatherAppAssignmentTests
//
//  Created by Amruth Kallyam on 2/2/26.
//

import Foundation

@testable import WeatherAppAssignment

final class MockPersistenceService: PersistenceServiceProtocol {

    private(set) var savedCity: String?

    func saveLastCity(_ city: String) {
        savedCity = city
    }

    func loadLastCity() -> String? {
        savedCity
    }
}
