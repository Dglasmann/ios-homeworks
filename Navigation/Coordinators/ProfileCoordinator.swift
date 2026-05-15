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
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    func start() {
        let loginFactory = MyLoginFactory()
        let loginVC = LoginViewController()
        loginVC.loginDelegate = loginFactory.makeLoginInspector()
        loginVC.coordinator = self
        navigationController.setViewControllers([loginVC], animated: true)
    }
    
    func showProfile(user: User) {
        let profileVC = ProfileViewController(user: user)
        profileVC.coordinator = self
        navigationController.pushViewController(profileVC, animated: true)
    }
    
    func showPhotos() {
        let photosVC = PhotosViewController()
        navigationController.pushViewController(photosVC, animated: true)
    }
    
}
