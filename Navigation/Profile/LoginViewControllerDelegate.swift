//
//  LoginViewControllerDelegate.swift
//  Navigation
//
//  Created by Sasha Soldatov on 26.04.2026.
//

protocol LoginViewControllerDelegate {
    func check(login: String, password: String) -> Bool
}
