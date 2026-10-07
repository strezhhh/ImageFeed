//
//  BearerTokens.swift
//  ImageFeed
//
//  Created by Pavel Strezh on 07.10.2026.
//

import Foundation

// Структура JSON с bearer токеном
struct OAuthTokenResponseBody: Codable {
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
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        bearerToken = try container.decode(String.self, forKey: .bearerToken)
        tokenType = try container.decode(String.self, forKey: .tokenType)
        scopeAccess = try container.decode(String.self, forKey: .scopeAccess)
        createdAt = try container.decode(Int.self, forKey: .createdAt)
    }
}

