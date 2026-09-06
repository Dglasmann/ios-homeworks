//
//  ServiceContainer.swift
//  Navigation
//
//  Created by Sasha Soldatov on 06.09.2026.
//  Единая точка создания сервисов. Создаётся один раз в SceneDelegate
//  и передаётся в фабрику модулей
//

import UIKit

protocol ServiceContainerProtocol {
    var feedService: FeedServiceProtocol { get }
    var postService: PostServiceProtocol { get }
    var photoService: PhotoServiceProtocol { get }
    var favouritesService: FavouritesServiceProtocol { get }
    var localAuthorizationService: LocalAuthorizationServiceProtocol { get }
    var networkService: NetworkServiceProtocol { get }
    var userService: UserService { get }
    var loginInspector: LoginViewControllerDelegate { get }
}

final class ServiceContainer: ServiceContainerProtocol {
    
    private let coreDataService = CoreDataService()
    
    lazy var feedService: FeedServiceProtocol = FeedService()
    lazy var postService: PostServiceProtocol = PostService()
    lazy var photoService: PhotoServiceProtocol = PhotoService()
    lazy var favouritesService: FavouritesServiceProtocol = FavouritesService(coreDataService: coreDataService)
    lazy var localAuthorizationService: LocalAuthorizationServiceProtocol = LocalAuthorizationService()
    lazy var networkService: NetworkServiceProtocol = NetworkService()
    lazy var loginInspector: LoginViewControllerDelegate = MyLoginFactory().makeLoginInspector()
    
    lazy var userService: UserService = {
        let avatar = UIImage(named: "avatar") ?? UIImage()
        #if DEBUG
        return CurrentUserService(
            user: User(login: "admin", fullName: "Test User", avatar: avatar, status: "Debug mode")
        )
        #else
        return CurrentUserService(
            user: User(login: "admin", fullName: "Ivan Ivanov", avatar: avatar, status: "Working hard")
        )
        #endif
    }()
    
    
}

