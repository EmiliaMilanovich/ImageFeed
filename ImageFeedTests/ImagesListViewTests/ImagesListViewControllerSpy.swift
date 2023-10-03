//
//  ImagesListViewControllerSpy.swift
//  ImageFeedTests
//
//  Created by Эмилия on 03.10.2023.
//

import ImageFeed
import Foundation

final class ImagesListViewControllerSpy: ImagesListViewControllerProtocol {
    var presenter: ImagesListViewPresenterProtocol?
    var updateTableViewAnimatedCalled = false
    var likeErrorCalled = false
    
    func updateTableViewAnimated(oldCount: Int, newCount: Int) {
        updateTableViewAnimatedCalled = true
    }
    
    func likeError() {
        likeErrorCalled = true
    }
}
