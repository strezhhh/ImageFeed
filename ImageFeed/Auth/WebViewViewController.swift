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

    @IBOutlet weak var webView: WKWebView!

    // MARK: - Private Properties
    
    enum WebViewConstants {
        static let unsplashAuthorizeURLString = "https://unsplash.com/oauth/authorize"
        static let clientID = "client_id"
        static let redirectURI = "redirect_uri"
        static let responseType = "response_type"
        static let scope = "scope"
    }
    
    
    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        loadAuthView()
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
    
}
