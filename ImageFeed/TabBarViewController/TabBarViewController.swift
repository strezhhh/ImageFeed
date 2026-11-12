//
//  TabBarViewController.swift
//  ImageFeed
//
//  Created by Pavel Strezh on 11.11.2026.
//

import UIKit
import Logging

final class TabBarViewController: UITabBarController {
    
    // MARK: - Private Properties
    
    // переменная хранит StoriboarID для ImagesListViewController
    let imagesListViewController = "ImagesListViewController"

    // переменная хранит StoriboarID для ProfileViewController
    let profileViewController = "ProfileViewController"
    
    // переменная хранит StoriboarID для NavigationController
    let navigationViewController = "NavigationViewController"
    
    // переменная хранир название иконки TapBar'a для profileViewController
    let profileIconName = "tab_profile_active"

    // MARK: - Lifecyclz
    
    override func awakeFromNib() {
        
        Apploger.info("awakeFromNib сработал")

        super.awakeFromNib()
        let storyboard = UIStoryboard(name: "Main", bundle: .main)
        
        let navigationViewController = storyboard.instantiateViewController(
            withIdentifier: navigationViewController
        )
        
        let profileViewController = ProfileViewController()
        profileViewController.tabBarItem = UITabBarItem(
                       title: "",
                       image: UIImage(named: profileIconName),
                       selectedImage: nil
                   )
        
        self.viewControllers = [navigationViewController, profileViewController]
    }

}
