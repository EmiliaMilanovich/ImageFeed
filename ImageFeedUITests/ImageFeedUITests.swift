//
//  ImageFeedUITests.swift
//  ImageFeedUITests
//
//  Created by Эмилия on 03.10.2023.
//

import XCTest

class Image_FeedUITests: XCTestCase {
    private let app = XCUIApplication()
    
    override func setUpWithError() throws {
        continueAfterFailure = false
        app.launch()
    }
    
    func testAuth() throws {
        app.buttons["Authenticate"].tap()
        
        let webView = app.webViews["UnsplashWebView"]
        XCTAssertTrue(webView.waitForExistence(timeout: 5))
        
        let loginTextField = webView.descendants(matching: .textField).element
        XCTAssertTrue(loginTextField.waitForExistence(timeout: 5))
        
        loginTextField.tap()
        loginTextField.typeText("<Ваш e-mail>") // <Ваш e-mail>
        XCUIApplication().toolbars.buttons["Done"].tap()
        
        let passwordTextField = webView.descendants(matching: .secureTextField).element
        XCTAssertTrue(passwordTextField.waitForExistence(timeout: 5))
            
        passwordTextField.tap()
        passwordTextField.typeText("<Ваш пароль>") //<Ваш пароль>
        webView.swipeUp()
        
        webView.buttons["Login"].tap()
        
        let tablesQuery = app.tables
        let cell = tablesQuery.children(matching: .cell).element(boundBy: 0)
        
        XCTAssertTrue(cell.waitForExistence(timeout: 5))
    }
    
    func testFeed() throws {
        let tablesQuery = app.tables
        let cell = tablesQuery.children(matching: .cell).element(boundBy: 0)

        cell.swipeUp()
        sleep(5)
        
        let cellToLike = tablesQuery.children(matching: .cell).element(boundBy: 1)
        cellToLike.buttons["likeButton"].firstMatch.tap()
        sleep(5)
        
        cellToLike.buttons["likeButton"].firstMatch.tap()
        sleep(5)
        
        
        cellToLike.tap()
        sleep(3)
        
        let image = app.scrollViews.images.element(boundBy: 0)
        XCTAssertTrue(image.waitForExistence(timeout: 40))
        
        image.pinch(withScale: 3, velocity: 1)
        
        image.pinch(withScale: 0.5, velocity: -1)
        
        let navBackButtonWhiteButton = app.buttons["BackButton"]
        navBackButtonWhiteButton.tap()
    }
    

    func testProfile() throws {
        
        sleep(3)
        app.tabBars.buttons.element(boundBy: 1).tap()
          
        XCTAssertTrue(app.staticTexts["<Name Lastname>"].exists)
        XCTAssertTrue(app.staticTexts["<@username>"].exists)
           
        app.buttons["LogoutButton"].tap()
        sleep(2)
           
        app.alerts["Пока, пока!"].scrollViews.otherElements.buttons["Да"].tap()
        sleep(2)
        
        XCTAssertTrue(app.buttons["Authenticate"].exists)
    }
}
