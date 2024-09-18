WeatherApp

A simple weather forecasting app built using SwiftUI, following the MVVM-C (Model-View-ViewModel-Coordinator) architecture pattern. The app fetches weather data from the OpenWeatherMap API and displays it in a user-friendly interface. Users can search for weather details by city or fetch weather information using their current location.

Features

Search weather by city: Users can input the name of a city to retrieve weather details.
Use current location: Fetch weather information for the current location using device GPS.
Weather details: Shows temperature, humidity, and a weather condition icon with descriptions.
Image caching: Weather condition icons are cached to improve performance.
Persistent search history: The last searched city is saved and auto-loaded when the app is reopened.
Error handling: Handles network errors and invalid inputs gracefully.

Architecture

This app follows the MVVM-C (Model-View-ViewModel-Coordinator) architecture pattern, ensuring a clean separation of concerns, scalability, and maintainability.

Usage

Search for a city: Enter the name of a city and press the "Search" button to retrieve weather details.
Use current location: Tap "Use Current Location" to fetch weather data for your current GPS location.
View weather details: After performing a search, you can view the weather details, including temperature, humidity, and a weather condition icon.

Dependencies

Combine: Used for reactive programming and handling asynchronous network calls.
SwiftUI: Provides the UI framework for building declarative user interfaces.
CoreLocation: Handles location fetching when the user opts to retrieve weather data based on their current location.
OpenWeatherMap API: The external service used to fetch weather data.

API Setup
To use the OpenWeatherMap API:

Sign up at OpenWeatherMap to get your free API key.
In the project, create a file or set a constant where you store the API key for network requests.
