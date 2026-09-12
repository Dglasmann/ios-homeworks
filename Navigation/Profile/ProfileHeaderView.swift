//
//  ProfileHeaderView.swift
//  Navigation
//
//  шапка профиля по макету: аватар, имя с профессией, «Подробная
//  информация», кнопка «Редактировать», статистика и ряд действий
//

import UIKit

final class ProfileHeaderView: UIView {

    /// нажатие на «Редактировать»
    var onEdit: (() -> Void)?

    /// счётчики форматируются с разделением тысяч под текущую локаль
    private static let numberFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        return formatter
    }()

    // MARK: - Subviews

    let avatarImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 36
        imageView.layer.borderColor = AppColor.border.cgColor
        imageView.layer.borderWidth = 2
        imageView.isUserInteractionEnabled = true
        return imageView
    }()

    private let nameLabel = ProfileHeaderView.makeLabel(font: AppFont.postAuthor, color: AppColor.primaryText)
    private let roleLabel = ProfileHeaderView.makeLabel(font: AppFont.body, color: AppColor.secondaryText)

    private let detailsLabel = ProfileHeaderView.makeLabel(font: AppFont.body, color: AppColor.secondaryText)

    private lazy var editButton = CustomButton(
        title: L10n.Profile.edit,
        backgroundColor: AppColor.accent,
        cornerRadius: AppLayout.cornerRadius,
        tapAction: { [weak self] in self?.onEdit?() }
    )

    private let publicationsColumn = StatColumn(caption: L10n.Profile.publications, accent: true)
    private let subscriptionsColumn = StatColumn(caption: L10n.Profile.subscriptions, accent: false)
    private let subscribersColumn = StatColumn(caption: L10n.Profile.subscribers, accent: false)

    // MARK: - Init

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupLayout()
    }

    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        guard traitCollection.hasDifferentColorAppearance(comparedTo: previousTraitCollection) else { return }
        avatarImageView.layer.borderColor = AppColor.border.cgColor
    }

    // MARK: - Layout

    private func setupLayout() {
        backgroundColor = .clear

        let nameStack = UIStackView(arrangedSubviews: [nameLabel, roleLabel, detailsRow()])
        nameStack.axis = .vertical
        nameStack.spacing = 2

        let headerRow = UIStackView(arrangedSubviews: [avatarImageView, nameStack])
        headerRow.axis = .horizontal
        headerRow.spacing = AppLayout.spacing
        headerRow.alignment = .center

        let statsRow = UIStackView(arrangedSubviews: [publicationsColumn, subscriptionsColumn, subscribersColumn])
        statsRow.axis = .horizontal
        statsRow.distribution = .fillEqually

        let actionsRow = UIStackView(arrangedSubviews: [
            ActionColumn(icon: "square.and.pencil", title: L10n.Profile.actionPost),
            ActionColumn(icon: "camera", title: L10n.Profile.actionStory),
            ActionColumn(icon: "photo", title: L10n.Profile.actionPhoto)
        ])
        actionsRow.axis = .horizontal
        actionsRow.distribution = .fillEqually

        let mainStack = UIStackView(arrangedSubviews: [headerRow, editButton, statsRow, actionsRow])
        mainStack.axis = .vertical
        mainStack.spacing = AppLayout.spacing
        mainStack.translatesAutoresizingMaskIntoConstraints = false
        addSubview(mainStack)

        NSLayoutConstraint.activate([
            avatarImageView.widthAnchor.constraint(equalToConstant: 72),
            avatarImageView.heightAnchor.constraint(equalToConstant: 72),
            editButton.heightAnchor.constraint(equalToConstant: AppLayout.controlHeight),

            mainStack.topAnchor.constraint(equalTo: topAnchor, constant: AppLayout.spacing),
            mainStack.leadingAnchor.constraint(equalTo: leadingAnchor, constant: AppLayout.spacing),
            mainStack.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -AppLayout.spacing),
            mainStack.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -AppLayout.spacing)
        ])
    }

    /// строка «⚠ Подробная информация» под именем
    private func detailsRow() -> UIView {
        let icon = UIImageView(image: UIImage(systemName: "exclamationmark.circle"))
        icon.tintColor = AppColor.accent
        icon.setContentHuggingPriority(.required, for: .horizontal)
        let row = UIStackView(arrangedSubviews: [icon, detailsLabel])
        row.axis = .horizontal
        row.spacing = 4
        row.alignment = .center
        detailsLabel.text = L10n.Profile.details
        return row
    }

    // MARK: - Configure

    func configure(with user: User) {
        avatarImageView.image = user.avatar
        nameLabel.text = user.fullName
        roleLabel.text = user.profession
        publicationsColumn.setValue(Self.format(user.posts))
        subscriptionsColumn.setValue(Self.format(user.subscriptions))
        subscribersColumn.setValue(Self.format(user.subscribers))
    }

    private static func format(_ value: Int) -> String {
        numberFormatter.string(from: NSNumber(value: value)) ?? "\(value)"
    }

    private static func makeLabel(font: UIFont, color: UIColor) -> UILabel {
        let label = UILabel()
        label.font = font
        label.textColor = color
        label.numberOfLines = 0
        return label
    }
}
