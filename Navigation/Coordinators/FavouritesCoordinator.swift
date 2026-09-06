//
//  FavouritesCoordinator.swift
//  Navigation
//
//  Created by Sasha Soldatov on 06.09.2026.
//

import UIKit

final class FavouritesCoordinator: Coordinator {
    
    var childCoordinators: [Coordinator] = []
    let navigationController: UINavigationController
    
    private let moduleFactory: ModuleFactoryProtocol
    
    init(navigationController: UINavigationController, moduleFactory: ModuleFactoryProtocol) {
        self.navigationController = navigationController
        self.moduleFactory = moduleFactory
    }
    
    func start() {
        navigationController.setViewControllers([moduleFactory.makeFavourites()], animated: false)
    }
    
}
