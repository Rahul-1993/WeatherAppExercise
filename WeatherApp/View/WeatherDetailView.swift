//
//  WeatherDetailView.swift
//  WeatherApp
//
//  Created by Rahul Avale on 9/17/24.
//

import SwiftUI

struct WeatherDetailView: View {
    @ObservedObject var viewModel: WeatherViewModel
    @ObservedObject var coordinator: AppCoordinator
    
    private let imageCache = ImageCache() // Image cache instance
    
    init(viewModel: WeatherViewModel, coordinator: AppCoordinator) {
        _viewModel = ObservedObject(wrappedValue: viewModel)
        _coordinator = ObservedObject(wrappedValue: coordinator)
    }
    
    var body: some View {
        VStack(alignment: .center, spacing: 20) {
            backButtonSection
            
            if let weather = viewModel.weather {
                weatherDetailsSection(weather: weather)
            } else if viewModel.errorMessage != nil {
                errorMessageSection
            } else {
                loadingIndicatorSection
            }
        }
        .padding()
        .background(Color(white: 0.95))
        .cornerRadius(12)
        .shadow(radius: 10)
        .padding()
    }
}

// MARK: - Extensions for View Sections
extension WeatherDetailView {
    // Button (Back button)
    private var backButtonSection: some View {
        Button(action: {
            coordinator.goToSearch() // Navigate back to SearchView
        }) {
            HStack {
                Text("Back to Weather Search")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(8)
                    .font(.headline)
            }
        }
        .padding(.top, 20)
    }
    
    // Details Section (Details)
    private func weatherDetailsSection(weather: Weather) -> some View {
        VStack(alignment: .center, spacing: 20) {
            Text(weather.name)
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding()
            
            // Fetch and display weather icon with caching
            if let icon = weather.weather.first?.icon {
                let iconUrl = "https://openweathermap.org/img/wn/\(icon)@2x.png"
                CachedImageView(imageUrl: iconUrl, cache: imageCache)
                    .frame(width: 120, height: 120)
                    .padding()
            }
            
            Text("Temperature: \(weather.main.temp, specifier: "%.1f")°C")
                .font(.title2)
            
            Text("Humidity: \(weather.main.humidity)%")
                .font(.title3)
            
            Text(weather.weather.first?.description.capitalized ?? "")
                .font(.body)
                .foregroundColor(.gray)
        }
        .padding()
        .background(Color.white)
        .cornerRadius(12)
        .shadow(radius: 10)
        .padding()
    }
    
    // Error Section (Error)
    private var errorMessageSection: some View {
        Text("Please go back to Weather Search and input a valid city name")
            .foregroundColor(.red)
            .font(.headline)
            .padding()
    }
    
    // Indicator Section (Indicator)
    private var loadingIndicatorSection: some View {
        ProgressView()
            .progressViewStyle(CircularProgressViewStyle())
            .scaleEffect(1.5, anchor: .center)
    }
}

#Preview {
    let mockViewModel = WeatherViewModel(city: "San Francisco")
//        let mockViewModel = WeatherViewModel(latitude: 35.6586, longitude: 139.7454)
    let mockCoordinator = AppCoordinator()
        
    return WeatherDetailView(viewModel: mockViewModel, coordinator: mockCoordinator)
}
