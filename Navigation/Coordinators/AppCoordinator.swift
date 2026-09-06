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
    private let moduleFactory: ModuleFactoryProtocol
    private let services: ServiceContainerProtocol
    
    
    init(window: UIWindow, moduleFactory: ModuleFactoryProtocol, services: ServiceContainerProtocol) {
        self.window = window
        self.moduleFactory = moduleFactory
        self.services = services
    }
    
    
    func start() {
        let tabBarController = UITabBarController()
        tabBarController.tabBar.tintColor = AppColor.accent
        
        let tabs: [(coordinator: Coordinator, title: String, icon: String)] = [
            (FeedCoordinator(navigationController: UINavigationController(), moduleFactory: moduleFactory),
             L10n.TabBar.feed, "house"),
            (ProfileCoordinator(
                    navigationController: UINavigationController(),
                    moduleFactory: moduleFactory,
                    userService: services.userService),
             L10n.TabBar.profile, "person"),
            (MediaCoordinator(navigationController: UINavigationController(), moduleFactory: moduleFactory),
             L10n.TabBar.media, "play.circle"),
            (FavouritesCoordinator(navigationController: UINavigationController(), moduleFactory: moduleFactory),
             L10n.TabBar.favourites, "star")
        ]
        
        tabBarController.viewControllers = tabs.enumerated().map { index, tab in
            tab.coordinator.navigationController.tabBarItem = UITabBarItem(
                title: tab.title,
                image: UIImage(systemName: tab.icon),
                tag: index
            )
            
            childCoordinators.append(tab.coordinator)
            tab.coordinator.start()
            return tab.coordinator.navigationController
        }
        
        window.rootViewController = tabBarController
        window.makeKeyAndVisible()
    }
}
