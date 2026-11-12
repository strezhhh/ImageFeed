//
//  SplashViewController.swift
//  ImageFeed
//
//  Created by Pavel Strezh on 07.10.2026.
//

import UIKit

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
        print("SplashViewController уничтожен")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if storage.token != nil {
            guard let token = storage.token else {
                print("SplashViewController.viewDidAppear ошибка чтения токена")
                return
            }
            fetchProfile(token)
        } else {
            switchToNaviAuthController()
        }
    }
    
    override func awakeFromNib() {
        print("SplashViewController.awakeFromNib сработал")
        super.awakeFromNib()
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
            print("SplashViewController.switchToNaviAuthController: ошибка создания AuthViewController")
            return
        }
        viewController.delegate = self
        viewController.modalPresentationStyle = .fullScreen
        present(viewController, animated: true)
    }
    
    // Метод передаст управление TabBarViewController'у
    private func switchToTabBarController() {
        guard let window = UIApplication.shared.windows.first else {
            assertionFailure("SplashViewController.switchToTabBarController: Invalid window configuration")
            print("SplashViewController.switchToTabBarController: Invalid window configuration")
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
            print("SplashViewController.didAuthenticate: bearer token отсутствует!")
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
                ProfileImageService.shared.fetchProfileImageURL(username: profile.username) {result in
                    if case .failure(let error) = result {
                        print("SplashViewController.fetchProfile: ошибка получения URL аватарки: \(error)")
                    }
                }
                guard let self = self else {
                    return
                }
                self.switchToTabBarController()
            case .failure:
                print("SplashViewController.fetchProfile: ошибка получения профиля!")
                break
            }
        }
    }

}
