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
    private let weatherService: WeatherService

    init(coordinator: AppCoordinator, weatherService: WeatherService) {
        _coordinator = ObservedObject(wrappedValue: coordinator)
        self.weatherService = weatherService
        // Load the last city name using LastCityManager
        _city = State(initialValue: LastCityManager().load() ?? "")
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            headerSection
            descriptionSection
            cityInputSection
            searchButtonSection
            currentLocationSection
            locationErrorSection
        }
        .padding()
        .background(Color(white: 0.95))
        .cornerRadius(12)
        .shadow(radius: 10)
        .padding()
    }
}

// MARK: - Extensions for View Sections
extension SearchView {
    // Header Section (Title)
    private var headerSection: some View {
        Text("Weather Search")
            .font(.largeTitle)
            .fontWeight(.bold)
            .padding(.top)
    }

    // Description Section (Subtitle text)
    private var descriptionSection: some View {
        Text("Enter the name of the city to get the weather forecast or click on the button below in Yellow to show weather for your current location.")
            .font(.subheadline)
            .foregroundColor(.gray)
            .padding(.bottom, 10)
    }

    // City Input Section (TextField)
    private var cityInputSection: some View {
        TextField("Enter city", text: $city)
            .textFieldStyle(RoundedBorderTextFieldStyle())
            .padding()
    }

    // Search Button Section
    private var searchButtonSection: some View {
        Button(action: {
            // Save the city name using LastCityManager
            lastCityManager.save(city: city)
            coordinator.goToWeatherDetail(city: city, weatherService: weatherService)
        }) {
            Text("Search")
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(8)
                .font(.headline)
        }
        .padding(.bottom, 10)
    }

    // Current Location Button Section
    private var currentLocationSection: some View {
        if let location = locationManager.location {
            return AnyView(
                Button(action: {
                    coordinator.goToWeatherDetailByCoordinates(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
                }) {
                    Text("Show Weather for Current Location")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.orange)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                        .font(.headline)
                }
                .padding(.bottom, 10)
            )
        }
        return AnyView(EmptyView())
    }

    // Location Error Section
    private var locationErrorSection: some View {
        if let locationError = locationManager.locationError {
            return AnyView(
                Text("\(locationError) Please Enable Location Sharing from the Settings app")
                    .foregroundColor(.red)
                    .padding()
            )
        }
        return AnyView(EmptyView())
    }
}


#Preview {
    SearchView(coordinator: AppCoordinator(), weatherService: OpenWeatherService())
}

