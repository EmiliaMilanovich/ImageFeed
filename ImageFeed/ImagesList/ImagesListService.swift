//
//  ImagesListService.swift
//  ImageFeed
//
//  Created by Эмилия on 24.09.2023.
//

import UIKit

final class ImagesListService {
    static let shared = ImagesListService()
    static let didChangeNotification = Notification.Name(rawValue: "ImagesListServiceDidChange")
    
    private var lastLoadedPage = 0
    private var task: URLSessionTask?
    private var likeTask: URLSessionTask?
    private (set) var photos: [Photo] = []
    
    private let urlSession = URLSession.shared
    private let token = OAuth2TokenStorage().token
    private let dateFormatter = ISO8601DateFormatter()

// загрузка очередной страницы с сервера
    func fetchPhotosNextPage() {
        assert(Thread.isMainThread)

        // определяем номер след стр для закачки
        let nextPage = lastLoadedPage + 1

        // если идет закачка, новый запрос не создается
        guard task == nil else { return }
        task?.cancel()

        guard let token = token else { return }
        var request = photosRequest(page: nextPage, perPage: 10)
        request?.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")

        guard let request = request else {
            assertionFailure("Не сформировался запрос")
            return }
        
        let task = urlSession.objectTask(for: request) { [weak self] (result: Result<[PhotoResult], Error>) in
            guard let self = self else {
                assertionFailure("Ошибка задачи")
                return
            }
            
            //при получении новых фото массив обновляется из главного потока
            DispatchQueue.main.async {
                switch result {
                case .success(let photoResults):
                    for photoResult in photoResults {
                        self.photos.append(self.convert(photoResult))
                    }
                self.lastLoadedPage = nextPage
                    
                //после обновления значения массива публикуется нотификация
                NotificationCenter.default
                    .post(
                        name: ImagesListService.didChangeNotification,
                        object: self,
                        userInfo: ["Photos": self.photos])
                    
                self.task = nil

                case .failure(let error):
                    print("Ошибка \(error), фото не добавлено в массив")
                }
            }
        }
        self.task = task
        task.resume()
    }
    
    func convert(_ photoResult: PhotoResult) -> Photo {
           Photo(
               id: photoResult.id,
               size: CGSize(width: photoResult.width, height: photoResult.height),
               createdAt: dateFormatter.date(from: photoResult.createdAt ?? ""),
               welcomeDescription: photoResult.description ?? "",
               thumbImageURL: photoResult.urls.thumb,
               largeImageURL: photoResult.urls.full,
               isLiked: photoResult.likedByUser
           )
       }
    
    func changeLike(photoId: String, isLike: Bool, _ completion: @escaping (Result<Bool, Error>) -> Void) {
        
        assert(Thread.isMainThread)
        guard likeTask == nil else { return }
        likeTask?.cancel()

        guard let token = token else { return }
        var requestLike: URLRequest? = isLike ? unlikeRequest(photoId: photoId) : likeRequest(photoId: photoId)
        requestLike?.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")

        guard let requestLike = requestLike else { return }
        let likeTask = urlSession.objectTask(for: requestLike) { [weak self] (result: Result<PhotoLikeResult, Error>) in
            DispatchQueue.main.async {
                guard let self = self else { return }
                switch result {
                case .success(let body):
                    let likedByUser = body.photo?.likedByUser ?? false
                    if let index = self.photos.firstIndex(where: { $0.id == photoId}) {
                        let photo = self.photos[index]
                        let newPhoto = Photo(
                            id: photo.id,
                            size: photo.size,
                            createdAt: photo.createdAt,
                            welcomeDescription: photo.welcomeDescription,
                            thumbImageURL: photo.thumbImageURL,
                            largeImageURL: photo.largeImageURL,
                            isLiked: likedByUser
                        )
                        self.photos[index] = newPhoto
                    }
                    completion(.success(likedByUser))
                    self.likeTask = nil
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        }
        self.likeTask = likeTask
        likeTask.resume()
        }
}

private extension ImagesListService {
    func photosRequest(page: Int, perPage: Int) -> URLRequest? {
        URLRequest.makeHTTPRequest(
            path: "/photos?"
            + "page=\(page)"
            + "&&per_page=\(perPage)",
            httpMethod: "GET"
        )
    }
    
    func likeRequest(photoId: String) -> URLRequest {
            URLRequest.makeHTTPRequest(
                path: "/photos/\(photoId)/like",
                httpMethod: "POST"
            )
        }
        
        func unlikeRequest(photoId: String) -> URLRequest {
            URLRequest.makeHTTPRequest(
                path: "/photos/\(photoId)/like",
                httpMethod: "DELETE"
            )
        }
}
