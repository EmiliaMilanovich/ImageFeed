//
//  SplashViewController.swift
//  ImageFeed
//
//  Created by Эмилия on 23.06.2023.
//

import UIKit
import ProgressHUD

final class SplashViewController: UIViewController {
    private let showAuthenticationScreenSegueIdentifier = "ShowAuthenticationScreen"
    private let oauth2Service = OAuth2Service()
    private let oauth2TokenStorage = OAuth2TokenStorage()
    private let profileService = ProfileService.shared
    private let profileImageService = ProfileImageService.shared
    
    private var alertPresenter = AlertPresenter()
    private var authViewController: AuthViewController?
    private var splashScreenImageView: UIImageView!

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        if let token = oauth2TokenStorage.token {
            self.fetchProfile(token: token)
            } else {
                showAuthViewController()
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setNeedsStatusBarAppearanceUpdate()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
            
        view.backgroundColor = UIColor(named: "ypBlack")
        initSplashScreenImageView()
        }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        .lightContent
    }

    private func switchToTabBarController() {
        // Получаем экземпляр `Window` приложения
        guard let window = UIApplication.shared.windows.first else { fatalError("Invalid Configuration") }
        // Cоздаём экземпляр нужного контроллера из Storyboard с помощью ранее заданного идентификатора.
        let tabBarController = UIStoryboard(name: "Main", bundle: .main)
            .instantiateViewController(withIdentifier: "TabBarViewController")
        // Установим в `rootViewController` полученный контроллер
        window.rootViewController = tabBarController
    }
    
    private func initSplashScreenImageView() {
            let splashScreenImageView = UIImageView(image: UIImage(named: "splash_screen_logo"))
            splashScreenImageView.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview(splashScreenImageView)
            NSLayoutConstraint.activate([
                splashScreenImageView.heightAnchor.constraint(equalToConstant: 75),
                splashScreenImageView.widthAnchor.constraint(equalToConstant: 75),
                splashScreenImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                splashScreenImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
            ])
            self.splashScreenImageView = splashScreenImageView
    }
}

extension SplashViewController: AuthViewControllerDelegate {
    func authViewController(_ vc: AuthViewController, didAuthenticateWithCode code: String) {
        dismiss(animated: true) { [weak self] in
            guard let self = self else { return }
            UIBlockingProgressHUD.show()
            self.fetchOAuthToken(code)
        }
    }
    
    private func fetchOAuthToken(_ code: String) {
        oauth2Service.fetchOAuthToken(code) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let token):
                self.fetchProfile(token: token)
            case .failure:
                self.showLoginAlert()
                UIBlockingProgressHUD.dismiss()
                break
            }
        }
    }
    
    private func fetchProfile(token: String) {
        profileService.fetchProfile(token) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let data):
                self.profileImageService.fetchProfileImageURL(token: token, username: data.username) { _ in }
                self.switchToTabBarController()
            case .failure:
                self.showLoginAlert()
                break
            }
            UIBlockingProgressHUD.dismiss()
        }
    }
    
    private func showLoginAlert() {
        let model = AlertModel(
                    title: "Что-то пошло не так :(",
                    message: "Не удалось войти в систему",
                    buttonText: "ОК",
                    completion: nil
                )
        alertPresenter.showAlert(model)
    }
    
    private func showAuthViewController() {
        let storyboard = UIStoryboard(name: "Main", bundle: .main)
        let viewController = storyboard.instantiateViewController(identifier: "AuthViewController")
        guard let authViewController = viewController as? AuthViewController else { return }
        authViewController.delegate = self
        authViewController.modalPresentationStyle = .fullScreen
        present(authViewController, animated: true)
    }
}


