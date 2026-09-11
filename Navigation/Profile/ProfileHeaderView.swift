import UIKit
 
final class ProfileHeaderView: UIView {
 
    // MARK: - Subviews

    let avatarImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.image = UIImage(named: "avatar") ?? UIImage(systemName: "person.crop.circle.fill")
        imageView.layer.borderColor = AppColor.border.cgColor
        imageView.layer.borderWidth = 3
        imageView.layer.cornerRadius = AppLayout.avatarSize / 2
        imageView.isUserInteractionEnabled = true
        return imageView
    }()
 
    private let timerLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = AppFont.caption
        label.textColor = AppColor.primaryText
        label.textAlignment = .center
        label.layer.cornerRadius = AppLayout.spacingSmall
        label.clipsToBounds = true
        label.text = L10n.Profile.sessionTime("00:00")
        return label
    }()
 
    private let fullNameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = AppFont.userName
        label.textColor = AppColor.primaryText
        // Значение приходит из configure(with:)
        label.numberOfLines = 0
        return label
    }()
 
    private let statusLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = AppFont.body
        label.textColor = AppColor.secondaryText
        label.numberOfLines = 0
        return label
    }()
 
    private let statusTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.font = AppFont.textField
        textField.textColor = AppColor.primaryText
        textField.placeholder = L10n.Profile.statusPlaceholder
        textField.backgroundColor = AppColor.secondaryBackground
        textField.layer.cornerRadius = AppLayout.cornerRadius
        textField.layer.borderWidth = 1
        textField.layer.borderColor = AppColor.border.cgColor
        textField.autocapitalizationType = .sentences
        textField.autocorrectionType = .default
        textField.returnKeyType = .done
        textField.leftView = UIView(
            frame: CGRect(x: 0, y: 0, width: AppLayout.spacingSmall + 4, height: 0)
        )
        textField.leftViewMode = .always
        return textField
    }()
 
    private lazy var setStatusButton: CustomButton = {
        let button = CustomButton(
            title: L10n.Profile.setStatus,
            backgroundColor: AppColor.accent,
            cornerRadius: AppLayout.cornerRadius,
            tapAction: { [weak self] in self?.buttonPressed() }
        )
        button.layer.shadowColor = AppColor.primaryText.cgColor
        button.layer.shadowOffset = CGSize(width: 4, height: 4)
        button.layer.shadowRadius = 4
        button.layer.shadowOpacity = 0.7
        button.clipsToBounds = false
        return button
    }()
 
    // MARK: - State
 
    private var statusText: String = ""
 
    // MARK: - Init
 
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        setupConstraints()
    }
 
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupViews()
        setupConstraints()
    }
 
    // MARK: - Trait changes
 
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
 
        guard traitCollection.hasDifferentColorAppearance(comparedTo: previousTraitCollection) else {
            return
        }
        updateLayerColors()
    }
 
    private func updateLayerColors() {
        avatarImageView.layer.borderColor = AppColor.border.cgColor
        statusTextField.layer.borderColor = AppColor.border.cgColor
        setStatusButton.layer.shadowColor = AppColor.primaryText.cgColor
    }
 
    // MARK: - Setup
 
    private func setupViews() {
        backgroundColor = .clear
 
        addSubview(avatarImageView)
        addSubview(fullNameLabel)
        addSubview(statusLabel)
        addSubview(statusTextField)
        addSubview(setStatusButton)
        addSubview(timerLabel)
 
        statusTextField.addTarget(
            self,
            action: #selector(statusTextChanged(_:)),
            for: .editingChanged
        )
        statusTextField.addTarget(
            self,
            action: #selector(textFieldDidEndOnExit(_:)),
            for: .editingDidEndOnExit
        )
 
        updateLayerColors()
    }
 
    private func setupConstraints() {
        // Нижняя привязка кнопки замыкает вертикальную цепочку —
        // без неё UITableView.automaticDimension схлопнет шапку в ноль.
        // Приоритет 999, чтобы не конфликтовать с системными констрейнтами
        // на первом проходе разметки.
        let bottomConstraint = setStatusButton.bottomAnchor.constraint(
            equalTo: bottomAnchor,
            constant: -AppLayout.spacing
        )
        bottomConstraint.priority = UILayoutPriority(999)

        NSLayoutConstraint.activate(
            avatarAndNameConstraints()
            + statusConstraints()
            + buttonConstraints()
            + [bottomConstraint]
        )
    }

    private func avatarAndNameConstraints() -> [NSLayoutConstraint] {
        [
            // Аватар: квадрат avatarSize в левом верхнем углу
            avatarImageView.topAnchor.constraint(equalTo: topAnchor, constant: AppLayout.spacing),
            avatarImageView.leadingAnchor.constraint(
                equalTo: leadingAnchor,
                constant: AppLayout.spacing
            ),
            avatarImageView.widthAnchor.constraint(equalToConstant: AppLayout.avatarSize),
            avatarImageView.heightAnchor.constraint(equalToConstant: AppLayout.avatarSize),

            // Имя пользователя справа от аватара
            fullNameLabel.topAnchor.constraint(equalTo: topAnchor, constant: 27),
            fullNameLabel.leadingAnchor.constraint(
                equalTo: avatarImageView.trailingAnchor,
                constant: AppLayout.spacing
            ),
            fullNameLabel.trailingAnchor.constraint(
                equalTo: trailingAnchor,
                constant: -AppLayout.spacing
            ),

            // Таймер сессии под именем
            timerLabel.topAnchor.constraint(
                equalTo: fullNameLabel.bottomAnchor,
                constant: AppLayout.spacingSmall
            ),
            timerLabel.leadingAnchor.constraint(
                equalTo: avatarImageView.trailingAnchor,
                constant: AppLayout.spacing
            ),
            timerLabel.trailingAnchor.constraint(
                lessThanOrEqualTo: trailingAnchor,
                constant: -AppLayout.spacing
            )
        ]
    }

    private func statusConstraints() -> [NSLayoutConstraint] {
        [
            // Статус — над полем ввода
            statusLabel.topAnchor.constraint(
                greaterThanOrEqualTo: timerLabel.bottomAnchor,
                constant: AppLayout.spacingSmall
            ),
            statusLabel.leadingAnchor.constraint(equalTo: fullNameLabel.leadingAnchor),
            statusLabel.trailingAnchor.constraint(equalTo: fullNameLabel.trailingAnchor),
            statusLabel.bottomAnchor.constraint(
                equalTo: statusTextField.topAnchor,
                constant: -AppLayout.spacingSmall
            ),

            // Поле ввода статуса
            statusTextField.leadingAnchor.constraint(equalTo: fullNameLabel.leadingAnchor),
            statusTextField.trailingAnchor.constraint(
                equalTo: trailingAnchor,
                constant: -AppLayout.spacing
            ),
            statusTextField.topAnchor.constraint(
                equalTo: avatarImageView.bottomAnchor,
                constant: -AppLayout.spacingSmall
            ),
            statusTextField.heightAnchor.constraint(equalToConstant: 40)
        ]
    }

    private func buttonConstraints() -> [NSLayoutConstraint] {
        [
            // Кнопка сохранения статуса на всю ширину
            setStatusButton.topAnchor.constraint(
                equalTo: statusTextField.bottomAnchor,
                constant: AppLayout.spacing
            ),
            setStatusButton.leadingAnchor.constraint(
                equalTo: leadingAnchor,
                constant: AppLayout.spacing
            ),
            setStatusButton.trailingAnchor.constraint(
                equalTo: trailingAnchor,
                constant: -AppLayout.spacing
            ),
            setStatusButton.heightAnchor.constraint(equalToConstant: AppLayout.controlHeight)
        ]
    }
 
    // MARK: - Actions

    @objc private func buttonPressed() {
        let trimmed = statusText.trimmingCharacters(in: .whitespacesAndNewlines)
        if !trimmed.isEmpty {
            statusLabel.text = trimmed
        }
        statusTextField.text = ""
        statusText = ""
        statusTextField.resignFirstResponder()
    }
 
    @objc private func statusTextChanged(_ textField: UITextField) {
        statusText = textField.text ?? ""
    }
 
    @objc private func textFieldDidEndOnExit(_ sender: UITextField) {
        sender.resignFirstResponder()
    }
 
    // MARK: - Public
 
    func configure(with user: User) {
        avatarImageView.image = user.avatar
        fullNameLabel.text = user.fullName
        statusLabel.text = user.status
    }
 
    func setTimerText(_ text: String) {
        timerLabel.text = text
    }
}
