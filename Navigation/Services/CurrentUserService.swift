//
//  CurrentUserService.swift
//  Navigation
//
//  Created by Sasha Soldatov on 23.04.2026.
//

final class CurrentUserService: UserService {
    private let user: User
    
    init(user: User) {
        self.user = user
    }

    func user(for login: String) -> Result<User, AuthError> {
        .success(user)
    }
}
    
