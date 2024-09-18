//
//  WeatherDetailView.swift
//  WeatherApp
//
//  Created by Rahul Avale on 9/17/24.
//

import SwiftUI

struct WeatherDetailView: View {
    @ObservedObject var viewModel: WeatherViewModel
    var coordinator: AppCoordinator // Coordinator reference to manage navigation
    
    private let imageCache = ImageCache() // Image cache instance
    
    @State private var weatherIcon: UIImage? = nil
    @State private var isLoading = false
    
    var body: some View {
        VStack {
            // Back Button
            Button(action: {
                coordinator.goToSearch() // Navigate back to SearchView
            }) {
                HStack {
                    Image(systemName: "chevron.left")
                    Text("Back")
                }
                .padding()
                .foregroundColor(.blue)
            }
            
            // Weather Details
            if let weather = viewModel.weather {
                VStack {
                    Text(weather.name)
                        .font(.largeTitle)
                        .padding()
                    
                    // Fetch and display weather icon with caching
                    if let icon = weather.weather.first?.icon {
                        let iconUrl = "https://openweathermap.org/img/wn/\(icon)@2x.png"
                        CachedImageView(imageUrl: iconUrl, cache: imageCache) // Use the custom image view with cache
                            .frame(width: 100, height: 100)
                            .padding()
                    }
                    
                    Text("Temperature: \(weather.main.temp, specifier: "%.1f")°C")
                    Text("Humidity: \(weather.main.humidity)%")
                    Text(weather.weather.first?.description.capitalized ?? "")
                }
            } else if let error = viewModel.errorMessage {
                Text("Error: \(error)")
                    .foregroundColor(.red)
            } else {
                ProgressView()
            }
        }
        .padding()
    }
}


struct WeatherDetailView_Previews: PreviewProvider {
    static var previews: some View {
        // Provide a valid city name when creating WeatherViewModel
        let mockViewModel = WeatherViewModel(city: "San Francisco")
        let mockCoordinator = AppCoordinator() // Create a dummy coordinator
        
        return WeatherDetailView(viewModel: mockViewModel, coordinator: mockCoordinator)
    }
}

