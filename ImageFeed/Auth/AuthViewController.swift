//
//  ScreenViewController.swift
//  ImageFeed
//
//  Created by Pavel Strezh on 01.10.2026.
//

import UIKit

final class AuthViewController: UIViewController {
    
    // MARK: - Private Properties

    // переменная хранит название ShowWebView
    private let showWebViewSegueIdentifier = "ShowWebView"
    
    private let nameNavBackButton = "nav_back_button"
    private let colorNavBackButton = "ypBlack"

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        configureBackButton()
    }
    
    // MARK: - Private Methods

    // Метод настраивает кнопку Назад на экране WebViewViewController
    private func configureBackButton() {
        navigationController?.navigationBar.backIndicatorImage = UIImage(named: nameNavBackButton)
        navigationController?.navigationBar.backIndicatorTransitionMaskImage = UIImage(named: nameNavBackButton)
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        navigationItem.backBarButtonItem?.tintColor = UIColor(named: colorNavBackButton)
    }
    
}
