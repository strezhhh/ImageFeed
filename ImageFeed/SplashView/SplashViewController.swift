//
//  SplashViewController.swift
//  ImageFeed
//
//  Created by Pavel Strezh on 07.10.2026.
//

import UIKit
import Logging

final class SplashViewController: UIViewController {
    
    // MARK: - Private Properties
    
    private let storage = OAuth2TokenStorage.shared
    private let showAuthenticationScreenSegueIdentifier = "showAuthenticationScreenSegueIdentifier"
    private let tabBarViewController = "TabBarViewController"
    private let naviAuthViewController = "NaviAuthViewController"
    private let authViewControllerID = "AuthViewController"
    private var authViewController: AuthViewController?
    private let backgroundColor = "YP Black"
    private var splashIconImageView: UIImageView?
    private let splashIconImageIdentifier = "splash_screen_logo"
    
    
    // MARK: - Lifecycle
    deinit {
        Apploger.info("SplashViewController уничтожен")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if storage.token != nil {
            guard let token = storage.token else {
                Apploger.error("ошибка чтения токена")
                return
            }
            fetchProfile(token)
        } else {
            switchToNaviAuthController()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        Apploger.info("awakeFromNib сработал")
        setupBackgroundColor()
        setupSplashIcon()
    }
    
    // MARK: - Private Methods
    
    // Метод присвоит нужный цвет экрану
    private func setupBackgroundColor() {
        view.backgroundColor = UIColor(named: backgroundColor)
    }
    
    // Метод добавит иконку по центру
    private func setupSplashIcon() {
        splashIconImageView = UIImageView(image: UIImage(systemName: splashIconImageIdentifier))
        guard let splashIconImageView else {
            return }
        splashIconImageView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(splashIconImageView)
        splashIconImageView.tintColor = .ypWhite
        splashIconImageView.widthAnchor.constraint(equalToConstant: 74).isActive = true
        splashIconImageView.heightAnchor.constraint(equalToConstant: 76.64).isActive = true
        splashIconImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        splashIconImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    }
    
    // Метод передаст управление AuthViewController'у
    private func switchToNaviAuthController() {
        let storyboard = UIStoryboard(name: "Main", bundle: .main)
        guard let viewController = storyboard.instantiateViewController(withIdentifier: authViewControllerID) as? AuthViewController else {
            assertionFailure("SplashViewController.switchToNaviAuthController: ошибка создания AuthViewController")
            Apploger.error("ошибка создания AuthViewController")
            return
        }
        viewController.delegate = self
        viewController.modalPresentationStyle = .fullScreen
        present(viewController, animated: true)
    }
    
    // Метод передаст управление TabBarViewController'у
    private func switchToTabBarController() {
        guard
            let windowScene = UIApplication.shared.connectedScenes
                .first(where: { $0.activationState == .foregroundActive }) as? UIWindowScene,
            let window = windowScene.windows.first
        else {
            assertionFailure("SplashViewController.switchToTabBarController: Invalid window configuration")
            Apploger.error("Invalid window configuration")
            return
        }
        let tabBarController = UIStoryboard(name: "Main", bundle: .main)
            .instantiateViewController(withIdentifier: tabBarViewController)
        window.rootViewController = tabBarController
    }
    
}

// MARK: - extension SplashViewController: AuthViewControllerDelegate

extension SplashViewController: AuthViewControllerDelegate {
    
    func didAuthenticate(_ vc: AuthViewController) {
        navigationController?.popViewController(animated: true)
        guard let token = OAuth2TokenStorage.shared.token else {
            Apploger.error("bearerToken отсутствует")
            return
        }
        fetchProfile(token)
    }
    
    private func fetchProfile(_ token: String) {
        UIBlockingProgressHUD.show()
        ProfileService.shared.fetchProfile(token) { [weak self] result in
            UIBlockingProgressHUD.dismiss()
            switch result {
            case .success(let profile):
                Apploger.info("Получены данные профиля")
                ProfileImageService.shared.fetchProfileImageURL(username: profile.username) {_ in
                    switch result {
                    case .success:
                        Apploger.info("Получена URL аватарки")
                    case .failure (let error):
                        Apploger.error("ошибка получения URL аватарки", error)
                    }
                }
                guard let self = self else {
                    return
                }
                self.switchToTabBarController()
            case .failure:
                Apploger.error("ошибка получения профиля")
                break
            }
        }
    }
    
}
