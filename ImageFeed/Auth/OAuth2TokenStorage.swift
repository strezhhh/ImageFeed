//
//  OAuth2TokenStorage.swift
//  ImageFeed
//
//  Created by Pavel Strezh on 07.10.2026.
//

import Foundation

final class OAuth2TokenStorage {
    
    static let shared = OAuth2TokenStorage()
    
    // MARK: - Private enumeration
    
    private enum Keys: String {
        case bearerToken          // Для записи bearer токена
    }
    
    // MARK: - Private Properties
    
    private let storage: UserDefaults = .standard

    var token: String? {
        get {
            (storage.string(forKey: "\(Keys.bearerToken.rawValue)")) ?? nil
        }
        set {
            storage.set(newValue, forKey: "\(Keys.bearerToken.rawValue)")
        }
    }
    
    
    // MARK: - Methods
    
    func store(bearerToken: String) {
        token = bearerToken
    }

    // MARK: - Private Initialization
    
    private init() {}
    
}
