//
//  Photo.swift
//  w07-2302700162
//
//  Created by umtlab03im11 on 19/3/26.
//

import Foundation

// MARK: - Pixabay API Response
struct PixabayResponse: Codable {
    let total: Int
    let totalHits: Int
    let hits: [PixabayPhoto]
}

struct PixabayPhoto: Codable {
    let id: Int
    let pageURL: String
    let type: String
    let tags: String
    let previewURL: String
    let previewWidth: Int
    let previewHeight: Int
    let webformatURL: String
    let webformatWidth: Int
    let webformatHeight: Int
    let largeImageURL: String
    let imageWidth: Int
    let imageHeight: Int
    let user: String
    let userImageURL: String
}

// MARK: - Photo model used in app
struct Photo {
    let id: Int
    let previewURL: String
    let largeImageURL: String
    let webformatURL: String
    let user: String
    let tags: String
    let imageWidth: Int
    let imageHeight: Int
    
    init(from pixabayPhoto: PixabayPhoto) {
        self.id = pixabayPhoto.id
        self.previewURL = pixabayPhoto.previewURL
        self.largeImageURL = pixabayPhoto.largeImageURL
        self.webformatURL = pixabayPhoto.webformatURL
        self.user = pixabayPhoto.user
        self.tags = pixabayPhoto.tags
        self.imageWidth = pixabayPhoto.webformatWidth
        self.imageHeight = pixabayPhoto.webformatHeight
    }
}
