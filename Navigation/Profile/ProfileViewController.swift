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
    
    private var profileHeaderView: ProfileHeaderView?
    
    //MARK: - All for avatar
    private lazy var dimmedOverlay: UIView = {
        let dimmedOverlay = UIView()
        dimmedOverlay.translatesAutoresizingMaskIntoConstraints = false
        dimmedOverlay.backgroundColor = .black
        dimmedOverlay.alpha = 0
        return dimmedOverlay
    }()
    
    private lazy var closeButton: UIButton = {
        let closeButton = UIButton()
        closeButton.translatesAutoresizingMaskIntoConstraints = false
        closeButton.setImage(UIImage(systemName: "xmark")?.withConfiguration(
            UIImage.SymbolConfiguration(pointSize: 20, weight: .bold)
        ), for: .normal)
        closeButton.tintColor = .white
        closeButton.alpha = 0
        closeButton.addTarget(self, action: #selector(closeAvatarAnimation), for: .touchUpInside)
        return closeButton
    }()
    
    private var animatingAvatarView: UIImageView?
    //координаты до начала анимации
    private var avatarOriginalFrame: CGRect = .zero
    private var isAvatarExpanded = false
    
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
        
        #if DEBUG
        view.backgroundColor = .red
        #else
        view.backgroundColor = .green
        #endif
        title = "Profile"
        setupViews()
        setupConstraints()
    }
    
    private func setupViews() {
        view.addSubview(tableView)
        view.addSubview(dimmedOverlay)
        view.addSubview(closeButton)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            dimmedOverlay.topAnchor.constraint(equalTo: view.topAnchor),
            dimmedOverlay.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            dimmedOverlay.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            dimmedOverlay.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            closeButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            closeButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            closeButton.widthAnchor.constraint(equalToConstant: 40),
            closeButton.heightAnchor.constraint(equalToConstant: 40),
        ])
    }
    
    //MARK: - Анимация для аватара
    @objc private func avatarTapped() {
        guard !isAvatarExpanded, let headerView = profileHeaderView else { return }
        
        isAvatarExpanded = true
        
        let avatarInView = headerView.avatarImageView.convert(headerView.bounds, to: view)
        avatarOriginalFrame = avatarInView
        
        headerView.avatarImageView.isHidden = true
        
        //uiimageview с той же картинкой из аватара, чтобы его двигать
        let animatingView = UIImageView(frame: avatarOriginalFrame)
        animatingView.image = headerView.avatarImageView.image
        animatingView.contentMode = .scaleAspectFill
        animatingView.clipsToBounds = true
        animatingView.layer.cornerRadius = avatarOriginalFrame.height / 2
        animatingView.layer.borderColor = UIColor.white.cgColor
        animatingView.layer.borderWidth = 3
        view.addSubview(animatingView)
        self.animatingAvatarView = animatingView
        
        view.bringSubviewToFront(closeButton)
        
        let targetWidth = view.bounds.width
        let targetHeight = targetWidth
        let targetY = (view.bounds.height - targetHeight) / 2
        let targetFrame = CGRect(x: 0, y: targetY, width: targetWidth, height: targetHeight)
        
        //анимация - аватар + overlay
        UIView.animate(withDuration: 0.5, animations: {
            animatingView.frame = targetFrame
            animatingView.layer.cornerRadius = 0
            animatingView.layer.borderWidth = 0
            self.dimmedOverlay.alpha = 0.5
        }, completion: { _ in
            
            //кнопка крестика после завершения первой анимации
            UIView.animate(withDuration: 0.3) {
                self.closeButton.alpha = 1
            }
        })
    }
    
    //Обратная анимация
    @objc private func closeAvatarAnimation() {
        guard isAvatarExpanded, let animatingView = animatingAvatarView else { return }
        
        //скрываем крестик
        UIView.animate(withDuration: 0.1, animations: {
            self.closeButton.alpha = 0
        }, completion: {_ in
            //возвращаем аватар на место
            UIView.animate(withDuration: 0.5, animations: {
                animatingView.frame = self.avatarOriginalFrame
                animatingView.layer.cornerRadius = self.avatarOriginalFrame.height / 2
                animatingView.layer.borderWidth = 3
                self.dimmedOverlay.alpha = 0
            }, completion: {_ in
                animatingView.removeFromSuperview()
                self.animatingAvatarView = nil
                self.profileHeaderView?.avatarImageView.isHidden = false
                self.isAvatarExpanded = false

            })
            
        })
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

//показываем наш ProfileHeaderView над таблицей в качестве заголовка
extension ProfileViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard section == 0 else { return nil }
        let headerView = ProfileHeaderView()
        
        self.profileHeaderView = headerView
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(avatarTapped))
        headerView.avatarImageView.addGestureRecognizer(tapGesture)
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
