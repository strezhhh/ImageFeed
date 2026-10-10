//
//  WebViewViewController.swift
//  ImageFeed
//
//  Created by Pavel Strezh on 01.10.2026.
//

import UIKit
import WebKit

final class WebViewViewController: UIViewController {
    
    // MARK: - IBOutlets
    
    @IBOutlet private var webView: WKWebView!
    @IBOutlet private var progressView: UIProgressView!
    
    // MARK: - Properties
    
    var delegate: WebViewViewControllerDelegate?

    
    // MARK: - Private Properties
    
    private let authViewControllerIdentifier = "AuthViewController"
    private var oauth2Service: OAuth2Service?
    private let nameNavBackButton = "nav_back_button"
    private let colorNavBackButton = "ypBlack"
    
    // MARK: - Initialization
    
    private func setupNavigationDelegate() {
        webView.navigationDelegate = self
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadAuthView()
        setupNavigationDelegate()
        configureBackButton()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        addObserver()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        removeObserver()
    }
        
    // MARK: - Private Methods
    
    // Direct the user to https://unsplash.com/oauth/authorize
    private func loadAuthView() {
        guard var urlComponents = URLComponents(string: ConstantsValue.unsplashAuthorizeURLString) else {
            print("strezh - WebViewViewController.loadAuthView: ошибка создания URLComponents из строки: \(ConstantsValue.unsplashAuthorizeURLString)")
            return
        }
        
        urlComponents.queryItems = [
            URLQueryItem(name: ConstantsName.clientID, value: ConstantsValue.accessKey),
            URLQueryItem(name: ConstantsName.redirectURI, value: ConstantsValue.redirectURI),
            URLQueryItem(name: ConstantsName.responseType, value: ConstantsName.codeString),
            URLQueryItem(name: ConstantsName.scope, value: ConstantsValue.accessScope)
        ]
        
        guard let url = urlComponents.url else {
            print("strezh - WebViewViewController.loadAuthView: ошибка создания url из urlComponents")
            return
        }
        let request = URLRequest(url: url)
        webView.load(request)
    }
    

    
    // MARK: - KVO
    
    // Метод подпишет webView на estimatedProgress
    private func addObserver() {
        webView.addObserver(
            self,
            forKeyPath: #keyPath(WKWebView.estimatedProgress),
            options: .new,
            context: nil)
    }
    
    // Обработчик обновлений
    override func observeValue(
        forKeyPath keyPath: String?,
        of object: Any?,
        change: [NSKeyValueChangeKey : Any]?,
        context: UnsafeMutableRawPointer?
    ) {
        if keyPath == #keyPath(WKWebView.estimatedProgress) {
            updateProgress()
        } else {
            super.observeValue(forKeyPath: keyPath, of: object, change: change, context: context)
        }
    }
    
    private func updateProgress() {
        progressView.progress = Float(webView.estimatedProgress)
        progressView.isHidden = fabs(webView.estimatedProgress - 1.0) <= 0.0001
    }
    
    // Метод удалит подписку webView на estimatedProgress
    private func removeObserver() {
        webView.removeObserver(self, forKeyPath: #keyPath(WKWebView.estimatedProgress), context: nil)
    }
    
    // Метод кастомизации кнопки UIBarButtonItem
    private func configureBackButton() {
        let backButton = UIBarButtonItem(
            image: UIImage(named: nameNavBackButton),
            style: .plain,
            target: self,
            action: #selector(backButtonTapped)
        )
        
        backButton.tintColor = UIColor(named: colorNavBackButton)
        navigationItem.leftBarButtonItem = backButton
    }
        
    @objc private func backButtonTapped() {
            delegate?.webViewViewControllerDidCancel(self)
    }
    
}

// MARK: - Extension WebViewViewController: WKNavigationDelegate

extension WebViewViewController: WKNavigationDelegate {
    
    // MARK: - Methods
    
    // Метод вызывается когда после действий пользователя WKWebView пытается загрузить новую страницу,
    // например, пользователь успешно авторизовался
    func webView(
        _ webView: WKWebView,
        decidePolicyFor navigationAction: WKNavigationAction,
        decisionHandler: @escaping (WKNavigationActionPolicy) -> Void
    ) {
        if let code = code(from: navigationAction) {
            // сообщаем делегату, что код для формирования POST запроса успешно получен
            delegate?.webViewViewController(self, didAuthenticateWithCode: code)
            decisionHandler(.cancel)
        } else {
            decisionHandler(.allow)
        }
    }
    
    // MARK: - Private Methods
    
    // Метод возвращает код авторизации, если он получен
    private func code(from navigationAction: WKNavigationAction) -> String? {
        if
            let url = navigationAction.request.url,
            let urlComponents = URLComponents(string: url.absoluteString),
            urlComponents.path == ConstantsValue.oauthAuthorizeNative,
            let items = urlComponents.queryItems,
            let codeItem = items.first(where: {$0.name == ConstantsName.codeString} )
        {
            return codeItem.value
        } else {
            return nil
        }
            }
    
}

// MARK: - Extension WebViewViewController: WebViewViewControllerProtocol

extension WebViewViewController: WebViewViewControllerProtocol {
        
    // MARK: - Delegate Properties
    func didSetDelegate(_ delegate: WebViewViewControllerDelegate?) {
        self.delegate = delegate
    }
}
