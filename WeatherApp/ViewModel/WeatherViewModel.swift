//
//  WeatherViewModel.swift
//  WeatherApp
//
//  Created by Rahul Avale on 9/17/24.
//

import Foundation
import Combine

class WeatherViewModel: ObservableObject {
    @Published var weather: Weather?
    @Published var errorMessage: String?
    
    private var cancellables = Set<AnyCancellable>()
    private var weatherService: WeatherService
    private var city: String?
    private var latitude: Double?
    private var longitude: Double?

    // Refactored initializer to handle both city and coordinates
    init(weatherService: WeatherService = OpenWeatherService(), city: String? = nil, latitude: Double? = nil, longitude: Double? = nil) {
        self.weatherService = weatherService
        self.city = city
        self.latitude = latitude
        self.longitude = longitude
        fetchWeather()
    }
    
    // Refactored fetch logic to handle both city and coordinates
    private func fetchWeather() {
        if let city = city {
            handleWeatherPublisher(weatherService.fetchWeatherByCity(for: city))
        } else if let latitude = latitude, let longitude = longitude {
            handleWeatherPublisher(weatherService.fetchWeatherByCoordinates(latitude: latitude, longitude: longitude))
        } else {
            self.errorMessage = "Invalid parameters provided."
        }
    }
    
    // Reusable method to handle publishers
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



