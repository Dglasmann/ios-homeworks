//
//  LoginViewControllerDelegate.swift
//  Navigation
//
//  Created by Sasha Soldatov on 26.04.2026.
//

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
