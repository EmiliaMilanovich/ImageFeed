//
//  ProfilePresenter.swift
//  ImageFeed
//
//  Created by Эмилия on 02.10.2023.
//

import Foundation
import UIKit
import Kingfisher

//MARK: - Protocol
public protocol ProfileViewPresenterProtocol {
    var view: ProfileViewControllerProtocol? { get set }
    func viewDidLoad()
    func exitProfile()
    func getAvatar() -> URL?
}

final class ProfileViewPresenter: ProfileViewPresenterProtocol {
    //MARK: - Properties
    var view: ProfileViewControllerProtocol?
    
    //MARK: - Private properties
    private let profileService = ProfileService.shared
    private let profileImageService = ProfileImageService.shared
    private var profileImageServiceObserver: NSObjectProtocol?
    
    // MARK: - Lifecycle
    func viewDidLoad() {
        notificationProfileImage()
        view?.updateProfileDetails(profile: profileService.profile)
    }
    
    //MARK: - Methods
    func getAvatar() -> URL? {
        guard
            let profileImageURL = ProfileImageService.shared.avatarURL,
            let imageURL = URL(string: profileImageURL)
        else { return nil }
        return imageURL
    }
    
    func notificationProfileImage() {
        profileImageServiceObserver = NotificationCenter.default
            .addObserver(
                forName: ProfileImageService.didChangeNotification,
                object: nil,
                queue: .main
            ) { [weak self] _ in
                guard let self = self else { return }
                self.getAvatar()
            }
    }
    
    func exitProfile() {
        OAuth2TokenStorage().token = nil
        WebViewViewController.clean()
        cleanCache()
        cleanService()
        
        guard let window = UIApplication.shared.windows.first else {
            return assertionFailure("Invalid Configuration")
        }
        window.rootViewController = SplashViewController()
        window.makeKeyAndVisible()
    }
    
    func cleanCache() {
        let cache = ImageCache.default
        cache.clearMemoryCache()
        cache.clearDiskCache()
    }
    
    func cleanService() {
        profileService.cleanProfile()
        }
}
