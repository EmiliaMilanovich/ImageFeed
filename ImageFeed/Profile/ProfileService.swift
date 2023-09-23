//
//  ProfileService.swift
//  ImageFeed
//
//  Created by Эмилия on 05.09.2023.
//

import Foundation

final class ProfileService {
    static let shared = ProfileService()
    private let urlSession = URLSession.shared
    
    private var task: URLSessionTask?
    private (set) var profile: Profile?
    
    func fetchProfile(_ token: String, completion: @escaping (Result<Profile, Error>) -> Void) {
        assert(Thread.isMainThread)
        guard profile == nil else { return }
        task?.cancel()
        
        var request = makeFetchProfileRequest(token: token)
        request?.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        guard let request = request else { return }
        
        let task = urlSession.objectTask(for: request) { [weak self] (result: Result<ProfileResult, Error>) in
            guard let self = self else { return }
            DispatchQueue.main.async {
                switch result {
                case .success(let body):
                    let profile = Profile(
                        username: body.username,
                        name: "\(body.firstName ?? "") \(body.lastName ?? "")",
                        loginName: "@\(body.username)",
                        bio: body.bio ?? "")
                    self.profile = profile
                    completion(.success(profile))
                case .failure(let error):
                    completion(.failure(error))
                }
                self.task = nil
            }
        }
        self.task = task
        task.resume()
    }
    
    private func makeFetchProfileRequest(token: String) -> URLRequest? {
        URLRequest.makeHTTPRequest(path: "/me", httpMethod: "GET")
    }
}
