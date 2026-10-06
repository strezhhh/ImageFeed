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
    
    // MARK: - Private Properties
    
    enum WebViewConstants {
        static let unsplashAuthorizeURLString = "https://unsplash.com/oauth/authorize"
        static let clientID = "client_id"
        static let redirectURI = "redirect_uri"
        static let responseType = "response_type"
        static let scope = "scope"
    }
    
    private let authViewControllerIdentifier = "AuthViewController"
    weak var delegate: WebViewViewControllerDelegate?
    
    // MARK: - Initialization
    
    private func setupNavigationDelegate() {
        webView.navigationDelegate = self
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadAuthView()
        setupNavigationDelegate()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        addObserver()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        guard let delegate = delegate else { return }
        delegate.webViewViewControllerDidCancel(self)
        removeObserver()
    }
        
    // MARK: - Private Methods
    
    // Формирует URL в соответствии с документацией Unsplash
    private func loadAuthView() {
        guard var urlComponents = URLComponents(string: WebViewConstants.unsplashAuthorizeURLString) else {
            return
        }
        
        urlComponents.queryItems = [
            URLQueryItem(name: WebViewConstants.clientID, value: Constants.accessKey),
            URLQueryItem(name: WebViewConstants.redirectURI, value: Constants.redirectURI),
            URLQueryItem(name: WebViewConstants.responseType, value: Constants.code),
            URLQueryItem(name: WebViewConstants.scope, value: Constants.accessScope)
        ]
        
        guard let url = urlComponents.url else {
            print("url не сформирован")
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
            //TODO: process code
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
            urlComponents.path == Constants.oauthAuthorizeNative,
            let items = urlComponents.queryItems,
            let codeItem = items.first(where: {$0.name == Constants.code} )
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
