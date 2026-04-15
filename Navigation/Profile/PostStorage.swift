//
//  PhotosStorage.swift
//  Navigation
//
//  Created by Sasha Soldatov on 16.03.2026.
//

struct PostStorage {
    static let posts : [PostModel] = [
    PostModel(
        author: "vedmak.official",
        description: "Новые кадры со съемок второго сезона Ведьмаке.",
        image: "post1",
        likes: 240,
        views: 560
    ),
    PostModel(
        author: "Крутые уроки по Swift",
        description: "А вы знали, что можно использовать guard let в Swift?",
        image: "post2",
        likes: 530,
        views: 1245
    ),
    PostModel(
        author: "java.qa",
        description: "Как в 2026 можно использовать AI в тестировании?",
        image: "post3",
        likes: 13,
        views: 553
    ),
    PostModel(
        author: "nasa.exploring",
        description: "Новые снимки с телескопа Джейма Уэбба показали новые планеты в Солнечной системе.",
        image: "post4",
        likes: 5840,
        views: 13402
    ),
    ]
}
