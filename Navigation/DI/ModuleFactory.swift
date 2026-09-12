//
//  ModuleFactory.swift
//  Navigation
//
//  Created by Sasha Soldatov on 06.09.2026.
//

import UIKit

protocol ModuleFactoryProtocol {
    func makeFeed(coordinator: FeedCoordinator) -> UIViewController
    func makePost(_ post: PostModel) -> UIViewController
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
        let viewModel = FeedViewModel(
            postService: services.postService,
            favouritesService: services.favouritesService,
            coordinator: coordinator
        )
        return FeedViewController(viewModel: viewModel)
    }
    
    func makePost(_ post: PostModel) -> UIViewController {
        PostViewController(post: post)
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
