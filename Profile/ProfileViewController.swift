//
//  ProfileViewController.swift
//  Navigation
//
//  Created by Sasha Soldatov on 24.02.2026.
//

import UIKit

class ProfileViewController: UIViewController {
    
    //MARK: - Data
    
    private let photos = PhotoStorage.photos
    private let posts = PostStorage.posts
    
    //MARK: - Subviews
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(PostTableViewCell.self, forCellReuseIdentifier: "PostTableViewCell")
        tableView.register(PhotosTableViewCell.self, forCellReuseIdentifier: "PhotosTableViewCell")
        return tableView
    }()
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = "Profile"
        setupViews()
        setupConstraints()
    }
    
    private func setupViews() {
        view.addSubview(tableView)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
    }
}

//MARK: - Extensions
extension ProfileViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0: return 1
        case 1: return posts.count
            
        default:
            return 0
        }
    }
        
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) ->    UITableViewCell {
        switch indexPath.section {
        case 0:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "PhotosTableViewCell", for: indexPath) as? PhotosTableViewCell else {
                return UITableViewCell()
            }
            cell.configure(with: Array(photos.prefix(4)))
            return cell
        case 1:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "PostTableViewCell", for:   indexPath) as? PostTableViewCell else {
                return UITableViewCell()
            }
            cell.configure(with: posts[indexPath.row])
            return cell
            
        default:
            return UITableViewCell()
        }
    }
}

//это для задания "Используйте ProfileTableHederView в качестве HeaderForSection для нулевой секции."
//показываем наш ProfileHeaderView над таблицей в качестве заголовка
extension ProfileViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard section == 0 else { return nil }
        let headerView = ProfileHeaderView()
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        guard section == 0 else { return 0 }
        return 220
    }
    
    func tableView(_ tableVie: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            let photosVC = PhotosViewController()
            navigationController?.pushViewController(photosVC, animated: true)
        }
    }
}
