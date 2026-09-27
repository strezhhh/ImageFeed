//
//  ProfileViewController.swift
//  ImageFeed
//
//  Created by Pavel Strezh on 16.09.2026.
//

import UIKit

final class ProfileViewController: UIViewController {
    
//    @IBOutlet weak var nameLabel: UILabel!
//    @IBOutlet weak var usernameLabel: UILabel!
//    @IBOutlet weak var statusLabel: UILabel!
//    @IBOutlet weak var exitButton: UIButton!
    
    // MARK: - Properties

    //let name
    
    // MARK: - Private Properties

    private let avatarImageIdentifier = "UserPhoto"
    private let avatarDefaultImageIdentifier = "person.crop.circle.fill"
    private var nameIdentifier = "Екатерина Новикова"
    private var usernameIdentifier = "@ekaterina_nov"
    private var statusIdentifier = "Hello, world!"
    private let exitIconIdentifier = "iconExit"

    
    private var avatarImageView: UIImageView?
    private var avatarImage: UIImage?
    private var nameLabel: UILabel?
    private var exitButton: UIButton?
    private var usernameLabel: UILabel?

    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupProfileAvatar()
        setupNameLabel()
        setupExitButton()
        setupUsernameLabel()
    }

    // MARK: - Private Methods

    // Метод установит аватарку
    private func setupProfileAvatar() {
        avatarImage = UIImage(named: avatarImageIdentifier)
        // Если у пользователя не загружена аватарка, то ставим стандартную иконку
        avatarImageView = avatarImage != nil ? UIImageView(image: avatarImage) : UIImageView(image: UIImage(systemName: avatarDefaultImageIdentifier))
        guard let avatarImageView else { return }
        avatarImageView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(avatarImageView)
        avatarImageView.tintColor = .white
        avatarImageView.widthAnchor.constraint(equalToConstant: 70).isActive = true
        avatarImageView.heightAnchor.constraint(equalToConstant: 70).isActive = true
        avatarImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 30).isActive = true
        avatarImageView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16).isActive = true
    }

    // Метод установит Имя пользователя
    private func setupNameLabel() {
        nameLabel = UILabel()
        guard let nameLabel else { return }
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(nameLabel)
        let style = Fonts.nameFontSF23Regular
        nameLabel.attributedText = NSAttributedString(
            string: nameIdentifier,
            attributes: [
                .font: style.font,
                .foregroundColor: style.color,
                .kern: style.kern
            ]
        )
        guard let avatarImageView else { return }
        NSLayoutConstraint.activate([
            nameLabel.leadingAnchor.constraint(equalTo: avatarImageView.leadingAnchor),
            nameLabel.topAnchor.constraint(equalTo: avatarImageView.bottomAnchor, constant: 8)
        ])
    }
    
    // Метод установит кнопку выхода из профиля пользователя
    private func setupExitButton() {
        let exitIconImage = UIImage(named: exitIconIdentifier)
        guard let exitIconImage else { return }
        exitButton = UIButton.systemButton(
            with: exitIconImage,
            target: self,
            action: #selector(self.didTapButton)
        )
        guard let exitButton else { return }
        exitButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(exitButton)
        exitButton.tintColor = .ypRed
        exitButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20).isActive = true
        guard let avatarImageView else { return }
        exitButton.centerYAnchor.constraint(equalTo: avatarImageView.centerYAnchor).isActive = true
    }
    
    // Метод установит лейбл юзернейм
    private func setupUsernameLabel() {
        usernameLabel = UILabel()
        guard let usernameLabel else { return }
        usernameLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(usernameLabel)
        let style = Fonts.usernameFontSF13RegularYPWhite50
        usernameLabel.attributedText = NSAttributedString(
            string: usernameIdentifier,
            attributes: [
                .font: style.font,
                .foregroundColor: style.color,
                .kern: style.kern
            ]
        )
        guard let nameLabel else { return }
        NSLayoutConstraint.activate([
            usernameLabel.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
            usernameLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 8)
        ])
    }
    
    // Метод выхода из провиля пользователя
    @objc
    private func didTapButton() {
        tabBarController?.selectedIndex = 0
    }
}
