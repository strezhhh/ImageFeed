//
//  AppDelegate.swift
//  ImageFeed
//
//  Created by Pavel Strezh on 05.09.2026.
//

import UIKit

@main
final class AppDelegate: UIResponder, UIApplicationDelegate {

    private let mainName = "Main"
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        return true
    }

    // MARK: UISceneSession Lifecycle

    
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession,
        options: UIScene.ConnectionOptions
    ) -> UISceneConfiguration {
       let sceneConfiguration = UISceneConfiguration(
           name: mainName,
           sessionRole: connectingSceneSession.role
       )
       sceneConfiguration.delegateClass = SceneDelegate.self
       return sceneConfiguration
    }

}

