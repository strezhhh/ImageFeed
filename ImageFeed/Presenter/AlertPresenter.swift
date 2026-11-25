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
    func showAlertWithMessage(
        viewController: UIViewController,
        title: String,
        message: String,
        buttonText: String,
        completion: @escaping () -> Void,
        secondButtonText: String? = nil,
        secondCompletion: (() -> Void)? = nil
    ){
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
        
        if let secondButtonText {
            let secondAction = UIAlertAction(
                title: secondButtonText,
                style: .default
            ) { _ in
                secondCompletion?()
            }
            alert.addAction(secondAction)
        }
        
        DispatchQueue.main.async {
            viewController.present(alert, animated: true, completion: nil)
        }
    }
}
