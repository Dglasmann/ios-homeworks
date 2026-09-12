//
//  User.swift
//  Navigation
//
//  Created by Sasha Soldatov on 23.04.2026.
//

import UIKit

final class User {
    let login: String
    let avatar: UIImage
    // редактируемые на экране «Редактировать» поля
    var fullName: String
    var profession: String
    var status: String
    // счётчики в шапке профиля
    let posts: Int
    let subscriptions: Int
    let subscribers: Int

    init(
        login: String,
        fullName: String,
        avatar: UIImage,
        status: String,
        profession: String = "",
        posts: Int = 0,
        subscriptions: Int = 0,
        subscribers: Int = 0
    ) {
        self.login = login
        self.fullName = fullName
        self.avatar = avatar
        self.status = status
        self.profession = profession
        self.posts = posts
        self.subscriptions = subscriptions
        self.subscribers = subscribers
    }
}
