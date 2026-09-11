//
//  AppCoordinator.swift
//  Navigation
//
//  Created by Sasha Soldatov on 15.05.2026.
//
import UIKit

final class AppCoordinator {
    private struct Tab {
        let coordinator: Coordinator
        let title: String
        let icon: String
    }

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
        
        let tabs: [Tab] = [
            Tab(
                coordinator: FeedCoordinator(navigationController: UINavigationController(), moduleFactory: moduleFactory),
                title: L10n.TabBar.feed,
                icon: "house"
            ),
            Tab(
                coordinator: ProfileCoordinator(
                    navigationController: UINavigationController(),
                    moduleFactory: moduleFactory,
                    userService: services.userService),
                title: L10n.TabBar.profile,
                icon: "person"
            ),
            Tab(
                coordinator: MediaCoordinator(navigationController: UINavigationController(), moduleFactory: moduleFactory),
                title: L10n.TabBar.media,
                icon: "play.circle"
            ),
            Tab(
                coordinator: FavouritesCoordinator(navigationController: UINavigationController(), moduleFactory: moduleFactory),
                title: L10n.TabBar.favourites,
                icon: "star"
            )
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
