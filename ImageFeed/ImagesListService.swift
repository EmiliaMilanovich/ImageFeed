//
//  ImagesListService.swift
//  ImageFeed
//
//  Created by Эмилия on 24.09.2023.
//

import UIKit

final class ImagesListService {
    static let shared = ImagesListService()
    static let DidChangeNotification = Notification.Name(rawValue: "ImagesListServiceDidChange")
    private let token = OAuth2TokenStorage().token
    private let urlSession = URLSession.shared


    private (set) var photos: [Photo] = []
    private var lastLoadedPage: Int?
    private var task: URLSessionTask?
    private var nextPage = 1


    func fetchPhotosNextPage() {
        let nextPage = lastLoadedPage == nil ? 1 : lastLoadedPage! + 1

        assert(Thread.isMainThread)
        guard task == nil else { return }
        task?.cancel()

        guard let token = token else { return }
        var request = photosRequest(page: nextPage, perPage: 10)
        request?.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")

        guard let request = request else { return assertionFailure("Нет реквеста") }
        let task = urlSession.objectTask(for: request) { [weak self] (result: Result<[PhotoResult], Error>) in
            guard let self = self else { return assertionFailure("не селфится") }
            DispatchQueue.main.async {
                switch result {
                case .success(let body):
                    
                    body.forEach { photo in
                        self.photos.append(Photo(
                            id: photo.id,
                            size: CGSize(width: photo.width, height: photo.height),
                            createdAt: dateFormatter.date(from: photo.createdAt ?? ""),
                            welcomeDescription: photo.description,
                            thumbImageURL: photo.urls.thumb,
                            largeImageURL: photo.urls.full,
                            isLiked: photo.likedByUser
                        )
                        )
                    }
                    self.lastLoadedPage = self.nextPage
                    NotificationCenter.default
                        .post(
                            name: ImagesListService.DidChangeNotification,
                            object: self,
                            userInfo: ["Photos": self.photos]
                        )

                case .failure(let error):
                    print("WARNING loading photo \(error)")
                }
            }
        }
        self.task = task
        task.resume()
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
}
