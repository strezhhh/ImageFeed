//
//  WebViewViewControllerDelegate.swift
//  ImageFeed
//
//  Created by Pavel Strezh on 01.10.2026.
//

import Foundation
import WebKit

// Сущность реализующая протокол WebViewViewControllerDelegate
// может быть делегатом у сущности реализующей протокол WKNavigationDelegate
protocol WebViewViewControllerDelegate: AnyObject {
    
    // метод сообщит, что WebViewViewController получил код
    func webViewViewController(_ vc: WebViewViewController, didAuthenticateWithCode code: String)
    
    // Метод сообщит, что юзер отменил авторизацию, нажав кнопку назад
    func webViewViewControllerDidCancel(_ vc: WebViewViewController)
    
}
