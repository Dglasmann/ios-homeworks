//
//  LoginViewController.swift
//  Navigation
//
//  Created by Sasha Soldatov on 07.03.2026.
//

import UIKit
import FirebaseAuth
import LocalAuthentication

final class LoginViewController: UIViewController {
 
    // MARK: - Dependencies
 
    private let viewModel: LoginViewModel
 
    // MARK: - Init
 
    init(viewModel: LoginViewModel) {
        self.viewModel = viewModel
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
        let contentView = UIView()
        contentView.translatesAutoresizingMaskIntoConstraints = false
        return contentView
    }()
 
    /// Логотип ВКонтакте, по центру горизонтально.
    private lazy var logoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(named: "logo")
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
 
    private lazy var emailTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = L10n.Login.emailPlaceholder
        textField.font = AppFont.textField
        textField.textColor = AppColor.primaryText
        textField.tintColor = AppColor.accent
        textField.autocapitalizationType = .none
        textField.autocorrectionType = .no
        textField.keyboardType = .emailAddress
        textField.returnKeyType = .next
        textField.delegate = self
        textField.backgroundColor = .clear
        textField.leftView = UIView(
            frame: CGRect(x: 0, y: 0, width: AppLayout.spacing, height: 0)
        )
        textField.leftViewMode = .always
        return textField
    }()
 
    private lazy var passwordTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = L10n.Login.passwordPlaceholder
        textField.font = AppFont.textField
        textField.textColor = AppColor.primaryText
        textField.tintColor = AppColor.accent
        textField.autocapitalizationType = .none
        textField.autocorrectionType = .no
        textField.isSecureTextEntry = true
        textField.returnKeyType = .done
        textField.delegate = self
        textField.backgroundColor = .clear
        textField.leftView = UIView(
            frame: CGRect(x: 0, y: 0, width: AppLayout.spacing, height: 0)
        )
        textField.leftViewMode = .always
        return textField
    }()
 
    /// Разделитель между полями ввода
    private lazy var separator: UIView = {
        let separator = UIView()
        separator.translatesAutoresizingMaskIntoConstraints = false
        separator.backgroundColor = AppColor.separator
        return separator
    }()
 
    /// Контейнер для двух полей ввода и разделителя
    private lazy var textFieldsContainer: UIView = {
        let container = UIView()
        container.translatesAutoresizingMaskIntoConstraints = false
        container.backgroundColor = AppColor.secondaryBackground
        container.layer.borderColor = AppColor.border.cgColor
        container.layer.borderWidth = AppLayout.separatorHeight
        container.layer.cornerRadius = AppLayout.cornerRadius
        container.clipsToBounds = true
        return container
    }()
 
    private lazy var logInButton: CustomButton = {
        let button = CustomButton(
            title: L10n.Login.logIn,
            backgroundColor: AppColor.buttonBackground,
            tapAction: { [weak self] in self?.logInButtonPressed() }
        )
 
        // Разные состояния кнопки различаются прозрачностью
        if let bluePixel = UIImage(named: "blue_pixel") {
            button.setBackgroundImage(bluePixel, for: .normal)
            button.setBackgroundImage(bluePixel.withAlpha(0.8), for: .selected)
            button.setBackgroundImage(bluePixel.withAlpha(0.8), for: .highlighted)
            button.setBackgroundImage(bluePixel.withAlpha(0.8), for: .disabled)
        }
        return button
    }()
 
    private lazy var biometricButton: CustomButton = {
        CustomButton(
            title: L10n.Login.biometry,
            backgroundColor: .systemGray,
            tapAction: { [weak self] in self?.biometricButtonPressed() }
        )
    }()
 
    private lazy var activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .medium)
        indicator.translatesAutoresizingMaskIntoConstraints = false
        indicator.hidesWhenStopped = true
        indicator.color = AppColor.textOnAccent
        return indicator
    }()
 
    // MARK: - Lifecycle
 
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = AppColor.background
        navigationController?.navigationBar.isHidden = true
 
        setupViews()
        setupConstraints()
        setupGestures()
        bindViewModel()
    }
 
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = true
 
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillShow),
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillHide),
            name: UIResponder.keyboardWillHideNotification,
            object: nil
        )
    }
 
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
 
        NotificationCenter.default.removeObserver(
            self,
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )
        NotificationCenter.default.removeObserver(
            self,
            name: UIResponder.keyboardWillHideNotification,
            object: nil
        )
    }
 
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
 
        guard traitCollection.hasDifferentColorAppearance(comparedTo: previousTraitCollection) else {
            return
        }
        textFieldsContainer.layer.borderColor = AppColor.border.cgColor
    }
 
    // MARK: - Binding
 
    private func bindViewModel() {
        viewModel.onStateDidChange = { [weak self] state in
            DispatchQueue.main.async {
                self?.render(state: state)
            }
        }
    }
 
    /// Единственное место, где View реагирует на изменения состояния
    private func render(state: LoginViewModel.State) {
        switch state {
        case .idle:
            activityIndicator.stopAnimating()
            logInButton.isEnabled = true
 
        case .loading:
            activityIndicator.startAnimating()
            logInButton.isEnabled = false
 
        case .success(let login):
            activityIndicator.stopAnimating()
            logInButton.isEnabled = true
            viewModel.didFinishLogin(with: login)
 
        case .failure(let message):
            activityIndicator.stopAnimating()
            logInButton.isEnabled = true
            showAlert(message: message)
        }
    }
 
    // MARK: - Setup
 
    private func setupViews() {
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
 
        contentView.addSubview(logoImageView)
        contentView.addSubview(textFieldsContainer)
        contentView.addSubview(logInButton)
        contentView.addSubview(biometricButton)
 
        textFieldsContainer.addSubview(emailTextField)
        textFieldsContainer.addSubview(separator)
        textFieldsContainer.addSubview(passwordTextField)
 
        logInButton.addSubview(activityIndicator)
 
        setupBiometricButton()
    }
 
    private func setupBiometricButton() {
        switch viewModel.biometryType {
        case .faceID:
            biometricButton.setImage(UIImage(systemName: "faceid"), for: .normal)
            biometricButton.isHidden = false
        case .touchID:
            biometricButton.setImage(UIImage(systemName: "touchid"), for: .normal)
            biometricButton.isHidden = false
        case .none:
            biometricButton.isHidden = true
        }
    }
 
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            // ScrollView на весь экран
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
 
            // ContentView определяет прокручиваемую область
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
 
            // Логотип
            logoImageView.topAnchor.constraint(
                equalTo: contentView.topAnchor,
                constant: AppLayout.spacingLarge
            ),
            logoImageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            logoImageView.widthAnchor.constraint(equalToConstant: AppLayout.avatarSize),
            logoImageView.heightAnchor.constraint(equalToConstant: AppLayout.avatarSize),
 
            // Контейнер полей ввода
            textFieldsContainer.topAnchor.constraint(
                equalTo: logoImageView.bottomAnchor,
                constant: AppLayout.spacingLarge
            ),
 
            emailTextField.topAnchor.constraint(equalTo: textFieldsContainer.topAnchor),
            emailTextField.leadingAnchor.constraint(equalTo: textFieldsContainer.leadingAnchor),
            emailTextField.trailingAnchor.constraint(equalTo: textFieldsContainer.trailingAnchor),
            emailTextField.heightAnchor.constraint(equalToConstant: AppLayout.controlHeight),
 
            separator.topAnchor.constraint(equalTo: emailTextField.bottomAnchor),
            separator.leadingAnchor.constraint(equalTo: textFieldsContainer.leadingAnchor),
            separator.trailingAnchor.constraint(equalTo: textFieldsContainer.trailingAnchor),
            separator.heightAnchor.constraint(equalToConstant: AppLayout.separatorHeight),
 
            passwordTextField.topAnchor.constraint(equalTo: separator.bottomAnchor),
            passwordTextField.leadingAnchor.constraint(equalTo: textFieldsContainer.leadingAnchor),
            passwordTextField.trailingAnchor.constraint(equalTo: textFieldsContainer.trailingAnchor),
            passwordTextField.bottomAnchor.constraint(equalTo: textFieldsContainer.bottomAnchor),
            passwordTextField.heightAnchor.constraint(equalToConstant: AppLayout.controlHeight),
 
            // Кнопка входа
            logInButton.topAnchor.constraint(
                equalTo: textFieldsContainer.bottomAnchor,
                constant: AppLayout.spacing
            ),
            logInButton.heightAnchor.constraint(equalToConstant: AppLayout.controlHeight),
 
            activityIndicator.centerXAnchor.constraint(equalTo: logInButton.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: logInButton.centerYAnchor),
 
            // Кнопка биометрии
            biometricButton.topAnchor.constraint(
                equalTo: logInButton.bottomAnchor,
                constant: AppLayout.spacing
            ),
            biometricButton.heightAnchor.constraint(equalToConstant: AppLayout.controlHeight),
            biometricButton.bottomAnchor.constraint(
                equalTo: contentView.bottomAnchor,
                constant: -AppLayout.spacing
            )
        ])
 
        // Ширина ограничена maxContentWidth и центрирована
        textFieldsContainer.constrainWidth(to: contentView)
        logInButton.constrainWidth(to: contentView)
        biometricButton.constrainWidth(to: contentView)
    }
 
    private func setupGestures() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tapGesture)
    }
 
    // MARK: - Actions
 
    private func logInButtonPressed() {
        viewModel.updateState(
            viewInput: .login(email: emailTextField.text, password: passwordTextField.text)
        )
    }
 
    private func biometricButtonPressed() {
        viewModel.updateState(viewInput: .biometricLogin)
    }
 
    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
 
    /// Поднимаем содержимое над клавиатурой, чтобы поля не перекрывались
    @objc private func keyboardWillShow(notification: NSNotification) {
        guard let keyboardFrame = notification.userInfo?[
            UIResponder.keyboardFrameEndUserInfoKey
        ] as? CGRect else { return }
 
        let insets = UIEdgeInsets(top: 0, left: 0, bottom: keyboardFrame.height, right: 0)
        scrollView.contentInset = insets
        scrollView.verticalScrollIndicatorInsets = insets
    }
 
    @objc private func keyboardWillHide(notification: NSNotification) {
        scrollView.contentInset = .zero
        scrollView.verticalScrollIndicatorInsets = .zero
    }
 
    private func showAlert(message: String) {
        let alert = UIAlertController(
            title: L10n.Common.error,
            message: message,
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: L10n.Common.ok, style: .default))
        present(alert, animated: true)
    }
}
 
// MARK: - UITextFieldDelegate
 
extension LoginViewController: UITextFieldDelegate {
 
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == emailTextField {
            passwordTextField.becomeFirstResponder()
        } else if textField == passwordTextField {
            passwordTextField.resignFirstResponder()
        }
        return true
    }
}
 
