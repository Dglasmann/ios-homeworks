//
//  ServiceProtocols.swift
//  Navigation
//
//  Created by Sasha Soldatov on 05.09.2026.
//  Контракты сервисов
//

import UIKit
import CoreData

nonisolated protocol FeedServiceProtocol {
    func check(word: String) -> Bool
}

nonisolated protocol PostServiceProtocol {
    func posts() -> [PostModel]
    @discardableResult
    func addPost(_ post: PostModel, at index: Int) -> PostModel
}

nonisolated protocol PhotoServiceProtocol {
    func photos() -> [UIImage]
}

nonisolated protocol FavouritesServiceProtocol {
    func save(_ post: PostModel, completion: (() -> Void)?)
    func delete(_ post: PostModel, completion: (() -> Void)?)
    func isFavourite(_ post: PostModel) -> Bool
    func makeFetchedResultsController(author: String?) -> NSFetchedResultsController<FavouritePost>
}

protocol LocalAuthorizationServiceProtocol {
    var biometryType: BiometryType { get }
    func authorizeIfPossible(_ completion: @escaping (Bool, Error?) -> Void)
}

nonisolated protocol NetworkServiceProtocol {
    func request<T: Decodable>(_ url: URL, as type: T.Type, completion: @escaping (Result<T, Error>) -> Void)
}
