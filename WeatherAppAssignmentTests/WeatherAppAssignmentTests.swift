//
//  WeatherAppAssignmentTests.swift
//  WeatherAppAssignmentTests
//
//  Created by Amruth Kallyam on 2/2/26.
//

import XCTest

@testable import WeatherAppAssignment

@MainActor
final class WeatherAppAssignmentTests: XCTestCase {


    func testSearchCitySuccessUpdatesWeatherAndSavesCity() async {

        let weather = Weather(
            city: "Austin",
            temperature: 82,
            description: "clear sky",
            icon: "01d"
        )

        let weatherService = MockWeatherService()
        weatherService.result = .success(weather)

        let persistence = MockPersistenceService()
        let locationService = MockLocationService()

        let viewModel = WeatherViewModel(
            weatherService: weatherService,
            locationService: locationService,
            persistenceService: persistence
        )

        await viewModel.search(city: "Austin")

        XCTAssertEqual(viewModel.weather?.city, "Austin")
        XCTAssertEqual(persistence.savedCity, "Austin")
        XCTAssertNil(viewModel.errorMessage)
        XCTAssertFalse(viewModel.isLoading)
    }

    func testSearchCityFailureShowsError() async {

        let weatherService = MockWeatherService()
        weatherService.result = .failure(URLError(.badServerResponse))

        let viewModel = WeatherViewModel(
            weatherService: weatherService,
            locationService: MockLocationService(),
            persistenceService: MockPersistenceService()
        )


        await viewModel.search(city: "InvalidCity")


        XCTAssertNil(viewModel.weather)
        XCTAssertNotNil(viewModel.errorMessage)
        XCTAssertFalse(viewModel.isLoading)
    }


    func testLocationPermissionDeniedSetsFlag() {

        let locationService = MockLocationService()

        let viewModel = WeatherViewModel(
            weatherService: MockWeatherService(),
            locationService: locationService,
            persistenceService: MockPersistenceService()
        )

        locationService.onPermissionDenied?()
        XCTAssertTrue(viewModel.locationPermissionDenied)
    }


    func testLocationUpdateFetchesWeather() async {
        let weather = Weather(
            city: "San Francisco",
            temperature: 65,
            description: "foggy",
            icon: "50d"
        )

        let weatherService = MockWeatherService()
        weatherService.result = .success(weather)

        let locationService = MockLocationService()

        let viewModel = WeatherViewModel(
            weatherService: weatherService,
            locationService: locationService,
            persistenceService: MockPersistenceService()
        )

        locationService.onLocationUpdate?(37.7749, -122.4194)

        try? await Task.sleep(nanoseconds: 300_000_000)

        XCTAssertEqual(viewModel.weather?.city, "San Francisco")
        XCTAssertNil(viewModel.errorMessage)
    }


    func testLoadLastCityTriggersSearch() async {
        let weather = Weather(
            city: "Dallas",
            temperature: 90,
            description: "hot",
            icon: "01d"
        )

        let weatherService = MockWeatherService()
        weatherService.result = .success(weather)

        let persistence = MockPersistenceService()
        persistence.saveLastCity("Dallas")

        let viewModel = WeatherViewModel(
            weatherService: weatherService,
            locationService: MockLocationService(),
            persistenceService: persistence
        )

        await viewModel.loadLastCity()

        XCTAssertEqual(viewModel.weather?.city, "Dallas")
    }
}
