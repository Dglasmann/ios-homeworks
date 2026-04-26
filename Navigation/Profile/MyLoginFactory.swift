//
//  MyLoginFactory.swift
//  Navigation
//
//  Created by Sasha Soldatov on 27.04.2026.
//

struct MyLoginFactory: LoginFactory {
    func makeLoginInspector() -> LoginInspector {
        LoginInspector()
    }
    
    
}
