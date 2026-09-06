//
//  PostViewController.swift
//  Navigation
//
//  Created by Sasha Soldatov on 22.02.2026.
//

import UIKit
import StorageService

final class PostViewController: UIViewController {
    
    var post: Post?
    weak var coordinator: FeedCoordinator?
    
    private lazy var label : UILabel = {
        let label = UILabel()
        label.text = "Детали поста"
        label.font = AppFont.postAuthor
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            title: L10n.Feed.info,
            style: .plain,
            target: self,
            action: #selector(showInfo))
        
    }
    
    private func setupUI() {
        view.backgroundColor = AppColor.background
        title = post?.title ?? L10n.Feed.postDetails
        
        view.addSubview(label)
        
        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            label.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    @objc private func showInfo() {
        coordinator?.showInfo()
    }
}


