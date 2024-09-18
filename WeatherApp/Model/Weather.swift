//
//  Weather.swift
//  WeatherApp
//
//  Created by Rahul Avale on 9/17/24.
//

import Foundation

struct Weather: Codable {
    let name: String
    let main: Main
    let weather: [WeatherCondition]
}

struct Main: Codable {
    let temp: Double
    let humidity: Int
}

struct WeatherCondition: Codable {
    let icon: String
    let description: String
}

