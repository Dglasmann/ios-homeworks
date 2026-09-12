//
//  ProfileHeaderComponents.swift
//  Navigation
//
//  мелкие блоки шапки профиля: колонка статистики и колонка действия
//

import UIKit

/// колонка статистики: число сверху, подпись снизу (публикации/подписки/подписчики)
final class StatColumn: UIView {

    private let valueLabel: UILabel = {
        let label = UILabel()
        label.font = AppFont.userName
        label.textAlignment = .center
        return label
    }()

    private let captionLabel: UILabel = {
        let label = UILabel()
        label.font = AppFont.body
        label.textColor = AppColor.secondaryText
        label.textAlignment = .center
        return label
    }()

    init(caption: String, accent: Bool) {
        super.init(frame: .zero)
        captionLabel.text = caption
        valueLabel.textColor = accent ? AppColor.accent : AppColor.primaryText

        let stack = UIStackView(arrangedSubviews: [valueLabel, captionLabel])
        stack.axis = .vertical
        stack.spacing = 2
        stack.translatesAutoresizingMaskIntoConstraints = false
        addSubview(stack)
        NSLayoutConstraint.activate([
            stack.topAnchor.constraint(equalTo: topAnchor),
            stack.bottomAnchor.constraint(equalTo: bottomAnchor),
            stack.leadingAnchor.constraint(equalTo: leadingAnchor),
            stack.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setValue(_ value: String) {
        valueLabel.text = value
    }
}

/// колонка действия: иконка сверху, подпись снизу (Запись/История/Фото).
/// пока визуальная — без обработки нажатия
final class ActionColumn: UIView {

    init(icon: String, title: String) {
        super.init(frame: .zero)

        let iconView = UIImageView(image: UIImage(systemName: icon))
        iconView.tintColor = AppColor.primaryText
        iconView.contentMode = .scaleAspectFit
        iconView.translatesAutoresizingMaskIntoConstraints = false
        iconView.heightAnchor.constraint(equalToConstant: 24).isActive = true

        let label = UILabel()
        label.text = title
        label.font = AppFont.body
        label.textColor = AppColor.primaryText
        label.textAlignment = .center

        let stack = UIStackView(arrangedSubviews: [iconView, label])
        stack.axis = .vertical
        stack.spacing = AppLayout.spacingSmall
        stack.alignment = .center
        stack.translatesAutoresizingMaskIntoConstraints = false
        addSubview(stack)
        NSLayoutConstraint.activate([
            stack.topAnchor.constraint(equalTo: topAnchor),
            stack.bottomAnchor.constraint(equalTo: bottomAnchor),
            stack.leadingAnchor.constraint(equalTo: leadingAnchor),
            stack.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
