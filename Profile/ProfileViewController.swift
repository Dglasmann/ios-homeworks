//
//  ProfileViewController.swift
//  Navigation
//
//  Created by Sasha Soldatov on 24.02.2026.
//

import UIKit

class ProfileViewController: UIViewController {

    //MARK: - subviews
    private let profileHeaderView: ProfileHeaderView = {
        let view = ProfileHeaderView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var bottomButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Какая то новая кнопка", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        button.backgroundColor = .systemBlue
        button.layer.cornerRadius = 10
        return button
    }()
    
    //MARK: - lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .lightGray
        title = "Profile"
        setupView()
        setupConstraints()
    }
    
    //MARK: - setup
    private func setupView() {
        view.addSubview(profileHeaderView)
        view.addSubview(bottomButton)
    }
    
    private func setupConstraints() {
        
        NSLayoutConstraint.activate([
        profileHeaderView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
        profileHeaderView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
        profileHeaderView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        profileHeaderView.heightAnchor.constraint(equalToConstant: 220),
        
        bottomButton.leadingAnchor.constraint(equalTo: view.leadingAnchor),
        bottomButton.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        bottomButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
        bottomButton.heightAnchor.constraint(equalToConstant: 50),
        ])
    }
    
}
