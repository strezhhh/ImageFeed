//
//  ScreenViewController.swift
//  ImageFeed
//
//  Created by Pavel Strezh on 01.10.2026.
//

import UIKit
import WebKit

final class AuthViewController: UIViewController {
    
    // MARK: - Properties
    
    weak var delegate: AuthViewControllerDelegate?

    
    // MARK: - Private Properties
    
    // переменная хранит название ShowWebView
    private let showWebViewSegueIdentifier = "ShowWebView"
    
    // MARK: - Override Methods
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard
            segue.identifier == showWebViewSegueIdentifier,
            let destination = segue.destination as? WebViewViewControllerProtocol
                else {
            assertionFailure("str.AuthViewController.prepare: Ошибка перехода по seque: showWebViewSegueIdentifier")
            return
        }
        setYourselfAsDelegate(to: destination)
    }
    
    
    // MARK: - Private Methods
        
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

    
    // метод сообщит, что WebViewViewController получил код, необходимый для получения bearer token
    func webViewViewController(_ vc: WebViewViewController, didAuthenticateWithCode code: String) {
        navigationController?.popViewController(animated: true)

        // Метод подготовит POST запрос на bearer token и в случае успеха токен будет записан в storage
        // а управление будет передано SplashViewController
        OAuth2Service.shared.fetchOAuthToken(code: code) { [weak self] result in
            switch result {
            case .success(let token):
                OAuth2TokenStorage.shared.store(bearerToken: token)
                print("strezh - AuthViewController.webViewViewController: bearer token авторизации успешно создан и сохранен")
                guard let self else {
                    return
                }
                self.delegate?.didAuthenticate(self)
            case .failure(let error):
                print("strezh - AuthViewController.webViewViewController: ошибка создания bearer token: \(error.localizedDescription)")
            }
        }
    }
    
    // Метод сообщит, что юзер отменил авторизацию, нажав кнопку назад
    func webViewViewControllerDidCancel(_ vc: WebViewViewController) {
        vc.dismiss(animated: true)
    }
    
}
