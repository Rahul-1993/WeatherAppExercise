//
//  ImageCache.swift
//  WeatherApp
//
//  Created by Rahul Avale on 9/17/24.
//

import Foundation
import UIKit

class ImageCache {
    private var cache: NSCache<NSString, UIImage> = NSCache()
    
    func getImage(forKey key: String) -> UIImage? {
        return cache.object(forKey: key as NSString)
    }
    
    func setImage(_ image: UIImage, forKey key: String) {
        cache.setObject(image, forKey: key as NSString)
    }
}
