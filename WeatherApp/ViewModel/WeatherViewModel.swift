//
//  WeatherViewModel.swift
//  WeatherApp
//
//  Created by Rahul Avale on 9/17/24.
//

import Foundation
import Combine

class WeatherViewModel: ObservableObject {
    // MARK: - Published Properties
    @Published var weather: Weather?
    @Published var errorMessage: String?
    
    // MARK: - Private Properties
    private var cancellables = Set<AnyCancellable>()
    private var weatherService: WeatherService
    private var city: String?
    private var latitude: Double?
    private var longitude: Double?

    // MARK: - Initializer
    /// Initializer for the `WeatherViewModel`.
    /// - Parameters:
    ///   - weatherService: A service implementing `WeatherService` to fetch weather data. Defaults to `OpenWeatherService`.
    ///   - city: Optional city name for weather search.
    ///   - latitude: Optional latitude for weather search by coordinates.
    ///   - longitude: Optional longitude for weather search by coordinates.
    init(weatherService: WeatherService = OpenWeatherService(), city: String? = nil, latitude: Double? = nil, longitude: Double? = nil) {
        self.weatherService = weatherService
        self.city = city
        self.latitude = latitude
        self.longitude = longitude
        fetchWeather()
    }
    
    // MARK: - Weather Fetching Logic
    /// Determines the appropriate method to fetch the weather based on provided inputs (city or coordinates).
    private func fetchWeather() {
        if let city = city {
            handleWeatherPublisher(weatherService.fetchWeatherByCity(for: city))
        } else if let latitude = latitude, let longitude = longitude {
            handleWeatherPublisher(weatherService.fetchWeatherByCoordinates(latitude: latitude, longitude: longitude))
        } else {
            self.errorMessage = "Invalid parameters provided."
        }
    }
    
    // MARK: - Publisher Handling
       /// Generic method to handle a weather publisher, decoupling the publisher from the UI logic.
       /// - Parameter publisher: A publisher of weather data that emits values or errors.
    private func handleWeatherPublisher(_ publisher: AnyPublisher<Weather, Error>) {
        publisher
            .sink(receiveCompletion: { completion in
                if case .failure(let error) = completion {
                    self.errorMessage = error.localizedDescription
                }
            }, receiveValue: { weather in
                self.weather = weather
            })
            .store(in: &cancellables)
    }
}



