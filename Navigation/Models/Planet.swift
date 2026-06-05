//
//  Planet.swift
//  Navigation
//
//  Created by Sasha Soldatov on 05.06.2026.
//

import Foundation

nonisolated struct Planet: Decodable {
    let name: String
    let orbitalPeriod: String
    let residents: [String]
    
    enum CodingKeys: String, CodingKey {
        case name
        case orbitalPeriod = "orbital_period"
        case residents
    }
}
