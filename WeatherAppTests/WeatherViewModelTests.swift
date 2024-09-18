//
//  WeatherViewModelTests.swift
//  WeatherAppTests
//
//  Created by Rahul Avale on 9/18/24.
//

import XCTest
import Combine
@testable import WeatherApp

// Mock WeatherService for testing
class MockWeatherService: WeatherService {
    var weatherResult: Result<Weather, Error>?
    var fetchWeatherByCityCalled = false
    var fetchWeatherByCoordinatesCalled = false

    func fetchWeatherByCity(for city: String) -> AnyPublisher<Weather, Error> {
        fetchWeatherByCityCalled = true
        return createPublisher(for: weatherResult)
    }

    func fetchWeatherByCoordinates(latitude: Double, longitude: Double) -> AnyPublisher<Weather, Error> {
        fetchWeatherByCoordinatesCalled = true
        return createPublisher(for: weatherResult)
    }

    private func createPublisher(for result: Result<Weather, Error>?) -> AnyPublisher<Weather, Error> {
        if let result = result {
            return result.publisher.eraseToAnyPublisher()
        } else {
            return Fail(error: NSError(domain: "", code: -1, userInfo: nil)).eraseToAnyPublisher()
        }
    }
}

class WeatherViewModelTests: XCTestCase {
    var viewModel: WeatherViewModel!
    var mockWeatherService: MockWeatherService!
    var cancellables: Set<AnyCancellable>!

    override func setUp() {
        super.setUp()
        mockWeatherService = MockWeatherService()
        cancellables = Set<AnyCancellable>()
    }

    override func tearDown() {
        viewModel = nil
        mockWeatherService = nil
        cancellables = nil
        super.tearDown()
    }

    func testFetchWeatherByCitySuccess() {
        let weatherCondition = WeatherCondition(icon: "01d", description: "Clear sky")
        let main = Main(temp: 25.0, humidity: 60)
        let expectedWeather = Weather(name: "Atlanta", main: main, weather: [weatherCondition])

        // Set up the mock service to return the expected weather
        mockWeatherService.weatherResult = .success(expectedWeather)
        viewModel = WeatherViewModel(weatherService: mockWeatherService, city: "Atlanta")

        // Act
        let expectation = self.expectation(description: "Weather fetched")
        viewModel.$weather
            .sink { weather in
                if weather != nil {
                    expectation.fulfill()
                }
            }
            .store(in: &cancellables)

        // Assert
        waitForExpectations(timeout: 1.0, handler: nil)
        XCTAssertTrue(mockWeatherService.fetchWeatherByCityCalled)
        XCTAssertEqual(viewModel.weather?.name, expectedWeather.name)
        XCTAssertEqual(viewModel.weather?.main.temp, expectedWeather.main.temp)
        XCTAssertEqual(viewModel.weather?.main.humidity, expectedWeather.main.humidity)
        XCTAssertEqual(viewModel.weather?.weather.first?.icon, expectedWeather.weather.first?.icon)
        XCTAssertEqual(viewModel.weather?.weather.first?.description, expectedWeather.weather.first?.description)
        XCTAssertNil(viewModel.errorMessage)
    }


    func testFetchWeatherByCityFailure() {
        let expectedError = NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Failed to fetch weather"])
        mockWeatherService.weatherResult = .failure(expectedError)
        viewModel = WeatherViewModel(weatherService: mockWeatherService, city: "Atlanta")

        // Act
        let expectation = self.expectation(description: "Error message received")
        viewModel.$errorMessage
            .sink { errorMessage in
                if errorMessage != nil {
                    expectation.fulfill()
                }
            }
            .store(in: &cancellables)

        // Assert
        waitForExpectations(timeout: 1.0, handler: nil)
        XCTAssertTrue(mockWeatherService.fetchWeatherByCityCalled)
        XCTAssertNil(viewModel.weather)
        XCTAssertEqual(viewModel.errorMessage, "Failed to fetch weather")
    }
    
    // Add similar tests for fetchWeatherByCoordinates as needed
}

