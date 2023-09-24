//
//  OAuth2TokenStorage.swift
//  ImageFeed
//
//  Created by Эмилия on 23.06.2023.
//

import Foundation
import SwiftKeychainWrapper


class OAuth2TokenStorage {
    private enum Keys: String {
        case token
    }
    
    var token: String? {
        get {
            KeychainWrapper.standard.string(forKey: Keys.token.rawValue)
        }
        set {
            guard let newValue = newValue else {
                KeychainWrapper.standard.removeObject(forKey: Keys.token.rawValue)
                return
                
            }
            let isSuccess = KeychainWrapper.standard.set(newValue, forKey: Keys.token.rawValue)
            guard isSuccess else {
                return
            }
        }
    }
}
