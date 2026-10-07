//
//  ScreenViewController.swift
//  ImageFeed
//
//  Created by Pavel Strezh on 01.10.2026.
//

import UIKit
import WebKit

final class AuthViewController: UIViewController {
    
    // MARK: - Private Properties
    
    // переменная хранит название ShowWebView
    let showWebViewSegueIdentifier = "ShowWebView"
    
    private let nameNavBackButton = "nav_back_button"
    private let colorNavBackButton = "ypBlack"
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureBackButton()
    }
    
    // MARK: - Override Methods
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard
            segue.identifier == showWebViewSegueIdentifier,
            let destination = segue.destination as? WebViewViewControllerProtocol
                else {
            assertionFailure("Ошибка перехода на страницу авторизации")
            return
        }
        setYourselfAsDelegate(to: destination)
    }
    
    
    // MARK: - Private Methods
    
    // Метод настраивает кнопку Назад на экране WebViewViewController
    private func configureBackButton() {
        navigationController?.navigationBar.backIndicatorImage = UIImage(named: nameNavBackButton)
        navigationController?.navigationBar.backIndicatorTransitionMaskImage = UIImage(named: nameNavBackButton)
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        navigationItem.backBarButtonItem?.tintColor = UIColor(named: colorNavBackButton)
    }
    
    // Метод назначения делегата
    private func setYourselfAsDelegate(to destination: WebViewViewControllerProtocol?) {
        guard let delegator = destination else {
            return
        }
        delegator.didSetDelegate(self)
    }
    
}

// MARK: - Extension AuthViewController: WebViewViewControllerDelegate

extension AuthViewController: WebViewViewControllerDelegate {
    
    // MARK: - Methods
    
    // метод сообщит, что WebViewViewController получил код
    func webViewViewController(_ vc: WebViewViewController, didAuthenticateWithCode code: String) {
        OAuth2Service.shared.fetchOAuthToken(code: code) { result in
            switch result {
            case .success(let token):
                OAuth2TokenStorage.shared.store(bearerToken: token)
                vc.navigationController?.popViewController(animated: true)
                print("popview завершён")
            case .failure(let error):
                print("error : \(error)")
            }
            
        }
    }
    
    // Метод сообщит, что юзер отменил авторизацию, нажав кнопку назад
    func webViewViewControllerDidCancel(_ vc: WebViewViewController) {
        vc.dismiss(animated: true)
    }
    
}
