//
//  AppCoordinator.swift
//  Navigation
//
//  Корневой координатор. Решает, что показать при запуске: экран
//  авторизации (если сессии нет) или основной таб-бар. После входа
//  подменяет корень окна на таб-бар, при выходе — обратно на авторизацию.
//

import UIKit
import FirebaseAuth

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
        window.makeKeyAndVisible()
        // Firebase помнит вошедшего пользователя между запусками —
        // если сессия есть, экран входа пропускаем.
        if Auth.auth().currentUser != nil {
            showMain()
        } else {
            showAuth()
        }
    }

    // MARK: - Flow

    private func showAuth() {
        childCoordinators.removeAll()

        let authCoordinator = AuthCoordinator(
            navigationController: UINavigationController(),
            moduleFactory: moduleFactory
        )
        authCoordinator.onFinish = { [weak self] in
            self?.showMain()
        }
        childCoordinators.append(authCoordinator)
        authCoordinator.start()

        setRoot(authCoordinator.navigationController)
    }

    private func showMain() {
        childCoordinators.removeAll()

        let tabBarController = UITabBarController()
        tabBarController.tabBar.tintColor = AppColor.accent

        let profileCoordinator = ProfileCoordinator(
            navigationController: UINavigationController(),
            moduleFactory: moduleFactory,
            userService: services.userService
        )
        profileCoordinator.onLogout = { [weak self] in self?.logout() }

        let tabs: [Tab] = [
            Tab(
                coordinator: FeedCoordinator(navigationController: UINavigationController(), moduleFactory: moduleFactory),
                title: L10n.TabBar.feed,
                icon: "house"
            ),
            Tab(
                coordinator: profileCoordinator,
                title: L10n.TabBar.profile,
                icon: "person"
            ),
            Tab(
                coordinator: FavouritesCoordinator(navigationController: UINavigationController(), moduleFactory: moduleFactory),
                title: L10n.TabBar.favourites,
                icon: "heart"
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

        setRoot(tabBarController)
    }

    /// выход из профиля: завершаем сессию Firebase и возвращаем экран входа
    private func logout() {
        try? Auth.auth().signOut()
        showAuth()
    }

    /// Меняет корневой контроллер окна с плавным кроссфейдом,
    /// чтобы переход вход → таб-бар не выглядел резким.
    private func setRoot(_ viewController: UIViewController) {
        guard window.rootViewController != nil else {
            window.rootViewController = viewController
            return
        }
        UIView.transition(with: window, duration: 0.3, options: .transitionCrossDissolve) {
            self.window.rootViewController = viewController
        }
    }
}
