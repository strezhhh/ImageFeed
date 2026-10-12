//
//  BearerTokens.swift
//  ImageFeed
//
//  Created by Pavel Strezh on 07.10.2026.
//

import Foundation

// Структура JSON с bearer токеном
struct OAuthTokenResponseBody: Decodable {
    let bearerToken: String
    let tokenType: String
    let scopeAccess: String
    let createdAt: Int
    
    private enum CodingKeys: String, CodingKey {
        case bearerToken = "access_token"
        case tokenType = "token_type"
        case scopeAccess = "scope"
        case createdAt = "created_at"
    }
    
}

