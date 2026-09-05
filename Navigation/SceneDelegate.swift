//
//  SceneDelegate.swift
//  Navigation
//
//  Created by Sasha Soldatov on 22.02.2026.
//


import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    var appCoordinator: AppCoordinator?
    
    func scene(_ scene: UIScene,
               willConnectTo session: UISceneSession,
               options connectionOptions: UIScene.ConnectionOptions) {
        
        
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        let window = UIWindow(windowScene: windowScene)
        
        let appCoordinator = AppCoordinator(window: window)
        appCoordinator.start()
        
        self.appCoordinator = appCoordinator
        self.window = window
        
        
    }
    
}
