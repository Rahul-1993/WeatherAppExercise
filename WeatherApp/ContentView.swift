//
//  ContentView.swift
//  WeatherApp
//
//  Created by Rahul Avale on 9/17/24.
//

import SwiftUI

struct ContentView: View {
    @StateObject var coordinator = AppCoordinator() // Initialize the coordinator here

    var body: some View {
        coordinator.currentView // Displays the current view
    }
}


#Preview {
    ContentView()
}
