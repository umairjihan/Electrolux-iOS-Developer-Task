//
//  Photos.swift
//  Electrolux iOS Developer Task
//
//  Created by Abu Umair Jihan on 2022-04-04.
//

import Foundation

// MARK: - FlickrPhotos
struct FlickrPhotos: Response {
    let photos: Photos
    let stat: String
}

// MARK: - Photos
struct Photos: Codable {
    let page, pages, perpage, total: Int
    let photo: [Photo]
}

// MARK: - Photo
struct Photo: Codable {
    let id, owner, secret, server: String
    let farm: Int
    let title: String
    let ispublic, isfriend, isfamily: Int
}
