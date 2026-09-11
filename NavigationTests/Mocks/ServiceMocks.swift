//
//  ServiceMocks.swift
//  Navigation
//
//  Created by Sasha Soldatov on 11.09.2026.
//

import UIKit
import CoreData
@testable import Navigation

nonisolated final class PostServiceMock: PostServiceProtocol {

    var stubbedPosts: [PostModel] = []
    private(set) var addPostCallCount = 0

    func posts() -> [PostModel] { stubbedPosts }

    @discardableResult
    func addPost(_ post: PostModel, at index: Int) -> PostModel {
        addPostCallCount += 1
        stubbedPosts.insert(post, at: min(max(index, 0), stubbedPosts.count))
        return post
    }
}

nonisolated final class PhotoServiceMock: PhotoServiceProtocol {
    var stubbedPhotos: [UIImage] = []
    func photos() -> [UIImage] { stubbedPhotos }
}

nonisolated final class FavouritesServiceMock: FavouritesServiceProtocol {

    private(set) var savedPosts: [PostModel] = []
    private(set) var deletedPosts: [PostModel] = []
    var stubbedIsFavourite = false

    func save(_ post: PostModel, completion: (() -> Void)?) {
        savedPosts.append(post)
        completion?()
    }

    func delete(_ post: PostModel, completion: (() -> Void)?) {
        deletedPosts.append(post)
        completion?()
    }

    func isFavourite(_ post: PostModel) -> Bool { stubbedIsFavourite }

    func makeFetchedResultsController(author: String?) -> NSFetchedResultsController<FavouritePost> {
        fatalError("Не используется в этих тестах")
    }
}

nonisolated final class BiometricServiceMock: LocalAuthorizationServiceProtocol {

    var stubbedBiometryType: BiometryType = .faceID
    var stubbedResult: (Bool, Error?) = (true, nil)
    private(set) var authorizeCallCount = 0

    var biometryType: BiometryType { stubbedBiometryType }

    func authorizeIfPossible(_ completion: @escaping (Bool, Error?) -> Void) {
        authorizeCallCount += 1
        completion(stubbedResult.0, stubbedResult.1)
    }
}
