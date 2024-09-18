//
//  CachedImageView.swift
//  WeatherApp
//
//  Created by Rahul Avale on 9/18/24.
//

import SwiftUI

struct CachedImageView: View {
    @State private var image: UIImage? = nil
    @State private var isLoading: Bool = false
    
    let imageUrl: String
    let cache: ImageCache
    
    var body: some View {
        if let uiImage = image {
            Image(uiImage: uiImage)
                .resizable()
                .aspectRatio(contentMode: .fit)
        } else if isLoading {
            ProgressView()
        } else {
            Color.gray
                .onAppear {
                    loadImage()
                }
        }
    }
    
    // Load image either from cache or download it
    private func loadImage() {
        // Check cache first
        if let cachedImage = cache.getImage(forKey: imageUrl) {
            image = cachedImage
            return
        }
        
        // Download the image if not in cache
        guard let url = URL(string: imageUrl) else { return }
        
        isLoading = true
        URLSession.shared.dataTask(with: url) { data, response, error in
            isLoading = false
            if let data = data, let downloadedImage = UIImage(data: data) {
                DispatchQueue.main.async {
                    // Cache the downloaded image
                    cache.setImage(downloadedImage, forKey: imageUrl)
                    image = downloadedImage
                }
            }
        }.resume()
    }
}

#Preview {
    let mockCache = ImageCache()
    let sampleImageUrl = "https://openweathermap.org/img/wn/04n@2x.png"
    
    CachedImageView(imageUrl: sampleImageUrl, cache: mockCache)
        .previewLayout(.sizeThatFits)
        .padding()
}
