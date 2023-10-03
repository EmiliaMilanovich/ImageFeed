//
//  ProfileViewController.swift
//  ImageFeed
//
//  Created by Эмилия on 30.05.2023.
//

import UIKit
import Kingfisher
import WebKit

//MARK: - Protocol
public protocol ProfileViewControllerProtocol: AnyObject {
    var presenter: ProfileViewPresenterProtocol? { get set }
    func updateAvatar()
    func updateProfileDetails(profile: Profile?)
}

final class ProfileViewController: UIViewController & ProfileViewControllerProtocol {
    //MARK: - Properties
    var presenter: ProfileViewPresenterProtocol?
    
    //MARK: - Private properties
    private var avatarImageView: UIImageView!
    private var logoutButton: UIButton!
    private var nameLabel: UILabel!
    private var loginNameLabel: UILabel!
    private var descriptionLabel: UILabel!
        
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        initAvatarImage(view: view)
        initLogoutButton(view: view)
        initLabels(view: view)
        
        presenter = ProfileViewPresenter()
        presenter?.view = self
        presenter?.viewDidLoad()
    }
    
    //MARK: - Methods
    func updateProfileDetails(profile: Profile?) {
        updateAvatar()
        
        guard let profile = profile else { return }
            nameLabel.text = profile.name ?? ""
            loginNameLabel.text = profile.loginName
            descriptionLabel.text = profile.bio ?? ""
    }
    
    func updateAvatar() {
        let url = presenter?.getAvatar()
        let processor = RoundCornerImageProcessor(cornerRadius: 61)
        avatarImageView.kf.indicatorType = .activity
        avatarImageView.kf.setImage(with: url,
                                    placeholder: UIImage(named: "avatar_none"),
                                    options: [.processor(processor)]) 
    }
    
    //MARK: - IBAction
    @objc
    private func didTapLogoutButton() {
        showAlert()
    }
    
    //MARK: - Private methods
    @objc
    private func showAlert() {
        let alert = UIAlertController(title: "Пока, пока!", message: "Уверены, что хотите выйти?", preferredStyle: .alert)
        let action1 = UIAlertAction(title: "Да", style: .default) { [weak self] _ in
            guard let self = self else { return }
            self.presenter?.exitProfile()
        }
        let action2 = UIAlertAction(title: "Нет", style: .default) { _ in
            alert.dismiss(animated: true)
        }
        alert.addAction(action1)
        alert.addAction(action2)
        self.present(alert, animated: true)
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
                    action: #selector(didTapLogoutButton)
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
}

//MARK: - Extension
extension ProfileViewController {
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
}
