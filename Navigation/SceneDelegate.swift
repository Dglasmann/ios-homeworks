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
    var appConfiguration: AppConfiguration?

    func scene(_ scene: UIScene,
               willConnectTo session: UISceneSession,
               options connectionOptions: UIScene.ConnectionOptions) {
    

        guard let windowScene = (scene as? UIWindowScene) else { return }
        let window = UIWindow(windowScene: windowScene)

        let appCoordinator = AppCoordinator(window: window)
        appCoordinator.start()
        
        self.appCoordinator = appCoordinator
        self.window = window
        
        let configuration: [AppConfiguration] = [
            .people(URL(string: "https://swapi.dev/api/people/8")!),
            .starships(URL(string: "https://swapi.dev/api/starships/3")!),
            .planets(URL(string: "https://swapi.dev/api/planets/5")!)
        ]
        let appConfiguration = configuration.randomElement()!
        self.appConfiguration = appConfiguration
        
        NetworkService.request(for: appConfiguration)
            
        
    }
}
