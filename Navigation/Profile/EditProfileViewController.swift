//
//  EditProfileViewController.swift
//  Navigation
//
//  экран редактирования профиля: имя, профессия, статус.
//  по «Сохранить» отдаёт новые значения через onSave
//

import UIKit

final class EditProfileViewController: UIViewController {

    /// колбэк с новыми значениями: имя, профессия, статус
    var onSave: ((String, String, String) -> Void)?

    private let user: User

    init(user: User) {
        self.user = user
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Subviews

    private lazy var nameField = makeField(placeholder: L10n.Profile.namePlaceholder, text: user.fullName)
    private lazy var professionField = makeField(placeholder: L10n.Profile.professionPlaceholder, text: user.profession)
    private lazy var statusField = makeField(placeholder: L10n.Profile.statusPlaceholder, text: user.status)

    private lazy var saveButton = CustomButton(
        title: L10n.Profile.save,
        backgroundColor: AppColor.accent,
        cornerRadius: AppLayout.cornerRadius,
        tapAction: { [weak self] in self?.saveTapped() }
    )

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = AppColor.background
        title = L10n.Profile.editTitle

        let stack = UIStackView(arrangedSubviews: [nameField, professionField, statusField, saveButton])
        stack.axis = .vertical
        stack.spacing = AppLayout.spacing
        stack.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(stack)

        NSLayoutConstraint.activate([
            stack.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: AppLayout.spacingLarge),
            stack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: AppLayout.spacing),
            stack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -AppLayout.spacing),
            nameField.heightAnchor.constraint(equalToConstant: AppLayout.controlHeight),
            professionField.heightAnchor.constraint(equalToConstant: AppLayout.controlHeight),
            statusField.heightAnchor.constraint(equalToConstant: AppLayout.controlHeight),
            saveButton.heightAnchor.constraint(equalToConstant: AppLayout.controlHeight)
        ])
    }

    // MARK: - Actions

    private func saveTapped() {
        onSave?(
            nameField.text ?? user.fullName,
            professionField.text ?? user.profession,
            statusField.text ?? user.status
        )
        navigationController?.popViewController(animated: true)
    }

    private func makeField(placeholder: String, text: String) -> UITextField {
        let field = UITextField()
        field.placeholder = placeholder
        field.text = text
        field.font = AppFont.textField
        field.textColor = AppColor.primaryText
        field.backgroundColor = AppColor.secondaryBackground
        field.layer.cornerRadius = AppLayout.cornerRadius
        field.layer.borderWidth = AppLayout.separatorHeight
        field.layer.borderColor = AppColor.border.cgColor
        field.leftView = UIView(frame: CGRect(x: 0, y: 0, width: AppLayout.spacing, height: 0))
        field.leftViewMode = .always
        field.clearButtonMode = .whileEditing
        return field
    }
}
