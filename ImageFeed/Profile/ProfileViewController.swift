//
//  ProfileViewController.swift
//  ImageFeed
//
//  Created by Эмилия on 30.05.2023.
//

import UIKit
import Kingfisher

final class ProfileViewController: UIViewController {
    
    private let profileService = ProfileService.shared
    private let profileImageService = ProfileImageService.shared
    private let imagesListService = ImagesListService.shared

    private var avatarImageView: UIImageView!
    private var logoutButton: UIButton!
    private var nameLabel: UILabel!
    private var loginNameLabel: UILabel!
    private var descriptionLabel: UILabel!
    private var profileImageServiceObserver: NSObjectProtocol?
        
    override func viewDidLoad() {
        super.viewDidLoad()
        initAvatarImage(view: view)
        initLogoutButton(view: view)
        initLabels(view: view)
        
        updateProfileDetails(profile: profileService.profile)
    }
    
    func updateProfileDetails(profile: Profile?) {
        guard let profile = profile else { return }
            nameLabel.text = profile.name ?? ""
            loginNameLabel.text = profile.loginName
            descriptionLabel.text = profile.bio ?? ""
            
            profileImageServiceObserver = NotificationCenter.default
                .addObserver(
                    forName: ProfileImageService.didChangeNotification,
                    object: nil,
                    queue: .main
                ) { [weak self] _ in
                    guard let self = self else { return }
                    self.updateAvatar()
                }
            updateAvatar()
    }
    
    private func updateAvatar() {
            guard
                let profileImageURL = ProfileImageService.shared.avatarURL,
                let imageURL = URL(string: profileImageURL)
                    else { return }
            let processor = RoundCornerImageProcessor(cornerRadius: 61)
            avatarImageView.kf.indicatorType = .activity
            avatarImageView.kf.setImage(with: imageURL,
                                        placeholder: UIImage(named: "avatar_none"),
                                        options: [.processor(processor)]) { result in
                switch result {
                    
                case .success(let data):
                    self.avatarImageView.image = data.image
                    print("Success")
                case .failure(_):
                    print("Fail")
                }
            }
        }
    
    private func initAvatarImage(view: UIView) {
        view.backgroundColor = UIColor(named: "ypBlack")
        
        let avatarImage = UIImage(named: "avatar")
        let avatarImageView = UIImageView(image: avatarImage)
        avatarImageView.layer.cornerRadius = 35
        avatarImageView.clipsToBounds = true
        
        avatarImageView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(avatarImageView)
        avatarImageView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16).isActive = true
        avatarImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 32).isActive = true
        avatarImageView.widthAnchor.constraint(equalToConstant: 70).isActive = true
        avatarImageView.heightAnchor.constraint(equalToConstant: 70).isActive = true
        
        self.avatarImageView = avatarImageView
    }
    
    private func initLogoutButton(view: UIView) {
        let logoutButton = UIButton.systemButton(
                    with: UIImage(named: "logout_button")!,
                    target: self,
                    action: #selector(showAlert)
        )
        
        logoutButton.tintColor = UIColor(named: "ypRed")
        
        logoutButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(logoutButton)
        logoutButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20).isActive = true
        logoutButton.centerYAnchor.constraint(equalTo: avatarImageView.centerYAnchor).isActive = true
        self.logoutButton = logoutButton
    }
    
    private func initLabels(view: UIView) {
        let nameLabel = UILabel()
        nameLabel.text = "Екатерина Новикова"
        nameLabel.textColor = UIColor(named: "ypWhite")
        nameLabel.font = UIFont.systemFont(ofSize: 23, weight: .bold)
        
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(nameLabel)
        nameLabel.topAnchor.constraint(equalTo: avatarImageView.bottomAnchor, constant: 8).isActive = true
        nameLabel.leadingAnchor.constraint(equalTo: avatarImageView.leadingAnchor).isActive = true
        self.nameLabel = nameLabel
        
        let loginNameLabel = UILabel()
        loginNameLabel.text = "@ekaterina_nov"
        loginNameLabel.textColor = UIColor(named: "ypGray")
        loginNameLabel.font = UIFont.systemFont(ofSize: 13)
        
        loginNameLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(loginNameLabel)
        loginNameLabel.trailingAnchor.constraint(equalTo: nameLabel.trailingAnchor).isActive = true
        loginNameLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 8).isActive = true
        loginNameLabel.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor).isActive = true
        self.loginNameLabel = loginNameLabel
        
        let descriptionLabel = UILabel()
        descriptionLabel.numberOfLines = 0
        descriptionLabel.text = "Hello, world!"
        descriptionLabel.textColor = UIColor(named: "ypWhite")
        descriptionLabel.font = UIFont.systemFont(ofSize: 13)
        
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(descriptionLabel)
        descriptionLabel.trailingAnchor.constraint(equalTo: nameLabel.trailingAnchor).isActive = true
        descriptionLabel.topAnchor.constraint(equalTo: loginNameLabel.bottomAnchor, constant: 8).isActive = true
        descriptionLabel.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor).isActive = true
        self.descriptionLabel = descriptionLabel
    }
    

    @objc
    private func didTapLogoutButton() {
        OAuth2TokenStorage().token = nil
        WebViewViewController.clean()
        cleanCache()
                
        guard let window = UIApplication.shared.windows.first else {
            return assertionFailure("Invalid Configuration")
        }
        window.rootViewController = SplashViewController()
    }
    
    private func cleanCache() {
            let cache = ImageCache.default
            cache.clearMemoryCache()
            cache.clearDiskCache()
        }
    
    @objc
    private func showAlert() {
        let alert = UIAlertController(title: "Пока, пока!", message: "Уверены, что хотите выйти?", preferredStyle: .alert)
        let action1 = UIAlertAction(title: "Да", style: .default) { [weak self] _ in
            guard let self = self else { return }
            self.didTapLogoutButton()
        }
        let action2 = UIAlertAction(title: "Нет", style: .default) { _ in
            alert.dismiss(animated: true)
        }
        alert.addAction(action1)
        alert.addAction(action2)
        self.present(alert, animated: true)
    }
}

extension ProfileViewController {
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
}
