//
//  CheckerServiceProtocol.swift
//  Navigation
//
//  Created by Sasha Soldatov on 12.06.2026.
//

import Foundation


protocol CheckerServiceProtocol {
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
