//
//  LocationManager.swift
//  WeatherApp
//
//  Created by Rahul Avale on 9/17/24.
//

import Foundation
import CoreLocation

class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    private let locationManager = CLLocationManager()
    
    @Published var location: CLLocation? = nil
    @Published var locationError: String? = nil
    
    override init() {
        super.init()
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
    }
    
    func requestLocation() {
        locationManager.requestLocation()
    }
    
    // Delegate method called when authorization status changes
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        // Check authorization status when it changes
        checkLocationAuthorization()
    }

    // Check location authorization status
    private func checkLocationAuthorization() {
        switch locationManager.authorizationStatus {
        case .notDetermined:
            // Request authorization; no need to handle UI directly here
            break
        case .restricted, .denied:
            DispatchQueue.main.async {
                self.locationError = "Location access is restricted or denied."
            }
        case .authorizedWhenInUse, .authorizedAlways:
            // Only request location when authorized
            requestLocation()
        @unknown default:
            DispatchQueue.main.async {
                self.locationError = "Unknown authorization status."
            }
        }
    }
    
    // Delegate method called when location updates are received
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else {
            return
        }
        DispatchQueue.main.async {
            self.location = location
        }
    }
    
    // Delegate method called when location request fails
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        DispatchQueue.main.async {
            self.locationError = error.localizedDescription
        }
    }
}
