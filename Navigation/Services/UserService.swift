//
//  UserService.swift
//  Navigation
//
//  Created by Sasha Soldatov on 23.04.2026.
//

protocol UserService {
    
    func user(for login: String) -> Result<User, AuthError>
}
