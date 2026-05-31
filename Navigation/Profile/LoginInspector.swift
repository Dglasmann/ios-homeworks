//
//  LoginInspector.swift
//  Navigation
//
//  Created by Sasha Soldatov on 27.04.2026.
//

struct LoginInspector: LoginViewControllerDelegate {
    func check(login: String, password: String) throws {
        guard !login.isEmpty else { throw AuthError.emptyLogin }
        guard !password.isEmpty else { throw AuthError.emptyPassword }
        
        guard Checker.shared.check(login: login, password: password) else {
            throw AuthError.invalidCredentials
        }
    }
}
