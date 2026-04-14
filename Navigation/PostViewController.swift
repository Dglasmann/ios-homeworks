//
//  PostViewController.swift
//  Navigation
//
//  Created by Sasha Soldatov on 22.02.2026.
//

import UIKit

class PostViewController: UIViewController {
    
    var post: Post?
    
    private lazy var  label : UILabel = {
        let label = UILabel()
        label.text = "Детали поста"
        label.font = UIFont.systemFont(ofSize: 20, weight: .medium)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            title: "Info",
            style: .plain,
            target: self,
            action: #selector(showInfo))
        
    }
    
    private func setupUI() {
        view.backgroundColor = .systemTeal
        title = post?.title ?? "Пост"
        
        view.addSubview(label)
        
        NSLayoutConstraint.activate([
                    label.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                    label.centerYAnchor.constraint(equalTo: view.centerYAnchor)
                ])
    }
    
    @objc private func showInfo() {
            let infoViewController = InfoViewController()
            present(infoViewController, animated: true, completion: nil)
        }
    }


