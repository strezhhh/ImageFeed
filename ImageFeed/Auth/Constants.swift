//
//  Constants.swift
//  ImageFeed
//
//  Created by Pavel Strezh on 30.09.2026.
//

import Foundation


// MARK: - Enumeration

// Значения для работы с API Unsplash
enum ConstantsValue {
    static let accessKey: String = "SDon0102NwDOuEgfm6gzP9O035HcVNWH7kxaU_JSk0w"
    static let secretKey: String = "7dXqur6ukoLA9u_dY9_x9jve00tKXIEd5Xh8XlWnbNs"
    static let redirectURI: String = "urn:ietf:wg:oauth:2.0:oob"
    static let accessScope: String = "public+read_user+write_likes"
    static let defaultBaseURLString: String = "https://api.unsplash.com"
    static let oauthAuthorizeNative: String = "/oauth/authorize/native"
    static let unsplashAuthorizeURLString = "https://unsplash.com/oauth/authorize"
    static let postRequestOAuthTokenURLString = "https://unsplash.com/oauth/token"
    static let grantType: String = "authorization_code"
    static let requestMethod = "POST"
}


// Имена для работы с API Unsplash
enum ConstantsName {
    static let clientID = "client_id"
    static let redirectURI = "redirect_uri"
    static let responseType = "response_type"
    static let scope = "scope"
    static let clientSecret = "client_secret"
    static let grantType = "grant_type"
    static let codeString = "code"
}
