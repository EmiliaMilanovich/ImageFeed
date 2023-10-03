//
//  ProfilePresenterSpy.swift
//  ImageFeedTests
//
//  Created by Эмилия on 03.10.2023.
//

import ImageFeed
import Foundation

final class ProfileViewPresenterSpy: ProfileViewPresenterProtocol {
    var view: ProfileViewControllerProtocol?
    var viewDidLoadCalled = false
    var notificationProfileCalled = false
    var exitProfileCalled = false
    
    func viewDidLoad() {
        viewDidLoadCalled = true
    }
    
    func getAvatar() -> URL? {
        return nil
    }
    
    func notificationProfileImage() {
        notificationProfileCalled = true
    }
    
    func exitProfile() {
        exitProfileCalled = true
    }
}
