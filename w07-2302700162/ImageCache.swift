//
//  ImageCache.swift
//  w07-2302700162
//
//  Created by umtlab03im11 on 19/3/26.
//

import UIKit

class ImageCache {
    static let shared = ImageCache()
    private let cache = NSCache<NSString, UIImage>()
    
    private init() {}
    
    func getImage(for url: String) -> UIImage? {
        return cache.object(forKey: url as NSString)
    }
    
    func setImage(_ image: UIImage, for url: String) {
        cache.setObject(image, forKey: url as NSString)
    }
}

// MARK: - UIImageView Extension for async image loading
extension UIImageView {
    func loadImage(from urlString: String, placeholder: UIImage? = nil) {
        self.image = placeholder
        
        // Check cache first
        if let cachedImage = ImageCache.shared.getImage(for: urlString) {
            self.image = cachedImage
            return
        }
        
        guard let url = URL(string: urlString) else { return }
        
        URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            guard let self = self,
                  let data = data,
                  error == nil,
                  let image = UIImage(data: data) else { return }
            
            // Save to cache
            ImageCache.shared.setImage(image, for: urlString)
            
            DispatchQueue.main.async {
                self.image = image
            }
        }.resume()
    }
}
