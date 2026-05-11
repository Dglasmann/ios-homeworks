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
    private let viewModel: FeedViewModel
    
    init(viewModel: FeedViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
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
        bindViewModel()
    }
    
    private func bindViewModel() {
        viewModel.onStateDidChange = { [weak self] state in
            self?.render(state: state)
        }
    }
    
    private func render(state: FeedViewModel.State) {
        switch state {
        case .initial:
            resultLabel.text = ""
        case .correct:
            resultLabel.text = "Верно!"
            resultLabel.textColor = .systemGreen
        case .incorrect:
            resultLabel.text = "Неверно :("
            resultLabel.textColor = .systemRed
        }
    }
    
    private func checkGuess() {
        viewModel.checkGuess(word: guessTextField.text)
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
    
}
