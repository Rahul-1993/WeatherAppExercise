//
//  LastCityManager.swift
//  WeatherApp
//
//  Created by Rahul Avale on 9/17/24.
//

import Foundation

class LastCityManager {
    private let key = "LastSearchedCity"
    
    func save(city: String) {
        UserDefaults.standard.set(city, forKey: key)
    }
    
    func load() -> String? {
        return UserDefaults.standard.string(forKey: key)
    }
}
