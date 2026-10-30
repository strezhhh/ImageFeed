//
//  ProfileViewController.swift
//  ImageFeed
//
//  Created by Pavel Strezh on 16.09.2026.
//

import UIKit

final class ProfileViewController: UIViewController {
    
    // MARK: - Private Properties
    
    private let avatarImageIdentifier = "UserPhoto"
    private let avatarDefaultImageIdentifier = "person.crop.circle.fill"
    //private var nameIdentifier = "Екатерина Новикова"
    //private var usernameIdentifier = "@ekaterina_nov"
    //private var statusIdentifier: String?
    private let exitIconIdentifier = "iconExit"
    
    
    private var avatarImageView: UIImageView?
    private var avatarImage: UIImage?
    private var nameLabel: UILabel?
    private var exitButton: UIButton?
    private var usernameLabel: UILabel?
    private var bioLabel: UILabel?
    
    // обсервер "нового" API на блоках
    private var profileImageServiceObserver: NSObjectProtocol?
    
//    // MARK: - Initialization
//    
//    // Вызывается, когда контроллер создаётся программно
//    override init(nibName: String?, bundle: Bundle?) {
//         super.init(nibName: nibName, bundle: bundle)
//         addObserver()
//     }
//    // Вызывается, когда контроллер создаётся из Storyboard или XIB
//    required init?(coder: NSCoder) {
//        super.init(coder: coder)
//        addObserver()
//    }
    
    // MARK: - Deinitialization
    
//    deinit {
//        removeObserver()
//    }

    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupObserver()
        setupProfileAvatar()
        setupExitButton()
        setupProfileDetails()
    }
    
    // MARK: - Private Methods
    
//    // Метод назначит наблюдателя
//    private func addObserver() {
//        NotificationCenter.default.addObserver(
//            self,
//            selector: #selector(updateAvatar(notification:)),
//            name: ProfileImageService.didChangeNotification,
//            object: nil)
//    }
//    
//    // Метод удалит наблюдателя
//    private func removeObserver() {
//         NotificationCenter.default.removeObserver(
//             self,
//             name: ProfileImageService.didChangeNotification,
//             object: nil)
//     }
//    
//    // Метод обновит аватар
//    @objc
//    private func updateAvatar(notification: Notification) {
//        guard
//            isViewLoaded,
//            let userInfo = notification.userInfo,
//            let profileImageURL = userInfo["URL"] as? String,
//            let url = URL(string: profileImageURL)
//        else { return }
//        
//        // TODO написать код обновления аватара используя Kingfisher
//    }
    
    // Присваиваем обсервер, возвращаемый функцией addObserver
    private func setupObserver {
        profileImageServiceObserver = NotificationCenter.default
                    .addObserver(
                        forName: ProfileImageService.didChangeNotification,
                        object: nil,
                        queue: .main
                    ) { [weak self] _ in
                        guard let self = self else { return }
                        self.updateAvatar()
                    }
                updateAvatar()
            }
    
    // Метод обновляет аватарку
    private func updateAvatar() {
            guard
                let profileImageURL = ProfileImageService.shared.avatarURL,
                let url = URL(string: profileImageURL)
            else { return }
            // TODO написать код обновления аватара, используя Kingfisher
        }
    
    private func setupProfileDetails() {
        guard let profile = ProfileService.shared.profile else {
            print("ProfileViewController.setupProfileDetails: переменная ProfileService.shared.profile пустая")
            return
        }
        setupNameLabel(profile.name)
        setupUsernameLabel(profile.loginName)
        setupBioLabel(profile.bio ?? "")
//        guard let avatarURL = ProfileImageService.shared.avatarURL else {
//            print("ProfileViewController.setupProfileDetails: переменная ProfileImageService.shared.avatarURL пустая")
//            return
//        }
//        setupProfileAvatar(avatarURL)
        
    }
    
    
    // Метод установит аватарку
    private func setupProfileAvatar(/*_ avatarURL: String*/) {
        avatarImage = UIImage(named: avatarImageIdentifier)
        // Если у пользователя не загружена аватарка, то ставим стандартную иконку
        avatarImageView = avatarImage != nil ? UIImageView(image: avatarImage) : UIImageView(image: UIImage(systemName: avatarDefaultImageIdentifier))
        guard let avatarImageView else { return }
        avatarImageView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(avatarImageView)
        avatarImageView.tintColor = .white
        avatarImageView.widthAnchor.constraint(equalToConstant: 70).isActive = true
        avatarImageView.heightAnchor.constraint(equalToConstant: 70).isActive = true
        avatarImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 32).isActive = true
        avatarImageView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16).isActive = true
    }
    
    // Метод установит Имя пользователя
    private func setupNameLabel(_ name: String) {
        nameLabel = UILabel()
        guard let nameLabel else { return }
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(nameLabel)
        let style = Fonts.nameFontSF23Regular
        nameLabel.attributedText = NSAttributedString(
            string: name,
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
    private func setupUsernameLabel(_ username: String) {
        usernameLabel = UILabel()
        guard let usernameLabel else { return }
        usernameLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(usernameLabel)
        let style = Fonts.usernameFontSF13RegularYPWhite50
        usernameLabel.attributedText = NSAttributedString(
            string: username,
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
    
    // Метод установит лейбл статуса
    private func setupBioLabel(_ bio: String) {
        bioLabel = UILabel()
        guard let bioLabel else { return }
        bioLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(bioLabel)
        let style = Fonts.bioFontSF13RegularYPWhite
        bioLabel.attributedText = NSAttributedString(
            string: bio,
            attributes: [
                .font: style.font,
                .foregroundColor: style.color,
                .kern: style.kern
            ]
        )
        guard let usernameLabel else { return }
        NSLayoutConstraint.activate([
            bioLabel.leadingAnchor.constraint(equalTo: usernameLabel.leadingAnchor),
            bioLabel.topAnchor.constraint(equalTo: usernameLabel.bottomAnchor, constant: 8)
        ])
    }
    
    // Метод выхода из профиля пользователя
    @objc
    private func didTapButton() {
        tabBarController?.selectedIndex = 0
    }
}
