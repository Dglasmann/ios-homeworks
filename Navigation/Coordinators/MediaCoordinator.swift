//
//  MediaCoordinator.swift
//  Navigation
//
//  Created by Sasha Soldatov on 06.09.2026.
//  Координатор раздела Медиа: аудиоплеер, видеоплеер, диктофон
//

import UIKit

final class MediaCoordinator: Coordinator {
    
    var childCoordinators: [Coordinator] = []
    let navigationController: UINavigationController
    
    private let moduleFactory: ModuleFactoryProtocol
    
    init(navigationController: UINavigationController, moduleFactory: ModuleFactoryProtocol) {
        self.navigationController = navigationController
        self.moduleFactory = moduleFactory
    }
    
    func start() {
        let menu = moduleFactory.makeMediaMenu(coordinatoe: self)
        navigationController.setViewControllers([menu], animated: false)
    }
    
    func showAudioPlayer() {
        navigationController.pushViewController(moduleFactory.makeAudioPlayer(), animated: true)
    }
    
    func showVideoList() {
        navigationController.pushViewController(moduleFactory.makeVideoList(), animated: true)
    }
    
    func showAudioRecorder() {
        navigationController.pushViewController(moduleFactory.makeAudioRecorder(), animated: true)
    }
    
}

