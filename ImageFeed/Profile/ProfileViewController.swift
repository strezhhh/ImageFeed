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
    private var nameIdentifier = "Екатерина Новикова"
    private var usernameIdentifier = "@ekaterina_nov"
    private var statusIdentifier = "Hello, world!"
    
    private var avatarImageView: UIImageView?
    private var nameLabel: UILabel?


    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupProfileAvatar()
        setupNameLabel()
    }

    // MARK: - Private Methods

    private func setupProfileAvatar() {
        //avatarImageView? = avatarImage != nil ? UIImageView(image: avatarImage) : UIImage(systemName: "person.crop.circle.fill")
        //avatarImageView? = UIImageView(image: avatarImage)
        //guard let avatarImageView = avatarImageView else { return }
        let avatarImage = UIImage(named: avatarImageIdentifier)
        avatarImageView = UIImageView(image: avatarImage)
        guard let avatarImageView else { return }
        avatarImageView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(avatarImageView)
        avatarImageView.tintColor = .white
        avatarImageView.widthAnchor.constraint(equalToConstant: 70).isActive = true
        avatarImageView.heightAnchor.constraint(equalToConstant: 70).isActive = true
        avatarImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 30).isActive = true
        avatarImageView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16).isActive = true
    }

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
    
}
