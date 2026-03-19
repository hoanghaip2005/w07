//
//  PhotoService.swift
//  w07-2302700162
//
//  Created by umtlab03im11 on 19/3/26.
//

import Foundation

class PhotoService {
    
    // Pixabay API Key - Đăng ký miễn phí tại https://pixabay.com/api/docs/
    static let apiKey = "46841801-55f52ed498b37a73e413b2e25"
    static let baseURL = "https://pixabay.com/api/"
    
    // Fetch photos (general or search)
    static func fetchPhotos(page: Int, query: String? = nil, completion: @escaping ([Photo]?, Error?) -> Void) {
        var urlString = "\(baseURL)?key=\(apiKey)&page=\(page)&image_type=photo&per_page=20"
        
        if let query = query, !query.isEmpty {
            let encodedQuery = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? query
            urlString += "&q=\(encodedQuery)"
        }
        
        guard let url = URL(string: urlString) else {
            completion(nil, NSError(domain: "Invalid URL", code: -1))
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(nil, error)
                return
            }
            
            guard let data = data else {
                completion(nil, NSError(domain: "No data", code: -2))
                return
            }
            
            do {
                let response = try JSONDecoder().decode(PixabayResponse.self, from: data)
                let photos = response.hits.map { Photo(from: $0) }
                completion(photos, nil)
            } catch {
                completion(nil, error)
            }
        }.resume()
    }
}
