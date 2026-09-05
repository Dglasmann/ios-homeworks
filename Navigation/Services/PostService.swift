//
//  PostService.swift
//  Navigation
//
//  Created by Sasha Soldatov on 05.09.2026.
//

import UIKit

final class PostService: PostServiceProtocol {
    private var storage: [PostModel]
    
    init(storage: [PostModel]) {
        self.storage = storage
    }
    
    func posts() -> [PostModel] {
        storage
    }
    
    
    @discardableResult
    func addPost(_ post: PostModel, at index: Int) -> PostModel {
        let safeIndex = min(max(index, 0), storage.count)
        storage.insert(post, at: safeIndex)
        return post
    }
    
    //MARK: - Demo data
    private static let defaultPosts: [PostModel] = [
        PostModel(
            author: "vedmak.official",
            description: "Новые кадры со съёмок второго сезона «Ведьмака».",
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
            description: "Новые снимки телескопа Джеймса Уэбба показали новые планеты.",
            image: UIImage(named: "post4") ?? UIImage(),
            likes: 5840,
            views: 13402
        )
    ]
}
