//
//  ModuleFactory.swift
//  Navigation
//
//  Created by Sasha Soldatov on 06.09.2026.
//

import UIKit
import StorageService

protocol ModuleFactoryProtocol {
    func makeFeed(coordinator: FeedCoordinator) -> UIViewController
    func makePost(_ post: Post, coordinator: FeedCoordinator) -> UIViewController
    func makeInfo() -> UIViewController
    func makeAuth(coordinator: AuthCoordinator) -> UIViewController
    func makeProfile(user: User, coordinator: ProfileCoordinator) -> UIViewController
    func makePhotos() -> UIViewController
    func makeFavourites() -> UIViewController
}

final class ModuleFactory: ModuleFactoryProtocol {
    
    private let services: ServiceContainerProtocol
    
    init(services: ServiceContainerProtocol) {
        self.services = services
    }
    
    func makeFeed(coordinator: FeedCoordinator) -> UIViewController {
        let viewModel = FeedViewModel(feedService: services.feedService, coordinator: coordinator)
        return FeedViewController(viewModel: viewModel)
    }
    
    func makePost(_ post: StorageService.Post, coordinator: FeedCoordinator) -> UIViewController {
        let viewController = PostViewController()
        viewController.post = post
        viewController.coordinator = coordinator
        return viewController
    }
    
    func makeInfo() -> UIViewController {
        InfoViewController(networkService: services.networkService)
    }
    
    func makeAuth(coordinator: AuthCoordinator) -> UIViewController {
        let viewModel = LoginViewModel(
            loginDelegate: services.loginInspector,
            biometricService: services.localAuthorizationService,
            coordinator: coordinator
        )
        return LoginViewController(viewModel: viewModel)
    }
    
    func makeProfile(user: User, coordinator: ProfileCoordinator) -> UIViewController {
        let viewModel = ProfileViewModel(
            user: user,
            postService: services.postService,
            photoService: services.photoService,
            favouritesService: services.favouritesService,
            coordinator: coordinator
        )
        
        return ProfileViewController(viewModel: viewModel)
    }
    
    func makePhotos() -> UIViewController {
        PhotosViewController(viewModel: PhotosViewModel(photoService: services.photoService))
    }
    
    func makeFavourites() -> UIViewController {
        FavouritesViewController(viewModel: FavouritesViewModel(favouritesService: services.favouritesService))
    }
}
