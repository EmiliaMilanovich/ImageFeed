//
//  ImagesListViewPresenter.swift
//  ImageFeed
//
//  Created by Эмилия on 03.10.2023.
//

import Foundation

//MARK: - ImagesListViewPresenterProtocol
public protocol ImagesListViewPresenterProtocol {
    var view: ImagesListViewControllerProtocol? { get set }
    func getLargeImageURL(indexPath: IndexPath) -> URL?
    func updateTableView()
    func viewDidLoad()
    func getPhotosCount() -> Int
    func fetchPhotos(indexPath: IndexPath)
    func likePhoto(_ cell: ImagesListCell,_ indexPath: IndexPath)
    func getPhoto(indexPath: IndexPath) -> Photo?
}

//MARK: - ImagesListViewPresenter
final class ImagesListViewPresenter: ImagesListViewPresenterProtocol {
    
    //MARK: - Properties
    weak var view: ImagesListViewControllerProtocol?
    
    //MARK: - Private properties
    private var photos: [Photo] = []
    private let imagesListService = ImagesListService.shared
    private var imageListObserver: NSObjectProtocol?
    
    //MARK: - Lifecycle
    func viewDidLoad() {
        imagesListService.fetchPhotosNextPage()
        notificationImagesList()
    }
    
    //MARK: - Methods
    func getLargeImageURL(indexPath: IndexPath) -> URL? {
        return URL(string: photos[indexPath.row].largeImageURL)
    }
    
    func getPhotosCount() -> Int {
        return photos.count
    }
    
    func getPhoto(indexPath: IndexPath) -> Photo? {
        return imagesListService.photos[indexPath.row]
    }
    
    func fetchPhotos(indexPath: IndexPath) {
        if indexPath.row + 1 == imagesListService.photos.count {
            imagesListService.fetchPhotosNextPage()
        }
    }
    
    func updateTableView() {
        let oldCount = photos.count
        let newCount = imagesListService.photos.count
        photos = imagesListService.photos
        if oldCount != newCount {
            view?.updateTableViewAnimated(oldCount: oldCount, newCount: newCount)
        }
    }
    
    func notificationImagesList() {
        imageListObserver = NotificationCenter.default
            .addObserver(forName: ImagesListService.didChangeNotification,
                         object: imagesListService,
                         queue: .main) {  _ in
                self.updateTableView()
            }
    }
    
    func likePhoto(_ cell: ImagesListCell,_ indexPath: IndexPath) {
        let photo = photos[indexPath.row]
        UIBlockingProgressHUD.show()
        imagesListService.changeLike(
            photoId: photo.id,
            isLike: photo.isLiked) { [weak self] result in
                guard let self = self else { return }
                switch result {
                case .success:
                    self.photos = self.imagesListService.photos
                    cell.setIsLiked(isLiked: self.photos[indexPath.row].isLiked)
                    UIBlockingProgressHUD.dismiss()
                case .failure:
                    UIBlockingProgressHUD.dismiss()
                    self.view?.likeError()
                }
            }
    }
}
