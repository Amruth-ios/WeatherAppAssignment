//
//  WeatherViewModel.swift
//  WeatherAppAssignment
//
//  Created by Amruth Kallyam on 2/2/26.
//

import Foundation
import Combine
import CoreLocation

@MainActor
final class WeatherViewModel: ObservableObject {

    @Published private(set) var weather: Weather?
    @Published private(set) var isLoading = false
    @Published private(set) var errorMessage: String?
    @Published var locationPermissionDenied = false

    private let weatherService: WeatherServiceProtocol
    private var locationService: LocationServiceProtocol
    private let persistenceService: PersistenceServiceProtocol

    init(
        weatherService: WeatherServiceProtocol,
        locationService: LocationServiceProtocol,
        persistenceService: PersistenceServiceProtocol
    ) {
        self.weatherService = weatherService
        self.locationService = locationService
        self.persistenceService = persistenceService

        self.locationService.onLocationUpdate = { [weak self] lat, lon in
            Task { await self?.loadWeatherForLocation(lat: lat, lon: lon) }
        }

        self.locationService.onPermissionDenied = { [weak self] in
            self?.locationPermissionDenied = true
        }
    }

    func requestLocation() {
        locationPermissionDenied = false
        locationService.requestLocation()
    }

    func search(city: String) async {
        let trimmedCity = city.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmedCity.isEmpty else { return }

        isLoading = true
        errorMessage = nil
        defer { isLoading = false }

        do {
            let result = try await weatherService.fetchWeather(city: trimmedCity)
            weather = result
            persistenceService.saveLastCity(trimmedCity)
        } catch {
            errorMessage = "Unable to load weather. Please try again."
        }
    }

    func loadLastCity() async {
        guard let city = persistenceService.loadLastCity() else { return }
        await search(city: city)
    }

    private func loadWeatherForLocation(lat: Double, lon: Double) async {
        isLoading = true
        errorMessage = nil
        defer { isLoading = false }

        do {
            weather = try await weatherService.fetchWeather(
                latitude: lat,
                longitude: lon
            )
        } catch {
            errorMessage = "Unable to load weather for your location."
        }
    }
}
