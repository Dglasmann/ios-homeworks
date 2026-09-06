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
    
    func start() {
        let login = moduleFactory.makeLogin(coordinator: self)
        navigationController.setViewControllers([login], animated: false)
    }
    
    
    /// Показывает профиль по логину. Пользователь берётся из UserService
    func showProfile(for login: String) {
        switch userService.user(for: login) {
        case .success(let user):
            navigationController.pushViewController(
                moduleFactory.makeProfile(user: user, coordinator: self),
                animated: true
            )
        case .failure(let error):
            assertionFailure(error.localizedDescription)
        }
    }
    
    func showPhotos() {
        navigationController.pushViewController(moduleFactory.makePhotos(), animated: true)
    }
    
}
