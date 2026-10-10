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
    private var authViewController: AuthViewController?
    
    // MARK: - Lifecycle
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if storage.token != nil {
           switchToTabBarController()
        
        } else {
            performSegue(withIdentifier: showAuthenticationScreenSegueIdentifier, sender: nil)
        }
    }
    
    // MARK: - Private Methods
    
    private func switchToTabBarController() {
        guard let window = UIApplication.shared.windows.first else {
                assertionFailure("Invalid window configuration")
            print("strezh - SplashViewController.switchToTabBarController: Invalid window configuration")
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
        switchToTabBarController()
    }
}

// MARK: - extension SplashViewController

extension SplashViewController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

        if segue.identifier == showAuthenticationScreenSegueIdentifier {

            guard
                let navigationController = segue.destination as? UINavigationController,
                let viewController = navigationController.viewControllers.first as? AuthViewController
            else {
                assertionFailure("Failed to prepare for \(showAuthenticationScreenSegueIdentifier)")
                return
            }
            viewController.delegate = self
        } else {
            super.prepare(for: segue, sender: sender)
        }
    }
}
