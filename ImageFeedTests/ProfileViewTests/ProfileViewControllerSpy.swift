//
//  ProfileViewControllerSpy.swift
//  ImageFeedTests
//
//  Created by Эмилия on 03.10.2023.
//

import ImageFeed
import Foundation

final class ProfileViewControllerSpy: ProfileViewControllerProtocol {
    var presenter: ProfileViewPresenterProtocol?
    func updateAvatar() {}
    func updateProfileDetails(profile: Profile?) {}
}
