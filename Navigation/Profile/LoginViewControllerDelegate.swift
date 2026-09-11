//
//  LoginViewControllerDelegate.swift
//  Navigation
//
//  Created by Sasha Soldatov on 26.04.2026.
//

// Conformed to by a value type (LoginInspector) and stored strongly as a dependency,
// so it must not be class-only.
// swiftlint:disable:next class_delegate_protocol
protocol LoginViewControllerDelegate {
    
    func checkCredentials(
        email: String,
        password: String,
        completion: @escaping (Result<Void, Error>) -> Void
    )
    
    func signUp(
        email: String,
        password: String,
        completion: @escaping (Result<Void, Error>) -> Void
    )
}
