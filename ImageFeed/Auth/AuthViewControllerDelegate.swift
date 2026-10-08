//
//  AuthViewControllerDelegate.swift
//  ImageFeed
//
//  Created by Pavel Strezh on 07.10.2026.
//

import Foundation

protocol AuthViewControllerDelegate: AnyObject {
    func didAuthenticate(_ vc: AuthViewController)
} 
