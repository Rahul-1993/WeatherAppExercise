//
//  OpenWeatherService.swift
//  WeatherApp
//
//  Created by Rahul Avale on 9/17/24.
//

import Foundation
import Combine

// MARK: - Protocol Declaration

/// Protocol that defines the contract for weather services.
/// This allows for dependency injection and easier testing by conforming to different implementations.
protocol WeatherService {
    func fetchWeatherByCity(for city: String) -> AnyPublisher<Weather, Error>
    func fetchWeatherByCoordinates(latitude: Double, longitude: Double) -> AnyPublisher<Weather, Error>
}

// MARK: - OpenWeatherService Implementation

/// Service responsible for fetching weather data from the OpenWeatherMap API.
class OpenWeatherService: WeatherService {
    
    // MARK: - Fetch Weather Data (Generic)
    
    /// Generic method for fetching weather data from a given URL.
    /// - Parameter urlString: The URL string used to make the network request.
    /// - Returns: A publisher that emits either `Weather` data or an `Error`.
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
        
    // MARK: - Fetch Weather by City
    
    /// Fetch weather data for a specific city.
    /// - Parameter city: The name of the city for which weather data is requested.
    /// - Returns: A publisher that emits either `Weather` data or an `Error`.
        func fetchWeatherByCity(for city: String) -> AnyPublisher<Weather, Error> {
            let urlString = "\(baseUrl)\(version)\(endPoint)?q=\(city)&appid=\(apiKey)&units=\(units)"
            return fetchWeather(from: urlString)
        }
        
    // MARK: - Fetch Weather by Coordinates
    
    /// Fetch weather data for specific geographic coordinates.
    /// - Parameters:
    ///   - latitude: The latitude of the desired location.
    ///   - longitude: The longitude of the desired location.
    /// - Returns: A publisher that emits either `Weather` data or an `Error`.
        func fetchWeatherByCoordinates(latitude: Double, longitude: Double) -> AnyPublisher<Weather, Error> {
            let urlString = "https://api.openweathermap.org/data/2.5/weather?lat=\(latitude)&lon=\(longitude)&appid=\(apiKey)&units=\(units)"
            return fetchWeather(from: urlString)
        }
    
    // MARK: - Potential Optimizations
       
       /*
       1. **API Rate Limiting**:
          OpenWeatherMap has rate limits. Implement a retry mechanism using `retry` from Combine to handle transient network errors or rate limits.
       
       2. **Caching Layer**:
          Introduce a caching mechanism for frequently fetched cities/locations to reduce API calls. This could be handled using persistent storage like CoreData or UserDefaults for local caching.
       
       3. **Improved Error Handling**:
          Consider more granular error handling, mapping specific errors (e.g., network timeouts, invalid API key, or city not found) to user-friendly messages.
       
       4. **Networking Layer Abstraction**:
          Instead of directly using `URLSession`, you could abstract the networking layer to allow switching between different networking frameworks (e.g., Alamofire) without affecting the service logic.
        
       5. **API Key and URL string storage**:
          Instead of hardcoding the API key, store the key in keychains or Environment Variables. Also the URL string should be stored in parts in possible a constant file and concatinate individual elements to a complete url string.
        */
}

