//
//  ImagestListViewPresenterSpy.swift
//  ImageFeedTests
//
//  Created by Эмилия on 03.10.2023.
//

import ImageFeed
import Foundation

final class ImagesListViewPresenterSpy: ImagesListViewPresenterProtocol {
    var view: ImagesListViewControllerProtocol?
    var photos: [Photo] = []
    var viewDidLoadCalled = false
    var updateTableViewCalled = false
    var fetchPhotosCalled = false
    var likePhotoCalled = false

    func getLargeImageURL(indexPath: IndexPath) -> URL? {
        return nil
    }
    
    func updateTableView() {
        updateTableViewCalled = true
    }
    
    func viewDidLoad() {
        viewDidLoadCalled = true

    }
    
    func getPhotosCount() -> Int {
        return 0
    }
    
    func fetchPhotos(indexPath: IndexPath) {
        fetchPhotosCalled = true
    }
    
    func likePhoto(_ cell: ImagesListCell, _ indexPath: IndexPath) {
        likePhotoCalled = true
    }
    
    func getPhoto(indexPath: IndexPath) -> Photo? {
        return nil
    }
}
