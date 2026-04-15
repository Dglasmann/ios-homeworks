//
//  LoginViewController.swift
//  Navigation
//
//  Created by Sasha Soldatov on 07.03.2026.
//

import UIKit

class LoginViewController: UIViewController {
    
    
    //MARK: - Subviews
    
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
    
    //logo vk, делаем по центру горизонтально
    private lazy var logoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(named: "logo")
        imageView.contentMode = .scaleAspectFit
        
        return imageView
    }()
    
    //textfield для ввода email или телефона
    private lazy var emailTextField: UITextField = {
        let emailTextField = UITextField()
        emailTextField.translatesAutoresizingMaskIntoConstraints = false
        emailTextField.placeholder = "Email or phone"
        emailTextField.font = UIFont.systemFont(ofSize: 16)
        emailTextField.textColor = .black
        emailTextField.tintColor = .systemBlue
        emailTextField.autocapitalizationType = .none
        emailTextField.autocorrectionType = .no
        emailTextField.returnKeyType = .next
        emailTextField.delegate = self
        emailTextField.backgroundColor = .clear
        emailTextField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: 0))
        emailTextField.leftViewMode = .always
        
        return emailTextField
    }()
    
    //textfield для ввода пароля
    private lazy var passwordTextField: UITextField = {
        let passwordTextField = UITextField()
        passwordTextField.translatesAutoresizingMaskIntoConstraints = false
        passwordTextField.placeholder = "Password"
        passwordTextField.font = UIFont.systemFont(ofSize: 16)
        passwordTextField.textColor = .black
        passwordTextField.tintColor = .systemBlue
        passwordTextField.autocapitalizationType = .none
        passwordTextField.autocorrectionType = .no
        passwordTextField.isSecureTextEntry = true
        passwordTextField.returnKeyType = .done
        passwordTextField.delegate = self
        passwordTextField.backgroundColor = .clear
        passwordTextField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: 0))
        passwordTextField.leftViewMode = .always
        
        return passwordTextField
    }()
    
    //добавляем разделитель между полями
    private lazy var separator: UIView = {
        let separator = UIView()
        separator.translatesAutoresizingMaskIntoConstraints = false
        separator.backgroundColor = .lightGray
        return separator
    }()
    
    //контнейнер для двух текстфилдов и разделителя
    private lazy var textFieldsContainer: UIView = {
        let textFieldContainer = UIView()
        textFieldContainer.translatesAutoresizingMaskIntoConstraints = false
        textFieldContainer.backgroundColor = .systemGray6
        textFieldContainer.layer.borderColor = UIColor.lightGray.cgColor
        textFieldContainer.layer.borderWidth = 0.5
        textFieldContainer.layer.cornerRadius = 10
        textFieldContainer.clipsToBounds = true
        
        return textFieldContainer
    }()
    
    //кнопка Log in
    private lazy var logInButton: UIButton = {
        let logInButton = UIButton(type: .system)
        logInButton.translatesAutoresizingMaskIntoConstraints = false
        logInButton.setTitle("Log in", for: .normal)
        logInButton.setTitleColor(.white, for: .normal)
        logInButton.titleLabel?.font = UIFont.systemFont(ofSize: 18)
        logInButton.backgroundColor = UIColor(red: 0.000, green: 0.569, blue: 0.808, alpha: 1.000)
        
        if let bluePixel = UIImage(named: "blue_pixel") {
            logInButton.setBackgroundImage(bluePixel, for: .normal)
            logInButton.setBackgroundImage(bluePixel.withAlpha(0.8), for: .selected)
            logInButton.setBackgroundImage(bluePixel.withAlpha(0.8), for: .highlighted)
            logInButton.setBackgroundImage(bluePixel.withAlpha(0.8), for: .disabled)
        }
        logInButton.layer.cornerRadius = 10
        logInButton.clipsToBounds = true
        
        logInButton.addTarget(self, action: #selector(logInButtonPressed), for: .touchUpInside)
        
        return logInButton
    }()
    
    
    //MARK: - Lifecycle
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        navigationController?.navigationBar.isHidden = true
        setupViews()
        setupConstraints()
        setupGestures()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = true
        
        //обрабатываем появление клавиатуры, делаем подписку
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
    
    
    //MARK: - setup
    private func setupViews() {
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubview(logoImageView)
        contentView.addSubview(textFieldsContainer)
        contentView.addSubview(logInButton)
        
        textFieldsContainer.addSubview(emailTextField)
        textFieldsContainer.addSubview(separator)
        textFieldsContainer.addSubview(passwordTextField)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
        
        //scrollview constraints (фигачим на весь экран)
        scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
        scrollView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
        scrollView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
        scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
        
        
        //contentview constraints (привязываем к scrollview, ширина равна ширине экрана)
        contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
        contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
        contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
        contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
        contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
        
        //logo vk (100x100, 120 pt от верха)
        logoImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 120),
        logoImageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
        logoImageView.widthAnchor.constraint(equalToConstant: 100),
        logoImageView.heightAnchor.constraint(equalToConstant: 100),
        
        //контейнер текстфилдов (слева и справа 16 pt, 120 pt под лого)
        textFieldsContainer.topAnchor.constraint(equalTo: logoImageView.bottomAnchor, constant: 120),
        textFieldsContainer.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
        textFieldsContainer.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
        
        //email textfield (внутри контейнера высота 50)
        emailTextField.topAnchor.constraint(equalTo: textFieldsContainer.topAnchor),
        emailTextField.leadingAnchor.constraint(equalTo: textFieldsContainer.leadingAnchor),
        emailTextField.trailingAnchor.constraint(equalTo: textFieldsContainer.trailingAnchor),
        emailTextField.heightAnchor.constraint(equalToConstant: 50),
        
        //разделитель, возьмём 0.5 pt
        separator.topAnchor.constraint(equalTo: emailTextField.bottomAnchor),
        separator.leadingAnchor.constraint(equalTo: textFieldsContainer.leadingAnchor),
        separator.trailingAnchor.constraint(equalTo: textFieldsContainer.trailingAnchor),
        separator.heightAnchor.constraint(equalToConstant: 0.5),
        
       //password textfield (внутри контейнера высота 50)
        passwordTextField.topAnchor.constraint(equalTo: separator.bottomAnchor),
        passwordTextField.leadingAnchor.constraint(equalTo: textFieldsContainer.leadingAnchor),
        passwordTextField.trailingAnchor.constraint(equalTo: textFieldsContainer.trailingAnchor),
        passwordTextField.bottomAnchor.constraint(equalTo: textFieldsContainer.bottomAnchor),
        passwordTextField.heightAnchor.constraint(equalToConstant: 50),
        
        //кнопка log in (слева и справа 16 pt, сверху под контейнером 16 pt, высота 50)
        logInButton.topAnchor.constraint(equalTo: textFieldsContainer.bottomAnchor, constant: 16),
        logInButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
        logInButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
        logInButton.heightAnchor.constraint(equalToConstant: 50),
        logInButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16)
        ])
    }
    
    private func setupGestures() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tapGesture)
    }
    
    //MARK: - Actions
    
    @objc private func logInButtonPressed() {
        let profileVC = ProfileViewController()
        navigationController?.pushViewController(profileVC, animated: true)
    }
    
    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
    
    @objc private func keyboardWillShow(notification: NSNotification) {
        guard let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else { return }
        let insets = UIEdgeInsets(top: 0, left: 0, bottom: keyboardFrame.height, right: 0)
        scrollView.contentInset = insets
        scrollView.scrollIndicatorInsets = insets
    }
    
    @objc private func keyboardWillHide(notification: NSNotification) {
        scrollView.contentInset = .zero
        scrollView.scrollIndicatorInsets = .zero
    }
}
    
    extension UIImage {
        func withAlpha(_ alpha: CGFloat) -> UIImage {
            UIGraphicsBeginImageContextWithOptions(size, false, scale)
            draw(at: .zero, blendMode: .normal, alpha: alpha)
            let newImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            return newImage ?? self
            
        }
    }

    //это чтобы клавиатура переходила к passwordTextField с emailTextField и пряталась при нажатии на return
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
