//
//  ImageListCellDelegate.swift
//  ImageFeed
//
//  Created by Эмилия on 25.09.2023.
//

import Foundation

protocol ImageListCellDelegate: AnyObject {
    func imageListCellDidTapLike(_ cell: ImagesListCell)
}
