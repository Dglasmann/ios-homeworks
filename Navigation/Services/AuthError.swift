//
//  AuthError.swift
//  Navigation
//
//  Created by Sasha Soldatov on 26.05.2026.
//

import Foundation

enum AuthError: Error {
    case emptyLogin
    case emptyPassword
    case invalidCredentials
    case userNotFound
    
}

extension AuthError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .emptyLogin:
            return "Введите логин"
        case .emptyPassword:
            return "Введите пароль"
        case .invalidCredentials:
            return "Неверный логин или пароль"
        case .userNotFound:
            return "Пользователь не найден"
        }
    }
}
