//
//  PhotoService.swift
//  Navigation
//
//  Created by Sasha Soldatov on 05.09.2026.
//

import UIKit

final class PhotoService: PhotoServiceProtocol {
    
    private let names: [String]
    
    init(count: Int = 20) {
        self.names = (1...count).map { "photo\($0)" }
    }
    
    func photos() -> [UIImage] {
        names.compactMap { UIImage(named: $0) }
    }
}
