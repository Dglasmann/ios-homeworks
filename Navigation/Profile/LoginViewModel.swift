//
//  LoginViewModel.swift
//  Navigation
//

import Foundation
import FirebaseAuth

final class LoginViewModel {

    //MARK: - State
    nonisolated enum State: Equatable {
        case idle
        case loading
        case success(login: String)
        case failure(message: String)
    }

    //MARK: - Bindings
    var onStateDidChange: ((State) -> Void)?

    private(set) var state: State = .idle {
        didSet {
            onStateDidChange?(state)
        }
    }

    //MARK: - Private

    private let loginDelegate: LoginViewControllerDelegate

    //MARK: - Init
    init(loginDelegate: LoginViewControllerDelegate) {
        self.loginDelegate = loginDelegate
    }

    //MARK: - Input

    func login(email: String?, password: String?) {
        guard let email = email, !email.isEmpty else {
            state = .failure(message: "Введите email")
            return
        }

        guard let password = password, !password.isEmpty else {
            state = .failure(message: "Введите пароль")
            return
        }

        state = .loading

        loginDelegate.checkCredentials(email: email, password: password) { [weak self] result in
            guard let self = self else { return }

            switch result {
            case .success:
                self.state = .success(login: email)

            case .failure(let error):
                let code = AuthErrorCode(rawValue: (error as NSError).code)

                switch code {
                case .userNotFound, .invalidCredential:
                    self.signUp(email: email, password: password)

                case .wrongPassword:
                    self.state = .failure(message: "Неверный пароль")

                default:
                    self.state = .failure(message: error.localizedDescription)
                }
            }
        }
    }

    //MARK: - Private

    private func signUp(email: String, password: String) {
        loginDelegate.signUp(email: email, password: password) { [weak self] result in
            guard let self = self else { return }

            switch result {
            case .success:
                self.state = .success(login: email)

            case .failure(let error):
                let code = AuthErrorCode(rawValue: (error as NSError).code)
                if code == .emailAlreadyInUse {
                    self.state = .failure(message: "Неверный пароль")
                } else {
                    self.state = .failure(message: error.localizedDescription)
                }
            }
        }
    }
}
