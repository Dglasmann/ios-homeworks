//
//  TestUserService.swift
//  Navigation
//
//  Created by Sasha Soldatov on 23.04.2026.
//

class TestUserService: UserService {
    private let user: User
    
    init(user: User) {
        self.user = user
    }
    
    func user(for login: String) -> Result<User, AuthError> {
        guard login == user.login else { return .failure(.userNotFound) }
        return .success(user)
    }
}
