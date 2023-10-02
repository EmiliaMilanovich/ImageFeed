//
//  Photo.swift
//  ImageFeed
//
//  Created by Эмилия on 24.09.2023.
//

import UIKit

struct Photo {
    let id: String
    let size: CGSize
    let createdAt: Date?
    let welcomeDescription: String?
    let thumbImageURL: String
    let largeImageURL: String
    let isLiked: Bool
}
