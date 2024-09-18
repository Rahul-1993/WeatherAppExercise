//
//  SearchView.swift
//  WeatherApp
//
//  Created by Rahul Avale on 9/17/24.
//

import SwiftUI

struct SearchView: View {
    @ObservedObject var coordinator: AppCoordinator
    @StateObject private var locationManager = LocationManager() // Location Manager
    @State private var city: String = ""

    private let lastCityManager = LastCityManager() // Instance of LastCityManager

    init(coordinator: AppCoordinator) {
        _coordinator = ObservedObject(wrappedValue: coordinator)
        // Load the last city name using LastCityManager
        _city = State(initialValue: LastCityManager().load() ?? "")
    }

    var body: some View {
        VStack {
            TextField("Enter city", text: $city)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()

            Button(action: {
                // Save the city name using LastCityManager
                lastCityManager.save(city: city)
                coordinator.goToWeatherDetail(city: city)
            }) {
                Text("Search")
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(8)
            }
            .padding()

            // Button to fetch location and display weather for current location
            Button(action: {
                locationManager.requestLocation()
            }) {
                Text("Use Current Location")
                    .padding()
                    .background(Color.green)
                    .foregroundColor(.white)
                    .cornerRadius(8)
            }
            .padding()

            if let location = locationManager.location {
                // When location is available, navigate to WeatherDetailView with coordinates
                Button(action: {
                    coordinator.goToWeatherDetailByCoordinates(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
                }) {
                    Text("Show Weather for Current Location")
                        .padding()
                        .background(Color.orange)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
                .padding()
            } else if let locationError = locationManager.locationError {
                Text("Error: \(locationError)")
                    .foregroundColor(.red)
                    .padding()
            }
        }
        .padding()
    }
}


struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        SearchView(coordinator: AppCoordinator()) // Use valid AppCoordinator
    }
}

