//
//  AlertPresenter.swift
//  ImageFeed
//
//  Created by Pavel Strezh on 10.11.2026.
//

import UIKit

final class AlertPresenter {
    
    // MARK: - Properties

    static let shared = AlertPresenter()
    
    // MARK: - Initialization

    private init() {
        
    }
    
    // Метод отображения Алерты с заголовком, сообщением и кнопкой
    func showAlertWithMessage(viewController: UIViewController, title: String, message: String, buttonText: String, completion: @escaping () -> Void) {
        let alert = UIAlertController(
            title: title,
            message: message,
            preferredStyle: .alert
        )
        let action = UIAlertAction(
            title: buttonText,
            style: .default
        ) { _ in
            completion()
        }
        
        alert.addAction(action)
        DispatchQueue.main.async {
            viewController.present(alert, animated: true, completion: nil)
        }
        
    }
}
