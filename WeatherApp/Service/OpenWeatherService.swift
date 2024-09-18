//
//  OpenWeatherService.swift
//  WeatherApp
//
//  Created by Rahul Avale on 9/17/24.
//

import Foundation
import Combine

protocol WeatherService {
    func fetchWeatherByCity(for city: String) -> AnyPublisher<Weather, Error>
    func fetchWeatherByCoordinates(latitude: Double, longitude: Double) -> AnyPublisher<Weather, Error>
}

class OpenWeatherService: WeatherService {
    private let apiKey = "d13f9c37068dc04df45dc55c2d5e17ff"
    private let units = "metric"
    
    // Generic function to fetch weather data
        private func fetchWeather(from urlString: String) -> AnyPublisher<Weather, Error> {
            guard let url = URL(string: urlString) else {
                return Fail(error: URLError(.badURL)).eraseToAnyPublisher()
            }
            
            return URLSession.shared.dataTaskPublisher(for: url)
                .map(\.data)
                .decode(type: Weather.self, decoder: JSONDecoder())
                .receive(on: DispatchQueue.main)
                .eraseToAnyPublisher()
        }
        
        // Fetch weather by city
        func fetchWeatherByCity(for city: String) -> AnyPublisher<Weather, Error> {
            let urlString = "https://api.openweathermap.org/data/2.5/weather?q=\(city)&appid=\(apiKey)&units=\(units)"
            return fetchWeather(from: urlString)
        }
        
        // Fetch weather by coordinates
        func fetchWeatherByCoordinates(latitude: Double, longitude: Double) -> AnyPublisher<Weather, Error> {
            let urlString = "https://api.openweathermap.org/data/2.5/weather?lat=\(latitude)&lon=\(longitude)&appid=\(apiKey)&units=\(units)"
            return fetchWeather(from: urlString)
        }
}

