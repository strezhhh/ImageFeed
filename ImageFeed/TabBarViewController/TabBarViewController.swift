//
//  TabBarViewController.swift
//  ImageFeed
//
//  Created by Pavel Strezh on 11.11.2026.
//

import UIKit

final class TabBarViewController: UITabBarController {
    
    // MARK: - Private Properties
    
    // переменная хранит StoriboarID для ImagesListViewController
    let imagesListViewController = "ImagesListViewController"

    // переменная хранит StoriboarID для ProfileViewController
    let profileViewController = "ProfileViewController"
    
    // переменная хранит StoriboarID для NavigationController
    let navigationViewController = "NavigationViewController"

    // MARK: - Lifecyclz
    
    override func awakeFromNib() {
        
        print("TabBarViewController.awakeFromNib сработал")

        super.awakeFromNib()
        let storyboard = UIStoryboard(name: "Main", bundle: .main)
        
        let navigationViewController = storyboard.instantiateViewController(
            withIdentifier: navigationViewController
        )
        
        let profileViewController = storyboard.instantiateViewController(
            withIdentifier: profileViewController
        )
        
        self.viewControllers = [navigationViewController, profileViewController]
    }

}
