//
//  AppCoordinator.swift
//  WeatherApp
//
//  Created by Rahul Avale on 9/17/24.
//

import SwiftUI

class AppCoordinator: ObservableObject {
    @Published var currentView: AnyView
    
    init() {
        // Initialize `currentView` with a placeholder
        self.currentView = AnyView(EmptyView())
        
        // After initialization, set up the initial view
        setupInitialView()
    }
    
    private func setupInitialView() {
        // Now that all properties are initialized, safely use `self`
        self.currentView = AnyView(SearchView(coordinator: self, weatherService: OpenWeatherService()))
    }
    
    func goToSearch() {
        // Update `currentView` to `SearchView`
        self.currentView = AnyView(SearchView(coordinator: self, weatherService: OpenWeatherService()))
    }
    
    func goToWeatherDetail(city: String, weatherService: WeatherService) {
        // Create a `WeatherViewModel` instance
        let weatherViewModel = WeatherViewModel(city: city)
        
        // Update `currentView` to `WeatherDetailView` and pass self as the coordinator
        self.currentView = AnyView(WeatherDetailView(viewModel: weatherViewModel, coordinator: self))
    }

    func goToWeatherDetailByCoordinates(latitude: Double, longitude: Double) {
        let weatherViewModel = WeatherViewModel(latitude: latitude, longitude: longitude)
        
        // Update `currentView` to `WeatherDetailView` and pass self as the coordinator
        self.currentView = AnyView(WeatherDetailView(viewModel: weatherViewModel, coordinator: self))
    }

}



