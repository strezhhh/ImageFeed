//
//  OAuth2TokenStorage.swift
//  ImageFeed
//
//  Created by Pavel Strezh on 07.10.2026.
//

import Foundation
import SwiftKeychainWrapper

final class OAuth2TokenStorage {
    
    static let shared = OAuth2TokenStorage()
    
    // MARK: - Private enumeration
    
    private enum Keys: String {
        case bearerToken
    }
    
    // MARK: - Private Properties
    
    private let storage: UserDefaults = .standard
    
    // новый метод
    var token: String? {
        get {
            KeychainWrapper.standard.string(forKey: Keys.bearerToken.rawValue) ?? nil
        }
        set {
            guard let newValue else {
                KeychainWrapper.standard.removeObject(forKey: Keys.bearerToken.rawValue)
                return
            }
            KeychainWrapper.standard.set(newValue, forKey: Keys.bearerToken.rawValue)
        }
    }
    
    // MARK: - Methods
    
    func store(bearerToken: String) {
        token = bearerToken
    }
    
    // MARK: - Private Initialization
    
    private init() {}
    
}
