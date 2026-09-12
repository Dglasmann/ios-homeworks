//
//  ProfileViewController.swift
//  Navigation
//
//  Created by Sasha Soldatov on 24.02.2026.
//

import UIKit

final class ProfileViewController: UIViewController {
 
    // MARK: - Dependencies
 
    private let viewModel: ProfileViewModel
 
    // MARK: - Init
 
    init(viewModel: ProfileViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
 
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
 
    // MARK: - Avatar animation state
 
    private var profileHeaderView: ProfileHeaderView?
    private var animatingAvatarView: UIImageView?
 
    /// Координаты аватара до начала анимации — по ним возвращаем его на место.
    private var avatarOriginalFrame: CGRect = .zero
    private var isAvatarExpanded = false
 
    // MARK: - Subviews
 
    private lazy var dimmedOverlay: UIView = {
        let overlay = UIView()
        overlay.translatesAutoresizingMaskIntoConstraints = false
        overlay.backgroundColor = AppColor.overlay
        overlay.alpha = 0
        return overlay
    }()
 
    private lazy var closeButton: CustomButton = {
        let button = CustomButton(
            title: "",
            tapAction: { [weak self] in self?.closeAvatarAnimation() }
        )
        button.setImage(
            UIImage(systemName: "xmark")?.withConfiguration(
                UIImage.SymbolConfiguration(pointSize: 20, weight: .bold)
            ),
            for: .normal
        )
        button.tintColor = AppColor.textOnAccent
        button.alpha = 0
        return button
    }()
 
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.dataSource = self
        tableView.delegate = self
        tableView.dragInteractionEnabled = true
        tableView.dragDelegate = self
        tableView.dropDelegate = self
 
        // Высота шапки считается автоматически, чтобы она растягивалась
        // при крупном системном шрифте; 300 — оценка для расчёта скролла
        tableView.estimatedSectionHeaderHeight = 300

        tableView.register(FeedPostCell.self)
        tableView.register(PhotosTableViewCell.self)
        return tableView
    }()
 
    // MARK: - Lifecycle
 
    override func viewDidLoad() {
        super.viewDidLoad()
 
        view.backgroundColor = AppColor.background
        title = L10n.Profile.title
        setupLogoutButton()

        setupViews()
        setupConstraints()
        bindViewModel()

        viewModel.updateState(viewInput: .viewDidLoad)
    }

    /// «гамбургер» справа сверху открывает меню с выходом из профиля
    private func setupLogoutButton() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: "line.3.horizontal"),
            style: .plain,
            target: self,
            action: #selector(logoutTapped)
        )
    }

    @objc private func logoutTapped() {
        let sheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        sheet.addAction(UIAlertAction(title: L10n.Profile.logout, style: .destructive) { [weak self] _ in
            self?.viewModel.updateState(viewInput: .logout)
        })
        sheet.addAction(UIAlertAction(title: L10n.Common.cancel, style: .cancel))
        present(sheet, animated: true)
    }

    override func viewWillTransition(
        to size: CGSize,
        with coordinator: UIViewControllerTransitionCoordinator
    ) {
        super.viewWillTransition(to: size, with: coordinator)
 
        // Раскрытый аватар позиционируется по абсолютным координатам,
        // поэтому при повороте сворачиваем его, чтобы картинка
        // не осталась за пределами экрана.
        if isAvatarExpanded {
            closeAvatarAnimation()
        }
    }
 
    // MARK: - Binding
 
    private func bindViewModel() {
        viewModel.onStateDidChange = { [weak self] state in
            DispatchQueue.main.async {
                self?.render(state: state)
            }
        }
    }
 
    /// Единственное место, где View реагирует на изменения состояния.
    private func render(state: ProfileViewModel.State) {
        switch state {
        case .loaded:
            tableView.reloadData()
        }
    }
 
    // MARK: - Setup
 
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
            closeButton.trailingAnchor.constraint(
                equalTo: view.trailingAnchor,
                constant: -AppLayout.spacing
            ),
            closeButton.widthAnchor.constraint(equalToConstant: 40),
            closeButton.heightAnchor.constraint(equalToConstant: 40)
        ])
    }
 
    // MARK: - Avatar animation
 
    /// Разворачивает аватар на весь экран с затемнением фона.
    /// Оригинал скрывается, а анимируется его копия поверх таблицы —
    /// так аватар не ограничен рамками ячейки.
    @objc private func avatarTapped() {
        guard !isAvatarExpanded, let headerView = profileHeaderView else { return }
 
        isAvatarExpanded = true
        avatarOriginalFrame = headerView.avatarImageView.convert(headerView.bounds, to: view)
        headerView.avatarImageView.isHidden = true
 
        let animatingView = UIImageView(frame: avatarOriginalFrame)
        animatingView.image = headerView.avatarImageView.image
        animatingView.contentMode = .scaleAspectFill
        animatingView.clipsToBounds = true
        animatingView.layer.cornerRadius = avatarOriginalFrame.height / 2
        animatingView.layer.borderColor = AppColor.border.cgColor
        animatingView.layer.borderWidth = 3
        view.addSubview(animatingView)
        animatingAvatarView = animatingView
 
        view.bringSubviewToFront(closeButton)
 
        let targetWidth = view.bounds.width
        let targetY = (view.bounds.height - targetWidth) / 2
        let targetFrame = CGRect(x: 0, y: targetY, width: targetWidth, height: targetWidth)
 
        UIView.animate(withDuration: 0.5, animations: {
            animatingView.frame = targetFrame
            animatingView.layer.cornerRadius = 0
            animatingView.layer.borderWidth = 0
            self.dimmedOverlay.alpha = 0.5
        }, completion: { _ in
            // Крестик появляется только после того, как аватар развернулся.
            UIView.animate(withDuration: 0.3) {
                self.closeButton.alpha = 1
            }
        })
    }
 
    /// Обратная анимация
    private func closeAvatarAnimation() {
        guard isAvatarExpanded, let animatingView = animatingAvatarView else { return }
 
        UIView.animate(withDuration: 0.1, animations: {
            self.closeButton.alpha = 0
        }, completion: { _ in
            UIView.animate(withDuration: 0.5, animations: {
                animatingView.frame = self.avatarOriginalFrame
                animatingView.layer.cornerRadius = self.avatarOriginalFrame.height / 2
                animatingView.layer.borderWidth = 3
                self.dimmedOverlay.alpha = 0
            }, completion: { _ in
                animatingView.removeFromSuperview()
                self.animatingAvatarView = nil
                self.profileHeaderView?.avatarImageView.isHidden = false
                self.isAvatarExpanded = false
            })
        })
    }
}
 
// MARK: - UITableViewDataSource
 
extension ProfileViewController: UITableViewDataSource {
 
    func numberOfSections(in tableView: UITableView) -> Int {
        2
    }
 
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0: return 1
        case 1: return viewModel.posts.count
        default: return 0
        }
    }
 
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            let cell = tableView.dequeue(PhotosTableViewCell.self, for: indexPath)
            cell.configure(with: viewModel.previewPhotos)
            return cell
 
        case 1:
            let cell = tableView.dequeue(FeedPostCell.self, for: indexPath)
            guard let post = viewModel.post(at: indexPath.row) else { return cell }
            cell.configure(with: post, isLiked: false, isSaved: viewModel.isSaved(at: indexPath.row))
            cell.onBookmark = { [weak self] in
                self?.viewModel.updateState(viewInput: .toggleSave(index: indexPath.row))
            }
            return cell
 
        default:
            return UITableViewCell()
        }
    }
}
 
// MARK: - UITableViewDelegate
 
extension ProfileViewController: UITableViewDelegate {
 
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        switch section {
        case 0:
            let headerView = ProfileHeaderView()
            headerView.configure(with: viewModel.user)
            headerView.onEdit = { [weak self] in
                self?.viewModel.updateState(viewInput: .didTapEdit)
            }
            profileHeaderView = headerView

            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(avatarTapped))
            headerView.avatarImageView.addGestureRecognizer(tapGesture)
            return headerView
        case 1:
            return makeSectionTitleHeader(L10n.Profile.myPosts)
        default:
            return nil
        }
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        UITableView.automaticDimension
    }

    /// простой заголовок секции с текстом (для «Мои записи»)
    private func makeSectionTitleHeader(_ title: String) -> UIView {
        let container = UIView()
        container.backgroundColor = AppColor.background
        let label = UILabel()
        label.text = title
        label.font = AppFont.sectionTitle
        label.textColor = AppColor.accent
        label.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(label)
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: container.topAnchor, constant: AppLayout.spacing),
            label.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: AppLayout.spacing),
            label.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -AppLayout.spacing),
            label.bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: -AppLayout.spacingSmall)
        ])
        return container
    }
 
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            viewModel.updateState(viewInput: .didTapPhotosSection)
        }
    }
}
 
// MARK: - UITableViewDragDelegate
 
extension ProfileViewController: UITableViewDragDelegate {
 
    func tableView(
        _ tableView: UITableView,
        itemsForBeginning session: any UIDragSession,
        at indexPath: IndexPath
    ) -> [UIDragItem] {
        guard indexPath.section == 1, viewModel.posts.indices.contains(indexPath.row) else {
            return []
        }
 
        let post = viewModel.posts[indexPath.row]
 
        let imageItem = UIDragItem(itemProvider: NSItemProvider(object: post.image))
        imageItem.localObject = post
 
        let textItem = UIDragItem(itemProvider: NSItemProvider(object: post.description as NSString))
 
        return [imageItem, textItem]
    }
}
 
// MARK: - UITableViewDropDelegate
 
extension ProfileViewController: UITableViewDropDelegate {
 
    func tableView(_ tableView: UITableView, canHandle session: UIDropSession) -> Bool {
        session.canLoadObjects(ofClass: UIImage.self) ||
        session.canLoadObjects(ofClass: NSString.self)
    }
 
    func tableView(
        _ tableView: UITableView,
        dropSessionDidUpdate session: UIDropSession,
        withDestinationIndexPath destinationIndexPath: IndexPath?
    ) -> UITableViewDropProposal {
        UITableViewDropProposal(operation: .copy, intent: .insertAtDestinationIndexPath)
    }
 
    func tableView(_ tableView: UITableView, performDropWith coordinator: UITableViewDropCoordinator) {
        let destination = coordinator.destinationIndexPath
            ?? IndexPath(row: viewModel.posts.count, section: 1)
 
        coordinator.session.loadObjects(ofClass: UIImage.self) { [weak self] imageItems in
            guard let self, let image = imageItems.first as? UIImage else { return }
 
            coordinator.session.loadObjects(ofClass: NSString.self) { textItems in
                let description = (textItems.first as? String) ?? ""
 
                self.viewModel.updateState(
                    viewInput: .didDropPost(
                        image: image,
                        description: description,
                        at: destination.row
                    )
                )
            }
        }
    }
}
 
