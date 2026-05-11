//
//  FeedViewController.swift
//  Navigation
//
//  Created by Sasha Soldatov on 22.02.2026.
//

import UIKit
import StorageService

class FeedViewController: UIViewController {
    let post = Post(title: "Мой первый пост")
    private let feedModel = FeedModel()
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 10
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        return stackView
    }()
    
    private lazy var guessTextField: UITextField = {
        let guessTextField = UITextField()
        guessTextField.translatesAutoresizingMaskIntoConstraints = false
        guessTextField.placeholder = "Введите секретное слово"
        guessTextField.borderStyle = .roundedRect
        guessTextField.autocapitalizationType = .none
        guessTextField.autocorrectionType = .no
        
        return guessTextField
    }()
    
    private lazy var checkGuessButton = CustomButton(
        title: "Проверить",
        backgroundColor: .systemGreen,
        tapAction: {[weak self] in self?.checkGuess()}
    )
    
    private lazy var resultLabel: UILabel = {
        let resultLabel = UILabel()
        resultLabel.translatesAutoresizingMaskIntoConstraints = false
        resultLabel.textAlignment = .center
        resultLabel.font = .systemFont(ofSize: 16, weight: .semibold)
        resultLabel.text = ""
        
        return resultLabel
    }()
    
    private lazy var firstButton = CustomButton(
        title: "Открыть пост 1",
        backgroundColor: .systemBlue,
        tapAction: {[weak self] in self?.showPost() }
    )
    
    private lazy var secondButton = CustomButton(
        title: "Открыть пост 2",
        backgroundColor: .systemBlue,
        tapAction: {[weak self] in self?.showPost() }
    )
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(handleCheckResult(_:)),
            name: .feedCheckResult,
            object: nil
        )
    }
    
    private func checkGuess() {
        guard let text = guessTextField.text, !text.isEmpty else { return }
        feedModel.check(word: text)
    }
    
    @objc private func handleCheckResult(_ notification: Notification) {
        guard let isCorrect = notification.userInfo?["isCorrect"] as? Bool else { return }
        resultLabel.text = isCorrect ? "Верно!": "Неверно :("
        resultLabel.textColor = isCorrect ? .systemGreen : .systemRed
    }
    private func setupUI() {
        view.backgroundColor = .systemBackground
        title = "Лента"
        
        stackView.addArrangedSubview(firstButton)
        stackView.addArrangedSubview(secondButton)
        stackView.addArrangedSubview(guessTextField)
        stackView.addArrangedSubview(checkGuessButton)
        stackView.addArrangedSubview(resultLabel)
        
        view.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            stackView.widthAnchor.constraint(equalToConstant: 200),
            
            firstButton.heightAnchor.constraint(equalToConstant: 50),
            secondButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    private func showPost() {
        let postViewController = PostViewController()
        postViewController.post = post
        navigationController?.pushViewController(postViewController, animated: true)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}
