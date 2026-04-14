//
//  FeedViewController.swift
//  Navigation
//
//  Created by Sasha Soldatov on 22.02.2026.
//

import UIKit

class FeedViewController: UIViewController {
    let post = Post(title: "Мой первый пост")
    
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 10
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        return stackView
    }()
    
    private lazy var firstButton: UIButton = {
        let firstButton = UIButton(type: .system)
        firstButton.setTitle("Открыть пост 1", for: .normal)
        firstButton.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        firstButton.backgroundColor = .systemBlue
        firstButton.setTitleColor(.white, for: .normal)
        firstButton.layer.cornerRadius = 10
        firstButton.addTarget(self, action: #selector(showPost), for: .touchUpInside)
        firstButton.translatesAutoresizingMaskIntoConstraints = false
        return firstButton
    }()
    
    private lazy var secondButton: UIButton = {
        let secondButton = UIButton(type: .system)
        secondButton.setTitle("Открыть пост 2", for: .normal)
        secondButton.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        secondButton.backgroundColor = .systemBlue
        secondButton.setTitleColor(.white, for: .normal)
        secondButton.layer.cornerRadius = 10
        secondButton.addTarget(self, action: #selector(showPost), for: .touchUpInside)
        secondButton.translatesAutoresizingMaskIntoConstraints = false
        return secondButton
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    private func setupUI() {
        view.backgroundColor = .systemBackground
        title = "Лента"
        
        stackView.addArrangedSubview(firstButton)
        stackView.addArrangedSubview(secondButton)
        
        view.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            stackView.widthAnchor.constraint(equalToConstant: 200),
            
            firstButton.heightAnchor.constraint(equalToConstant: 50),
            secondButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    @objc private func showPost() {
        let postViewController = PostViewController()
        postViewController.post = post
        navigationController?.pushViewController(postViewController, animated: true)
    }
}
