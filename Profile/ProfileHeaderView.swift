//
//  ProfileHeaderView.swift
//  Navigation
//
//  Created by Sasha Soldatov on 25.02.2026.
//

import UIKit

final class ProfileHeaderView: UIView {

    // MARK: - Subviews

    private let avatarImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.image = UIImage(named: "avatar") ?? UIImage(systemName: "person.crop.circle.fill")
        iv.layer.borderColor = UIColor.white.cgColor
        iv.layer.borderWidth = 3
        return iv
    }()

    private let nameLabel: UILabel = {
        let lbl = UILabel()
        lbl.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        lbl.textColor = .black
        lbl.text = "Hipster Timati"
        lbl.numberOfLines = 1
        return lbl
    }()

    private let statusLabel: UILabel = {
        let lbl = UILabel()
        lbl.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        lbl.textColor = .gray
        lbl.text = "Waiting for something..."
        lbl.numberOfLines = 1
        return lbl
    }()

    private let statusTextField: UITextField = {
        let tf = UITextField()
        tf.font = UIFont.systemFont(ofSize: 15, weight: .regular)
        tf.textColor = .black
        tf.placeholder = "Enter status..."
        tf.backgroundColor = .white
        tf.layer.cornerRadius = 12
        tf.layer.borderWidth = 1
        tf.layer.borderColor = UIColor.black.cgColor
        tf.autocapitalizationType = .sentences
        tf.autocorrectionType = .default
        tf.returnKeyType = .done
        tf.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 12, height: 0))
        tf.leftViewMode = .always
        return tf
    }()

    private let setStatusButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.backgroundColor = .systemBlue
        btn.setTitle("Show status", for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 20, weight: .regular) // задал свой размер шрифта, так как не было по макету
        btn.setTitleColor(.white, for: .normal)
        btn.layer.cornerRadius = 14 // поставил 14 вместо 4, потому что на макете сильно закруглен, а с 4 так не сделаешь
        btn.layer.shadowColor = UIColor.black.cgColor
        btn.layer.shadowOffset = CGSize(width: 4, height: 4)
        btn.layer.shadowRadius = 4
        btn.layer.shadowOpacity = 0.7
        return btn
    }()

    // MARK: - State

    private var statusText: String = ""
    private var isEditingStatus: Bool = false

    // MARK: - Layout constants

    private let avatarSize: CGFloat = 120
    private let sideInset: CGFloat = 16
    private let avatarTopOffset: CGFloat = 16  // взял avatar.top = safeTop + 16
    private let nameTopOffset: CGFloat = 27  // взял name.top = safeTop + 27
    private let buttonTopFromAvatar: CGFloat = 16 // правило button.top >= avatar.bottom + 16
    private let buttonTopFromStatus: CGFloat = 34 // правило button.top >= statusLabel.bottom + 34
    private let buttonHeight: CGFloat = 50 // высота кнопки
    private let tfHeight: CGFloat = 40 // высота текстфилда

    // MARK: - Init

    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }

    private func commonInit() {
        backgroundColor = .clear

        addSubview(avatarImageView)
        addSubview(nameLabel)
        addSubview(statusLabel)
        addSubview(statusTextField)
        addSubview(setStatusButton)

        statusTextField.isHidden = true
        statusTextField.alpha = 0

        setStatusButton.addTarget(self, action: #selector(buttonPressed), for: .touchUpInside)
        statusTextField.addTarget(self, action: #selector(statusTextChanged(_:)), for: .editingChanged)
        statusTextField.addTarget(self, action: #selector(textFieldDidEndOnExit(_:)), for: .editingDidEndOnExit)
    }

    // MARK: - Actions

    @objc private func buttonPressed() {
        if !isEditingStatus {
            isEditingStatus = true
            statusTextField.isHidden = false
            setStatusButton.setTitle("Set status", for: .normal)
            statusTextField.becomeFirstResponder()
            statusTextField.placeholder = statusLabel.text

            // а
            UIView.animate(withDuration: 0.25) {
                self.statusTextField.alpha = 1
                self.setNeedsLayout()
                self.layoutIfNeeded()
            }
        } else {
            let trimmed = statusText.trimmingCharacters(in: .whitespacesAndNewlines)
            guard !trimmed.isEmpty else { return }

            statusLabel.text = trimmed
            statusTextField.text = ""
            statusText = ""
            statusTextField.resignFirstResponder()
            isEditingStatus = false
            setStatusButton.setTitle("Show status", for: .normal)

            //и тут небольшая анимация
            UIView.animate(withDuration: 0.25, animations: {
                self.statusTextField.alpha = 0
                self.setNeedsLayout()
                self.layoutIfNeeded()
            }, completion: { _ in
                self.statusTextField.isHidden = true
            })
        }
    }

    @objc private func statusTextChanged(_ textField: UITextField) {
        statusText = textField.text ?? ""
    }

    @objc private func textFieldDidEndOnExit(_ sender: UITextField) {
        sender.resignFirstResponder()
    }

    // MARK: - Layout

    override func layoutSubviews() {
        super.layoutSubviews()

        let w = bounds.width
        let safeTop: CGFloat = superview?.safeAreaInsets.top ?? 0

        // аватар
        let avatarY = safeTop + avatarTopOffset
        avatarImageView.frame = CGRect(x: sideInset, y: avatarY, width: avatarSize, height: avatarSize)
        avatarImageView.layer.cornerRadius = avatarSize / 2

        // правая часть от аватара
        let rightX = avatarImageView.frame.maxX + sideInset
        let rightW = w - rightX - sideInset

        // лейбл name
        let nameH = nameLabel.sizeThatFits(CGSize(width: rightW, height: .greatestFiniteMagnitude)).height
        nameLabel.frame = CGRect(x: rightX, y: safeTop + nameTopOffset, width: rightW, height: nameH)

        // для кнопки
        let collapsedButtonY = avatarImageView.frame.maxY + buttonTopFromAvatar

        // для лейбла status
        let statusH = statusLabel.sizeThatFits(CGSize(width: rightW, height: .greatestFiniteMagnitude)).height
        let statusY = collapsedButtonY - buttonTopFromStatus - statusH
        statusLabel.frame = CGRect(x: rightX, y: statusY, width: rightW, height: statusH)

        // textfield
        let tfY = statusLabel.frame.maxY + 8
        statusTextField.frame = CGRect(x: rightX, y: tfY, width: rightW, height: tfHeight)

        // чтобы кнопка сдвигалась при появлении textfield
        let buttonY: CGFloat
        if isEditingStatus {
            buttonY = statusTextField.frame.maxY + 8
        } else {
            buttonY = collapsedButtonY
        }

        let btnW = w - 2 * sideInset
        setStatusButton.frame = CGRect(x: sideInset, y: buttonY, width: btnW, height: buttonHeight)
    }
}
