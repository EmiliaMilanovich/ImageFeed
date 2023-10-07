//
//  ProfileViewTests.swift
//  ImageFeedTests
//
//  Created by Эмилия on 03.10.2023.
//

import Foundation
@testable import ImageFeed
import XCTest

final class ProfileViewTests: XCTestCase {
    //тестируем связь контроллера и презентера
    func testViewControllerCallsViewDidLoad() {
        //given
        let viewController = ProfileViewController()
        let presenter = ProfileViewPresenterSpy()
        viewController.presenter = presenter
        presenter.view = viewController
        presenter.viewDidLoad()
        
        //when
        _ = viewController.view
        
        //then
        XCTAssertTrue(presenter.viewDidLoadCalled)
    }
}
