//
//  WeatherError.swift
//  WeatherApp
//
//  Created by Rahul Avale on 10/6/24.
//

import Foundation

enum WeatherError: LocalizedError {
    case invalidCity
    case invalidURL
    case networkError(URLError)
    case decodingError(DecodingError)
    case unknownError
    
    var errorDescription: String? {
        switch self {
        case .invalidCity:
            return "Please enter a valid city name."
        case .invalidURL:
            return "The URL provided is invalid."
        case .networkError(let urlError):
            return "Network error: \(urlError.localizedDescription)."
        case .decodingError:
            return "Failed to decode data."
        case .unknownError:
            return "An unknown error occurred."
        }
    }
}
