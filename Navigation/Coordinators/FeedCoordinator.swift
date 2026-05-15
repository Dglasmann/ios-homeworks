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
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let viewModel = FeedViewModel()
        let feedVC = FeedViewController(viewModel: viewModel)
        feedVC.coordinator = self
        navigationController.setViewControllers([feedVC], animated: true)
        
    }
    
    func showPost(_ post: Post) {
        let postVC = PostViewController()
        postVC.post = post
        postVC.coordinator = self
        navigationController.pushViewController(postVC, animated: true)
    }
    
    func showInfo() {
        let infoVC = InfoViewController()
        navigationController.present(infoVC, animated: true)
    }
}
