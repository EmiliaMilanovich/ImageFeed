//
//  OAuthTokenResponseBody.swift
//  ImageFeed
//
//  Created by Эмилия on 27.06.2023.
//

import Foundation

private struct OAuthTokenResponseBody: Decodable {
    
    let accessToken: String
    let tokenType: String
    let scope: String
    let createdAt: Int
}
