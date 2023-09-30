//
//  PhotoResult.swift
//  ImageFeed
//
//  Created by Эмилия on 24.09.2023.
//

import Foundation

struct PhotoResult: Codable {
    let id: String
    let createdAt: String?
    let width: Int
    let height: Int
    let description: String?
    let likedByUser: Bool
    let urls: UrlsResult
    
    enum CodingKeys: String, CodingKey {
            case id
            case createdAt = "created_at"
            case width
            case height
            case description
            case likedByUser = "liked_by_user"
            case urls
        }
}

struct UrlsResult: Codable {
    let full: String
    let thumb: String
}

struct PhotoLikeResult: Codable {
    let photo: PhotoResult?
}
