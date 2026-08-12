//
//  LoginViewControllerDelegateMock.swift
//  Navigation
//
//  Created by Sasha Soldatov on 13.08.2026.
//

import Foundation
@testable import Navigation

final class LoginViewControllerDelegateMock: LoginViewControllerDelegate {
    
    var checkCredentialsResult: Result<Void, Error> = .success(())
    var signUpResult: Result<Void, Error> = .success(())
    
    private(set) var checkCredentialsCallCount = 0
    private(set) var signUpCallCount = 0
    
    func checkCredentials(
        email: String,
        password: String,
        completion: @escaping (Result<Void, any Error>) -> Void
    ) {
        checkCredentialsCallCount += 1
        completion(checkCredentialsResult)
    }
    
    func signUp(
        email: String,
        password: String,
        completion: @escaping (Result<Void, any Error>) -> Void
    ) {
        signUpCallCount += 1
        completion(signUpResult)
    }
}
