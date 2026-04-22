//
//  ProfileHeaderView.swift
//  Navigation
//
//  Created by Sasha Soldatov on 25.02.2026.
//

import UIKit
import SnapKit

final class ProfileHeaderView: UIView {

    // MARK: - Subviews

    let avatarImageView: UIImageView = {
        let avatarImageView = UIImageView()
        avatarImageView.contentMode = .scaleAspectFill
        avatarImageView.clipsToBounds = true
        avatarImageView.image = UIImage(named: "avatar") ?? UIImage(systemName: "person.crop.circle.fill")
        avatarImageView.layer.borderColor = UIColor.white.cgColor
        avatarImageView.layer.borderWidth = 3
        avatarImageView.layer.cornerRadius = 50
        avatarImageView.isUserInteractionEnabled = true
        return avatarImageView
    }()

    private let fullNameLabel: UILabel = {
        let fullNameLabel = UILabel()
        fullNameLabel.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        fullNameLabel.textColor = .black
        fullNameLabel.text = "Hipster Timati"
        fullNameLabel.numberOfLines = 1
        return fullNameLabel
    }()

    private let statusLabel: UILabel = {
        let statusLabel = UILabel()
        statusLabel.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        statusLabel.textColor = .gray
        statusLabel.text = "Waiting for something..."
        statusLabel.numberOfLines = 1
        return statusLabel
    }()

    private let statusTextField: UITextField = {
        let statusTextField = UITextField()
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
        
        avatarImageView.snp.makeConstraints { (make) -> Void in
            make.top.equalToSuperview().offset(16)
            make.leading.equalToSuperview().offset(16)
            make.width.height.equalTo(100)
        }
        
        fullNameLabel.snp.makeConstraints { (make) -> Void in
            make.top.equalToSuperview().offset(27)
            make.leading.equalTo(avatarImageView.snp.trailing).offset(16)
            make.trailing.equalToSuperview().offset(-16)
        }
        
        statusLabel.snp.makeConstraints{ (make) -> Void in
            make.leading.equalTo(fullNameLabel.snp.leading)
            make.trailing.equalTo(fullNameLabel.snp.trailing)
            make.bottom.equalTo(statusTextField.snp.top).offset(-8)
        }
        
        statusTextField.snp.makeConstraints { (make) -> Void in
            make.leading.equalTo(fullNameLabel.snp.leading)
            make.trailing.equalToSuperview().offset(-16)
            make.top.equalTo(avatarImageView.snp.bottom).offset(8)
            make.height.equalTo(40)
        }
        
        setStatusButton.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(statusTextField.snp.bottom).offset(16)
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().offset(-16)
            make.height.equalTo(50)
        }
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
