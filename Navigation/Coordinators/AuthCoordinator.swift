//
//  AuthCoordinator.swift
//  Navigation
//
//  Координатор авторизации. Показывается до основного таб-бара: пока
//  пользователь не вошёл, приложение живёт внутри этого координатора.
//  После успешного входа/регистрации сообщает наверх через onFinish,
//  и AppCoordinator подменяет корень окна на таб-бар.
//

import UIKit

final class AuthCoordinator: Coordinator {

    var childCoordinators: [Coordinator] = []
    let navigationController: UINavigationController

    private let moduleFactory: ModuleFactoryProtocol

    /// Вызывается, когда пользователь успешно авторизовался.
    var onFinish: (() -> Void)?

    init(navigationController: UINavigationController, moduleFactory: ModuleFactoryProtocol) {
        self.navigationController = navigationController
        self.moduleFactory = moduleFactory
    }

    func start() {
        let auth = moduleFactory.makeAuth(coordinator: self)
        navigationController.setViewControllers([auth], animated: false)
    }

    /// View сообщает об успешном входе — передаём событие наверх.
    func didAuthenticate() {
        onFinish?()
    }
}
