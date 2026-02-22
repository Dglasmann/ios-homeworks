//
//  ProfileViewController.swift
//  Navigation
//
//  Created by Sasha Soldatov on 22.02.2026.
//

import UIKit

class ProfileViewController: UIViewController {
    
    private lazy var centerLabel: UILabel = {
        let label = UILabel()
        label.text = "Красивый профиль"
        label.textAlignment = .center
        label.textColor = .label
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
    }
    
    private func setupUI() {
        view.backgroundColor = .systemBackground
        title = "Профиль"
        
        view.addSubview(centerLabel)
        
        // Центрируем label
        NSLayoutConstraint.activate([
            centerLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            centerLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
}
