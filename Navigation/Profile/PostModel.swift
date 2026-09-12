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
    // поля для карточки ленты; у постов из core data их нет — идут дефолты
    let authorRole: String
    let comments: Int
    let authorAvatar: UIImage?

    init(
        author: String,
        description: String,
        image: UIImage,
        likes: Int,
        views: Int,
        authorRole: String = "",
        comments: Int = 0,
        authorAvatar: UIImage? = nil
    ) {
        self.author = author
        self.description = description
        self.image = image
        self.likes = likes
        self.views = views
        self.authorRole = authorRole
        self.comments = comments
        self.authorAvatar = authorAvatar
    }
}

extension PostModel {
    
    // создает доменную модель из core-data сущности
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
