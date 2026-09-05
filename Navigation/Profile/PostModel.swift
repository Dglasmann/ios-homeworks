//
//  Post.swift
//  Navigation
//
//  Created by Sasha Soldatov on 09.03.2026.
//

import UIKit

struct PostModel {
    let author: String
    let description: String
    let image: UIImage
    let likes: Int
    let views: Int
}

extension PostModel {
    
    
    //создает доменную модель из core-data сущности
    nonisolated init(from entity: FavouritePost) {
        self.init(
            author: entity.author,
            description: entity.descriptionText,
            image: UIImage(data: entity.image ?? Data()) ?? UIImage(),
            likes: Int(entity.likes),
            views: Int(entity.views)
        )
    }
}
