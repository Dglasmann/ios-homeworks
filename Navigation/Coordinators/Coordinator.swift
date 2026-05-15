//
//  Coordinator.swift
//  Navigation
//
//  Created by Sasha Soldatov on 15.05.2026.
//

import UIKit

protocol Coordinator: AnyObject {
    var childCoordinators: [Coordinator] { get set }
    var navigationController: UINavigationController { get }
    
    func start() 
    func addChild(_ coordinator: Coordinator)
    func removeChild(_ coordinator: Coordinator)
}

extension Coordinator {
    func addChild(_ child: Coordinator) {
        guard !childCoordinators.contains(where: {$0 === child }) else { return }
        childCoordinators.append(child)
    }
    
    func removeChild(_ child: Coordinator) {
        childCoordinators.removeAll { $0 === child }
    }
}
