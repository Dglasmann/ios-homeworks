//
//  PostViewController.swift
//  Navigation
//
//  Created by Sasha Soldatov on 22.02.2026.
//

import UIKit

/// экран деталей поста — открывается по тапу на карточку в ленте.
/// показывает пост целиком: автор с ролью, картинка, полный текст и счётчики
final class PostViewController: UIViewController {

    private let post: PostModel

    init(post: PostModel) {
        self.post = post
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Subviews

    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()

    private lazy var contentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private lazy var avatarImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 22
        imageView.backgroundColor = AppColor.secondaryBackground
        imageView.tintColor = AppColor.secondaryText
        imageView.image = post.authorAvatar ?? UIImage(systemName: "person.circle.fill")
        return imageView
    }()

    private lazy var authorLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = AppFont.userName
        label.textColor = AppColor.primaryText
        label.text = post.author
        return label
    }()

    private lazy var roleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = AppFont.body
        label.textColor = AppColor.secondaryText
        label.text = post.authorRole
        return label
    }()

    private lazy var postImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = AppLayout.cornerRadius
        imageView.backgroundColor = AppColor.secondaryBackground
        imageView.image = post.image
        return imageView
    }()

    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = AppFont.body
        label.textColor = AppColor.primaryText
        label.numberOfLines = 0
        label.text = post.description
        return label
    }()

    private lazy var statsLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = AppFont.counter
        label.textColor = AppColor.secondaryText
        label.text = L10n.Post.stats(post.likes, post.comments, post.views)
        return label
    }()

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = AppColor.background
        title = post.author
        setupViews()
        setupConstraints()
        loadImage()
    }

    // MARK: - Setup

    private func setupViews() {
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        [avatarImageView, authorLabel, roleLabel, postImageView,
         descriptionLabel, statsLabel].forEach(contentView.addSubview)
    }

    private func setupConstraints() {
        let spacing = AppLayout.spacing
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),

            avatarImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: spacing),
            avatarImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: spacing),
            avatarImageView.widthAnchor.constraint(equalToConstant: 44),
            avatarImageView.heightAnchor.constraint(equalToConstant: 44),

            authorLabel.topAnchor.constraint(equalTo: avatarImageView.topAnchor),
            authorLabel.leadingAnchor.constraint(equalTo: avatarImageView.trailingAnchor, constant: AppLayout.spacingSmall),
            authorLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -spacing),

            roleLabel.topAnchor.constraint(equalTo: authorLabel.bottomAnchor, constant: 2),
            roleLabel.leadingAnchor.constraint(equalTo: authorLabel.leadingAnchor),
            roleLabel.trailingAnchor.constraint(equalTo: authorLabel.trailingAnchor),

            postImageView.topAnchor.constraint(equalTo: avatarImageView.bottomAnchor, constant: spacing),
            postImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: spacing),
            postImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -spacing),
            postImageView.heightAnchor.constraint(equalTo: postImageView.widthAnchor),

            descriptionLabel.topAnchor.constraint(equalTo: postImageView.bottomAnchor, constant: spacing),
            descriptionLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: spacing),
            descriptionLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -spacing),

            statsLabel.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: spacing),
            statsLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: spacing),
            statsLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -spacing),
            statsLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -spacing)
        ])
    }
    
    private func loadImage() {
        guard let url = post.imageURL else { return }
        ImageLoader.shared.load(url) { [weak self] image in
            self?.postImageView.image = image
            
        }
    }
}
