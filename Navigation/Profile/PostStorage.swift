//
//  PhotosStorage.swift
//  Navigation
//
//  Created by Sasha Soldatov on 16.03.2026.
//
import UIKit

struct PostStorage {
    static var posts : [PostModel] = [
    PostModel(
        author: "vedmak.official",
        description: "Новые кадры со съемок второго сезона Ведьмаке.",
        image: UIImage(named: "post1") ?? UIImage(),
        likes: 240,
        views: 560
    ),
    PostModel(
        author: "Крутые уроки по Swift",
        description: "А вы знали, что можно использовать guard let в Swift?",
        image: UIImage(named: "post2") ?? UIImage(),
        likes: 530,
        views: 1245
    ),
    PostModel(
        author: "java.qa",
        description: "Как в 2026 можно использовать AI в тестировании?",
        image: UIImage(named: "post3") ?? UIImage(),
        likes: 13,
        views: 553
    ),
    PostModel(
        author: "nasa.exploring",
        description: "Новые снимки с телескопа Джейма Уэбба показали новые планеты в Солнечной системе.",
        image: UIImage(named: "post4") ?? UIImage(),
        likes: 5840,
        views: 13402
    ),
    ]
}
