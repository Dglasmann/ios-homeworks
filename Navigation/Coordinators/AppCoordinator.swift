//
//  AppCoordinator.swift
//  Navigation
//
//  Created by Sasha Soldatov on 15.05.2026.
//
import UIKit

final class AppCoordinator {
    var childCoordinators: [Coordinator] = []
    private let window: UIWindow
    
    init(window: UIWindow) {
        self.window = window
    }
    
    
    func start() {
        let tabBarController = UITabBarController()
        
        let feedNavController = UINavigationController()
        let feedCoordinator = FeedCoordinator(navigationController: feedNavController)
        feedNavController.tabBarItem = UITabBarItem(
            title: "Лента",
            image: UIImage(systemName: "house"),
            tag: 0
        )
        
        
        let profileNavController = UINavigationController()
        let profileCoordinator = ProfileCoordinator(navigationController: profileNavController)
        profileNavController.tabBarItem = UITabBarItem(
            title: "Профиль",
            image: UIImage(systemName: "person"),
            tag: 1
        )
        
        childCoordinators.append(feedCoordinator)
        childCoordinators.append(profileCoordinator)
        
        feedCoordinator.start()
        profileCoordinator.start()
        
        tabBarController.viewControllers = [feedNavController, profileNavController]
        window.rootViewController = tabBarController
        window.makeKeyAndVisible()
    }
    
    
}
