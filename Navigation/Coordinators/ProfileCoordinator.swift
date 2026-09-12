//
//  ProfileCoordinator.swift
//  Navigation
//
//  Created by Sasha Soldatov on 15.05.2026.
//

import UIKit

final class ProfileCoordinator: Coordinator {
    
    var childCoordinators: [Coordinator] = []
    let navigationController: UINavigationController
    
    private let moduleFactory: ModuleFactoryProtocol
    private let userService: UserService
    
    init(navigationController: UINavigationController, moduleFactory: ModuleFactoryProtocol, userService: UserService) {
        self.navigationController = navigationController
        self.moduleFactory = moduleFactory
        self.userService = userService
    }
    
    /// Профиль — стартовый экран вкладки. Авторизация уже пройдена в
    /// AuthCoordinator, пользователь берётся из UserService.
    func start() {
        switch userService.user(for: "") {
        case .success(let user):
            navigationController.setViewControllers(
                [moduleFactory.makeProfile(user: user, coordinator: self)],
                animated: false
            )
        case .failure(let error):
            assertionFailure(error.localizedDescription)
        }
    }

    func showPhotos() {
        navigationController.pushViewController(moduleFactory.makePhotos(), animated: true)
    }
    
}
