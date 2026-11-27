//
//  ProfileLogoutService.swift
//  ImageFeed
//
//  Created by Pavel Strezh on 23.11.2026.
//

import UIKit
import WebKit
import Logging
import Kingfisher



final class ProfileLogoutService {
    
    // MARK: - Static Properties
    
    static let shared = ProfileLogoutService()
    
    // MARK: - Initialization
    
    private init() { }
    
    //MARK: - Methods
    
    func logout() {
        cleanCookies {
            self.switchToNaviAuthController()
        }
        cleanToken()
        cleanProfile()
        cleanAvatarURL()
        cleanKingfisherCash()
    }
    
    // MARK: - Private Methods
    
    private func cleanCookies(completion: @escaping () -> Void) {
        HTTPCookieStorage.shared.removeCookies(since: Date.distantPast)
        let group = DispatchGroup()
        WKWebsiteDataStore.default().fetchDataRecords(ofTypes: WKWebsiteDataStore.allWebsiteDataTypes()) { records in
            records.forEach { record in
                group.enter()
                WKWebsiteDataStore.default().removeData(ofTypes: record.dataTypes, for: [record], completionHandler: {
                    group.leave()
                })
            }
            group.notify(queue: .main) {
                completion()
            }
        }
    }
    
    // удалить кеш KingFisher
    private func cleanKingfisherCash() {
        let cache = ImageCache.default
        cache.clearMemoryCache()
        cache.clearDiskCache()
    }
    
    
    // удалить токен
    private func cleanToken() {
        OAuth2TokenStorage.shared.token = nil
    }
    
    // удалить профиль
    private func cleanProfile() {
        ProfileService.shared.cleanProfile()
    }
    
    // удалить avatarURL
    private func cleanAvatarURL() {
        ProfileImageService.shared.cleanAvatarURL()
    }
    
    // очистить photos в ImagesListService
    private func cleanPhotos() {
        let imagesListService = ImagesListService()
        imagesListService.cleanPhotos()
    }
    
    // Метод по нажатии на кнопку выхода из профиля отправит на начальный экран
    private func switchToNaviAuthController() {
        guard
            let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
            let window = windowScene.windows.first
                else {
            return
        }
        window.rootViewController = SplashViewController()
    }
    
}
