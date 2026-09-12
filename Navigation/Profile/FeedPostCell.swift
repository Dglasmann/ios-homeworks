//
//  FeedPostCell.swift
//  Navigation
//
//  карточка поста в стиле соцсети: аватар, автор с ролью, текст,
//  картинка и строка действий (лайк / комментарии / сохранить).
//  переиспользуется и в ленте «Главной», и в профиле («Мои записи»)
//

import UIKit

final class FeedPostCell: UITableViewCell {

    // MARK: - Callbacks

    /// нажатие на сердечко — визуальное переключение лайка
    var onLike: (() -> Void)?
    /// нажатие на закладку — сохранить/убрать из «Сохранённого»
    var onBookmark: (() -> Void)?

    // MARK: - Subviews

    private let avatarImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 22
        imageView.backgroundColor = AppColor.secondaryBackground
        imageView.tintColor = AppColor.secondaryText
        return imageView
    }()

    private let authorLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = AppFont.userName
        label.textColor = AppColor.primaryText
        return label
    }()

    private let roleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = AppFont.body
        label.textColor = AppColor.secondaryText
        return label
    }()

    private lazy var menuButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(systemName: "ellipsis"), for: .normal)
        button.tintColor = AppColor.secondaryText
        return button
    }()

    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = AppFont.body
        label.textColor = AppColor.primaryText
        label.numberOfLines = 0
        return label
    }()

    private let postImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = AppLayout.cornerRadius
        imageView.backgroundColor = AppColor.secondaryBackground
        return imageView
    }()

    private lazy var likeButton = makeActionButton(systemName: "heart")
    private lazy var commentButton = makeActionButton(systemName: "bubble.right")
    private lazy var bookmarkButton = makeActionButton(systemName: "bookmark")

    private let likeCountLabel = FeedPostCell.makeCountLabel()
    private let commentCountLabel = FeedPostCell.makeCountLabel()

    private var isLiked = false

    // MARK: - Init

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
        setupConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        onLike = nil
        onBookmark = nil
    }

    // MARK: - Configure

    func configure(with post: PostModel, isLiked: Bool, isSaved: Bool) {
        avatarImageView.image = post.authorAvatar ?? UIImage(systemName: "person.circle.fill")
        authorLabel.text = post.author
        roleLabel.text = post.authorRole
        descriptionLabel.text = post.description
        postImageView.image = post.image
        commentCountLabel.text = "\(post.comments)"

        self.isLiked = isLiked
        likeCountLabel.text = "\(post.likes + (isLiked ? 1 : 0))"
        updateLikeAppearance()
        updateBookmarkAppearance(isSaved: isSaved)
    }

    // MARK: - Setup

    private func setupViews() {
        selectionStyle = .none
        [avatarImageView, authorLabel, roleLabel, menuButton, descriptionLabel,
         postImageView, likeButton, likeCountLabel, commentButton, commentCountLabel,
         bookmarkButton].forEach(contentView.addSubview)

        likeButton.addTarget(self, action: #selector(likeTapped), for: .touchUpInside)
        bookmarkButton.addTarget(self, action: #selector(bookmarkTapped), for: .touchUpInside)
    }

    private func setupConstraints() {
        let spacing = AppLayout.spacing
        NSLayoutConstraint.activate([
            avatarImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: spacing),
            avatarImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: spacing),
            avatarImageView.widthAnchor.constraint(equalToConstant: 44),
            avatarImageView.heightAnchor.constraint(equalToConstant: 44),

            authorLabel.topAnchor.constraint(equalTo: avatarImageView.topAnchor),
            authorLabel.leadingAnchor.constraint(equalTo: avatarImageView.trailingAnchor, constant: AppLayout.spacingSmall),
            authorLabel.trailingAnchor.constraint(lessThanOrEqualTo: menuButton.leadingAnchor, constant: -AppLayout.spacingSmall),

            roleLabel.topAnchor.constraint(equalTo: authorLabel.bottomAnchor, constant: 2),
            roleLabel.leadingAnchor.constraint(equalTo: authorLabel.leadingAnchor),
            roleLabel.trailingAnchor.constraint(equalTo: authorLabel.trailingAnchor),

            menuButton.centerYAnchor.constraint(equalTo: avatarImageView.centerYAnchor),
            menuButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -spacing),
            menuButton.widthAnchor.constraint(equalToConstant: 24),

            descriptionLabel.topAnchor.constraint(equalTo: avatarImageView.bottomAnchor, constant: spacing),
            descriptionLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: spacing),
            descriptionLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -spacing),

            postImageView.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: AppLayout.spacingSmall),
            postImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: spacing),
            postImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -spacing),
            postImageView.heightAnchor.constraint(equalToConstant: 240),

            likeButton.topAnchor.constraint(equalTo: postImageView.bottomAnchor, constant: AppLayout.spacingSmall),
            likeButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: spacing),
            likeButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -spacing),

            likeCountLabel.centerYAnchor.constraint(equalTo: likeButton.centerYAnchor),
            likeCountLabel.leadingAnchor.constraint(equalTo: likeButton.trailingAnchor, constant: 4),

            commentButton.centerYAnchor.constraint(equalTo: likeButton.centerYAnchor),
            commentButton.leadingAnchor.constraint(equalTo: likeCountLabel.trailingAnchor, constant: spacing),

            commentCountLabel.centerYAnchor.constraint(equalTo: likeButton.centerYAnchor),
            commentCountLabel.leadingAnchor.constraint(equalTo: commentButton.trailingAnchor, constant: 4),

            bookmarkButton.centerYAnchor.constraint(equalTo: likeButton.centerYAnchor),
            bookmarkButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -spacing)
        ])
    }

    // MARK: - Actions

    @objc private func likeTapped() {
        isLiked.toggle()
        let base = Int(likeCountLabel.text ?? "0") ?? 0
        likeCountLabel.text = "\(base + (isLiked ? 1 : -1))"
        updateLikeAppearance()
        onLike?()
    }

    @objc private func bookmarkTapped() {
        onBookmark?()
    }

    private func updateLikeAppearance() {
        likeButton.setImage(UIImage(systemName: isLiked ? "heart.fill" : "heart"), for: .normal)
        likeButton.tintColor = isLiked ? .systemRed : AppColor.secondaryText
    }

    private func updateBookmarkAppearance(isSaved: Bool) {
        bookmarkButton.setImage(UIImage(systemName: isSaved ? "bookmark.fill" : "bookmark"), for: .normal)
        bookmarkButton.tintColor = isSaved ? AppColor.accent : AppColor.secondaryText
    }

    // MARK: - Factories

    private func makeActionButton(systemName: String) -> UIButton {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(systemName: systemName), for: .normal)
        button.tintColor = AppColor.secondaryText
        return button
    }

    private static func makeCountLabel() -> UILabel {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = AppFont.counter
        label.textColor = AppColor.secondaryText
        return label
    }
}
