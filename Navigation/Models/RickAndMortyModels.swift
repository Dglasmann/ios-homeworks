//
//  RickAndMortyModels.swift
//  Navigation
//
//  Created by Sasha Soldatov on 17.09.2026.
//

import Foundation

nonisolated struct RMResponse: Decodable {
    let results: [RMCharacter]
}

nonisolated struct RMCharacter: Decodable {
    let id: Int
    let name: String
    let status: String
    let species: String
    let origin: RMOrigin
    let image: String
}

nonisolated struct RMOrigin: Decodable {
    let name: String
}
