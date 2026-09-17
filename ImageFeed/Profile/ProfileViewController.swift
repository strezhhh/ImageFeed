//
//  ProfileViewController.swift
//  ImageFeed
//
//  Created by Pavel Strezh on 16.09.2026.
//

import UIKit

final class ProfileViewController: UIViewController {
    
    // MARK: - IBOutlets

    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var exitButton: UIButton!
    
    
    // MARK: - IBActions

    @IBAction func didTapExitButton(_ sender: Any) {
    }
    
}
