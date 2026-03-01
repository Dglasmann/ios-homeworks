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
        let avatarImageView = UIImageView()
        avatarImageView.translatesAutoresizingMaskIntoConstraints = false
        avatarImageView.contentMode = .scaleAspectFill
        avatarImageView.clipsToBounds = true
        avatarImageView.image = UIImage(named: "avatar") ?? UIImage(systemName: "person.crop.circle.fill")
        avatarImageView.layer.borderColor = UIColor.white.cgColor
        avatarImageView.layer.borderWidth = 3
        avatarImageView.layer.cornerRadius = 50
        return avatarImageView
    }()

    private let fullNameLabel: UILabel = {
        let fullNameLabel = UILabel()
        fullNameLabel.translatesAutoresizingMaskIntoConstraints = false
        fullNameLabel.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        fullNameLabel.textColor = .black
        fullNameLabel.text = "Hipster Timati"
        fullNameLabel.numberOfLines = 1
        return fullNameLabel
    }()

    private let statusLabel: UILabel = {
        let statusLabel = UILabel()
        statusLabel.translatesAutoresizingMaskIntoConstraints = false
        statusLabel.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        statusLabel.textColor = .gray
        statusLabel.text = "Waiting for something..."
        statusLabel.numberOfLines = 1
        return statusLabel
    }()

    private let statusTextField: UITextField = {
        let statusTextField = UITextField()
        statusTextField.translatesAutoresizingMaskIntoConstraints = false
        statusTextField.font = UIFont.systemFont(ofSize: 15, weight: .regular)
        statusTextField.textColor = .black
        statusTextField.placeholder = "Enter status..."
        statusTextField.backgroundColor = .white
        statusTextField.layer.cornerRadius = 12
        statusTextField.layer.borderWidth = 1
        statusTextField.layer.borderColor = UIColor.black.cgColor
        statusTextField.autocapitalizationType = .sentences
        statusTextField.autocorrectionType = .default
        statusTextField.returnKeyType = .done
        statusTextField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 12, height: 0))
        statusTextField.leftViewMode = .always
        return statusTextField
    }()

    private let setStatusButton: UIButton = {
        let setStatusButton = UIButton(type: .system)
        setStatusButton.translatesAutoresizingMaskIntoConstraints = false
        setStatusButton.backgroundColor = .systemBlue
        setStatusButton.setTitle("Set status", for: .normal)
        setStatusButton.titleLabel?.font = UIFont.systemFont(ofSize: 20, weight: .regular) // задал свой размер шрифта, так как не было по макету
        setStatusButton.setTitleColor(.white, for: .normal)
        setStatusButton.layer.cornerRadius = 14 // поставил 14 вместо 4, потому что на макете сильно закруглен, а с 4 так не сделаешь
        setStatusButton.layer.shadowColor = UIColor.black.cgColor
        setStatusButton.layer.shadowOffset = CGSize(width: 4, height: 4)
        setStatusButton.layer.shadowRadius = 4
        setStatusButton.layer.shadowOpacity = 0.7
        return setStatusButton
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

    
    // MARK: - Setup
    
    private func setupViews() {
        
        backgroundColor = .clear
        
        addSubview(avatarImageView)
        addSubview(fullNameLabel)
        addSubview(statusLabel)
        addSubview(statusTextField)
        addSubview(setStatusButton)
        
        setStatusButton.addTarget(self, action: #selector(buttonPressed), for: .touchUpInside)
        statusTextField.addTarget(self, action: #selector(statusTextChanged(_:)), for: .editingChanged)
        statusTextField.addTarget(self, action: #selector(textFieldDidEndOnExit(_:)), for: .editingDidEndOnExit)
        
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
        //avatarImageView, 100x100, 16 сверху и слева
        avatarImageView.topAnchor.constraint(equalTo: topAnchor, constant: 16),
        avatarImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
        avatarImageView.widthAnchor.constraint(equalToConstant: 100),
        avatarImageView.heightAnchor.constraint(equalToConstant: 100),
        
        //fullnamelabel, справа от аватара и сверху
        fullNameLabel.topAnchor.constraint(equalTo: topAnchor, constant: 27),
        fullNameLabel.leadingAnchor.constraint(equalTo: avatarImageView.trailingAnchor, constant: 16),
        fullNameLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
        
        //statuslabel, под именем и над текстфилдом
        statusLabel.leadingAnchor.constraint(equalTo: fullNameLabel.leadingAnchor),
        statusLabel.trailingAnchor.constraint(equalTo: fullNameLabel.trailingAnchor),
        statusLabel.bottomAnchor.constraint(equalTo: statusTextField.topAnchor, constant: -8),
        
        //statustextfield, высота 40, привязал к низу аватара
        statusTextField.leadingAnchor.constraint(equalTo: fullNameLabel.leadingAnchor),
        statusTextField.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
        statusTextField.topAnchor.constraint(equalTo: avatarImageView.bottomAnchor, constant: -8),
        statusTextField.heightAnchor.constraint(equalToConstant: 40),
        
        //setstatusbutton, под текстфилдом и на всю ширину с отступами 16
        setStatusButton.topAnchor.constraint(equalTo: statusTextField.bottomAnchor, constant: 16),
        setStatusButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
        setStatusButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
        setStatusButton.heightAnchor.constraint(equalToConstant: 50)
        ])
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

  
}
