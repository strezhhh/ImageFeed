//
//  Constants.swift
//  ImageFeed
//
//  Created by Pavel Strezh on 30.09.2026.
//

import Foundation

//// Переменные для работы с API Unsplash
enum Constants {
    static let accessKey: String = "SDon0102NwDOuEgfm6gzP9O035HcVNWH7kxaU_JSk0w"
    static let secretKey: String = "7dXqur6ukoLA9u_dY9_x9jve00tKXIEd5Xh8XlWnbNs"
    static let redirectURI: String = "urn:ietf:wg:oauth:2.0:oob"
    static let accessScope: String = "public+read_user+write_likes"
    static let defaultBaseURLString: String = "https://api.unsplash.com"
    static let code: String = "code"
    static let oauthAuthorizeNative: String = "/oauth/authorize/native"
    static let grant_type: String = “authorization_code”
}
