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
    
    @State private var isLoading = false
    
    var body: some View {
        VStack(alignment: .center, spacing: 20) {
            // Back Button
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
            
            // Weather Details
            if let weather = viewModel.weather {
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
            } else if let error = viewModel.errorMessage {
                Text("Error: \(error)")
                    .foregroundColor(.red)
                    .font(.headline)
                    .padding()
            } else {
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle())
                    .scaleEffect(1.5, anchor: .center)
            }
        }
        .padding()
        .background(Color(white: 0.95))
        .cornerRadius(12)
        .shadow(radius: 10)
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

