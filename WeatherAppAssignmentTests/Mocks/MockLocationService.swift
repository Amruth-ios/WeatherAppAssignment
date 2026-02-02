//
//  MockLocationService.swift
//  WeatherAppAssignmentTests
//
//  Created by Amruth Kallyam on 2/2/26.
//

import Foundation

@testable import WeatherAppAssignment

final class MockLocationService: LocationServiceProtocol {

    var onLocationUpdate: ((Double, Double) -> Void)?
    var onPermissionDenied: (() -> Void)?

    func requestLocation() {
        // Intentionally empty.
        // Tests manually trigger callbacks.
    }
}
