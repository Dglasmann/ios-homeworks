//
//  FeedCoordinator.swift
//  Navigation
//
//  Created by Sasha Soldatov on 15.05.2026.
//

import UIKit
import StorageService

final class FeedCoordinator: Coordinator {
    var childCoordinators: [Coordinator] = []
    let navigationController: UINavigationController
    
    private let moduleFactory: ModuleFactoryProtocol
    
    init(navigationController: UINavigationController, moduleFactory: ModuleFactoryProtocol) {
        self.navigationController = navigationController
        self.moduleFactory = moduleFactory
    }
    
    func start() {
        let feed = moduleFactory.makeFeed(coordinator: self)
        navigationController.setViewControllers([feed], animated: false)
        
    }
    
    func showPost(_ post: Post) {
        navigationController.pushViewController(
            moduleFactory.makePost(post, coordinator: self),
            animated: true
        )
    }
    
    func showInfo() {
        navigationController.present(moduleFactory.makeInfo(), animated: true)
    }
}
