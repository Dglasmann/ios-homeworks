//
//  SceneDelegate.swift
//  Navigation
//
//  Created by Sasha Soldatov on 22.02.2026.
//


import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    private var appCoordinator: AppCoordinator?
    
    func scene(_ scene: UIScene,
               willConnectTo session: UISceneSession,
               options connectionOptions: UIScene.ConnectionOptions) {
        
        
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        let window = UIWindow(windowScene: windowScene)
        
        // Один контейнер сервисов на весь жц приложения
        let services = ServiceContainer()
        let moduleFactory = ModuleFactory(services: services)
        
        let appCoordinator = AppCoordinator(
            window: window,
            moduleFactory: moduleFactory,
            services: services
        )
        appCoordinator.start()
        
        self.window = window
        self.appCoordinator = appCoordinator
        
        
    }
    
}
