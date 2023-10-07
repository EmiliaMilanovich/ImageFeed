//
//  WebViewPresenter.swift
//  ImageFeed
//
//  Created by Эмилия on 02.10.2023.
//

import Foundation

//MARK: - Protocol
public protocol WebViewPresenterProtocol {
    var view: WebViewViewControllerProtocol? { get set }
    func viewDidLoad()
    func didUpdateProgressValue(_ newValue: Double)
    func code(from url: URL) -> String?
}

final class WebViewPresenter: WebViewPresenterProtocol {
    
    //MARK: - Properties
    weak var view: WebViewViewControllerProtocol?
    var authHelper: AuthHelperProtocol
    
    init(authHelper: AuthHelperProtocol) {
        self.authHelper = authHelper
    }
    
    //MARK: - LifeCycle
    func viewDidLoad() {
        // инициализируем URLComponents и устанавливаем значения, которые хотим передать
        var urlComponents = URLComponents(string: UnsplashAuthorizeURLString)!
        urlComponents.queryItems = [
            URLQueryItem(name: "client_id", value: AccessKey),
            URLQueryItem(name: "redirect_uri", value: RedirectURI),
            URLQueryItem(name: "response_type", value: "code"),
            URLQueryItem(name: "scope", value: AccessScope)
        ]
        let url = urlComponents.url!
        // передаем URL для загрузки
        let request = authHelper.authRequest()
        didUpdateProgressValue(0)
        view?.load(request: request)
    }
    
    //MARK: - Methods
    func didUpdateProgressValue(_ newValue: Double) {
        let newProgressValue = Float(newValue)
        view?.setProgressValue(newProgressValue)
           
        let shouldHideProgress = shouldHideProgress(for: newProgressValue)
        view?.setProgressHidden(shouldHideProgress)
    }
       
    func shouldHideProgress(for value: Float) -> Bool {
        abs(value - 1.0) <= 0.0001
       }
    
    func code(from url: URL) -> String? {
        authHelper.code(from: url)
    }
}

