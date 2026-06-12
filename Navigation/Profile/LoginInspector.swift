//
//  LoginInspector.swift
//  Navigation
//
//  Created by Sasha Soldatov on 27.04.2026.
//

struct LoginInspector: LoginViewControllerDelegate {
    private let checkerService: CheckerServiceProtocol
    
    init(checkerService: CheckerServiceProtocol) {
        self.checkerService = checkerService
    }
    
    func checkCredentials(email: String, password: String, completion: @escaping (Result<Void, any Error>) -> Void) {
        checkerService.checkCredentials(email: email, password: password, completion: completion)
    }
    
    func signUp(email: String, password: String, completion: @escaping (Result<Void, any Error>) -> Void) {
        checkerService.signUp(email: email, password: password, completion: completion)
    }
    
    }

