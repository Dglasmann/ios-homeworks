//
//  LoginViewModel.swift
//  Navigation
//

import Foundation
import FirebaseAuth
import LocalAuthentication

final class LoginViewModel: ViewModelProtocol {

    // MARK: - State
    enum State: Equatable {
        case idle
        case loading
        case success(login: String)
        case failure(message: String)
    }
    
    enum ViewInput {
        case login(email: String?, password: String?)
        case register(email: String?, password: String?)
        case biometricLogin
    }

    // MARK: - Bindings
    var onStateDidChange: ((State) -> Void)?

    private(set) var state: State = .idle {
        didSet {
            onStateDidChange?(state)
        }
    }

    // MARK: - Dependencies
    
    private let loginDelegate: LoginViewControllerDelegate
    private let biometricService: LocalAuthorizationServiceProtocol
    private weak var coordinator: AuthCoordinator?

    // MARK: - Init

    init(
        loginDelegate: LoginViewControllerDelegate,
        biometricService: LocalAuthorizationServiceProtocol,
        coordinator: AuthCoordinator? = nil
    ) {
        self.loginDelegate = loginDelegate
        self.biometricService = biometricService
        self.coordinator = coordinator
    }
    
    var biometryType: BiometryType {
        biometricService.biometryType
    }

    // MARK: - ViewModelProtocol
    
    func updateState(viewInput: ViewInput) {
        switch viewInput {
        case .login(let email, let password):
            handleLogin(email: email, password: password)
        case .register(let email, let password):
            handleRegister(email: email, password: password)
        case .biometricLogin:
            handleBiometricLogin()
        }
    }
    
    func didFinishLogin(with login: String) {
        coordinator?.didAuthenticate()
    }
    
    // MARK: - Private
    
    private func handleLogin(email: String?, password: String?) {
        
        guard let email, !email.isEmpty else {
            state = .failure(message: L10n.Login.emptyEmail)
            return
        }
        
        guard let password, !password.isEmpty else {
            state = .failure(message: L10n.Login.emptyPassword)
            return
        }
        
        state = .loading

        loginDelegate.checkCredentials(email: email, password: password) { [weak self] result in
            guard let self else { return }
            switch result {
            case .success:
                self.state = .success(login: email)
            case .failure(let error):
                // в режиме входа не регистрируем автоматически: если аккаунта
                // нет, подсказываем переключиться на «регистрацию»
                let code = AuthErrorCode(rawValue: (error as NSError).code)
                switch code {
                case .userNotFound, .invalidCredential:
                    self.state = .failure(message: L10n.Login.userNotFound)
                case .wrongPassword:
                    self.state = .failure(message: L10n.Login.wrongPassword)
                default:
                    self.state = .failure(message: error.localizedDescription)
                }
            }
        }
    }

    /// явная регистрация нового пользователя (вкладка «регистрация»)
    private func handleRegister(email: String?, password: String?) {
        guard let email, !email.isEmpty else {
            state = .failure(message: L10n.Login.emptyEmail)
            return
        }
        guard let password, !password.isEmpty else {
            state = .failure(message: L10n.Login.emptyPassword)
            return
        }

        state = .loading

        loginDelegate.signUp(email: email, password: password) { [weak self] result in
            guard let self else { return }
            switch result {
            case .success:
                self.state = .success(login: email)
            case .failure(let error):
                let code = AuthErrorCode(rawValue: (error as NSError).code)
                if code == .emailAlreadyInUse {
                    self.state = .failure(message: L10n.Login.emailInUse)
                } else {
                    self.state = .failure(message: error.localizedDescription)
                }
            }
        }
    }
    
    private func handleBiometricLogin() {
        biometricService.authorizeIfPossible { [weak self] success, error in
            guard let self else { return }
            
            if success {
                self.state = .success(login: "admin")
            } else {
                self.state = .failure(message: self.biometricErrorMessage(for: error))
            }
        }
    }
    
    private func biometricErrorMessage(for error: Error?) -> String {
        guard let laError = error as? LAError else {
            return L10n.Login.biometryFailed
        }
        switch laError.code {
        case .biometryNotEnrolled:       return L10n.Login.biometryNotEnrolled
        case .biometryNotAvailable:      return L10n.Login.biometryNotAvailable
        case .biometryLockout:           return L10n.Login.biometryLockout
        case .userCancel, .userFallback: return L10n.Login.biometryCancelled
        default:                         return laError.localizedDescription
        }
    }
}
