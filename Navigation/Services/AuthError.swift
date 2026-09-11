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
            return L10n.Login.emptyEmail
        case .emptyPassword:
            return L10n.Login.emptyPassword
        case .invalidCredentials:
            return L10n.Login.invalidCredentials
        case .userNotFound:
            return L10n.Login.userNotFound
        }
    }
}
