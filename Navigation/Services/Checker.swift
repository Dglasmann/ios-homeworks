//
//  Checker.swift
//  Navigation
//
//  Created by Sasha Soldatov on 26.04.2026.
//

class Checker {
    static let shared = Checker()
    
    private let login = "admin"
    private let password = "admin123"
    
    
    private init() {}
    
    func check(login: String, password: String) -> Bool {
        self.login == login && self.password == password
    }
}
