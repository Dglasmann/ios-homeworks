//
//  Todo.swift
//  Navigation
//
//  Created by Sasha Soldatov on 05.06.2026.
//

import Foundation

struct Todo: Decodable {
    let userId: Int
    let id: Int
    let title: String
    let completed: Bool
}
