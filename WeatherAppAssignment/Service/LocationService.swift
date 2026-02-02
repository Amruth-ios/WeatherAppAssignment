//
//  LocationService.swift
//  WeatherAppAssignment
//
//  Created by Amruth Kallyam on 2/2/26.
//

import Foundation
import CoreLocation

protocol LocationServiceProtocol {
    var onLocationUpdate: ((Double, Double) -> Void)? { get set }
    var onPermissionDenied: (() -> Void)? { get set }
    func requestLocation()
}
final class LocationService: NSObject, CLLocationManagerDelegate, LocationServiceProtocol {

    private let manager = CLLocationManager()

    var onLocationUpdate: ((Double, Double) -> Void)?
    var onPermissionDenied: (() -> Void)?

    override init() {
        super.init()
        manager.delegate = self
    }

    func requestLocation() {
        switch manager.authorizationStatus {
        case .notDetermined:
            manager.requestWhenInUseAuthorization()

        case .authorizedWhenInUse, .authorizedAlways:
            manager.requestLocation()

        case .denied, .restricted:
            onPermissionDenied?()

        @unknown default:
            break
        }
    }

    func locationManager(_ manager: CLLocationManager,
                         didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else { return }
        onLocationUpdate?(
            location.coordinate.latitude,
            location.coordinate.longitude
        )
    }

    func locationManager(_ manager: CLLocationManager,
                         didFailWithError error: Error) {
        if let clError = error as? CLError, clError.code == .denied {
            onPermissionDenied?()
        }
    }
}
