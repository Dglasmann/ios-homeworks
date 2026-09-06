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
    func makeLogin(coordinator: ProfileCoordinator) -> UIViewController
    func makeProfile(user: User, coordinator: ProfileCoordinator) -> UIViewController
    func makePhotos() -> UIViewController
    func makeFavourites() -> UIViewController
    func makeMediaMenu(coordinatoe: MediaCoordinator) -> UIViewController
    func makeAudioPlayer() -> UIViewController
    func makeVideoList() -> UIViewController
    func makeAudioRecorder() -> UIViewController
}

final class ModuleFactory: ModuleFactoryProtocol {
    
    private let services: ServiceContainerProtocol
    
    init(services: ServiceContainerProtocol) {
        self.services = services
    }
    
    func makeFeed(coordinator: FeedCoordinator) -> UIViewController {
        let viewController = FeedViewController(viewModel: FeedViewModel())
        viewController.coordinator = coordinator
        return viewController
    }
    
    func makePost(_ post: StorageService.Post, coordinator: FeedCoordinator) -> UIViewController {
        let viewController = PostViewController()
        viewController.post = post
        viewController.coordinator = coordinator
        return viewController
    }
    
    func makeInfo() -> UIViewController {
        InfoViewController()
    }
    
    func makeLogin(coordinator: ProfileCoordinator) -> UIViewController {
        let viewController = LoginViewController()
        viewController.loginDelegate = services.loginInspector
        viewController.coordinator = coordinator
        return viewController
    }
    
    func makeProfile(user: User, coordinator: ProfileCoordinator) -> UIViewController {
        let viewController = ProfileViewController(user: user)
        viewController.coordinator = coordinator
        return viewController
    }
    
    func makePhotos() -> UIViewController {
        PhotosViewController()
    }
    
    func makeFavourites() -> UIViewController {
        FavouritesViewController()
    }
    
    func makeMediaMenu(coordinator: MediaCoordinator) -> UIViewController {
        MediaMenuViewController()
    }
    
    func makeAudioPlayer() -> UIViewController {
        AudioPlayerViewController()
    }
    
    func makeVideoList() -> UIViewController {
        VideoListViewController()
    }
    
    func makeAudioRecorder() -> UIViewController {
        AudioRecorderViewController()
    }
    
    
}
