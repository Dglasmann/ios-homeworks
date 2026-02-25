//
//  FeedViewController.swift
//  Navigation
//
//  Created by Sasha Soldatov on 22.02.2026.
//

import UIKit

class FeedViewController: UIViewController {
    let post = Post(title: "Мой первый пост")
    
    private lazy var postButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Показать пост", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        button.backgroundColor = .systemBlue
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 10
        button.addTarget(self, action: #selector(showPost), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    private func setupUI() {
        view.backgroundColor = .systemBackground
        title = "Лента"
        
        view.addSubview(postButton)
        
        NSLayoutConstraint.activate([ postButton.centerXAnchor.constraint(equalTo: view.centerXAnchor), postButton.centerYAnchor.constraint(equalTo: view.centerYAnchor), postButton.widthAnchor.constraint(equalToConstant: 200), postButton.heightAnchor.constraint(equalToConstant: 50) ])
    }
    
    @objc private func showPost() {
        let postViewController = PostViewController()
        postViewController.post = post
        navigationController?.pushViewController(postViewController, animated: true)
    }
}
