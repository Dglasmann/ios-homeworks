//
//  SceneDelegate.swift
//  Navigation
//
//  Created by Sasha Soldatov on 22.02.2026.
//


import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene,
               willConnectTo session: UISceneSession,
               options connectionOptions: UIScene.ConnectionOptions) {
    

        guard let windowScene = (scene as? UIWindowScene) else { return }

        let window = UIWindow(windowScene: windowScene)

        let tabBarController = UITabBarController()

        let feedVC = FeedViewController()
        let profileVC = ProfileViewController()

        let feedNavController = UINavigationController(rootViewController: feedVC)
        let profileNavController = UINavigationController(rootViewController: profileVC)

        feedNavController.tabBarItem = UITabBarItem(
            title: "Лента",
            image: UIImage(systemName: "house"),
            tag: 0
        )

        profileNavController.tabBarItem = UITabBarItem(
            title: "Профиль",
            image: UIImage(systemName: "person"),
            tag: 1
        )

        tabBarController.viewControllers = [feedNavController, profileNavController]

        window.rootViewController = tabBarController
        window.makeKeyAndVisible()

        self.window = window
    }
}
