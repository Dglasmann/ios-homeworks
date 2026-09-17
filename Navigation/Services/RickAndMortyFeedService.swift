//
//  RickAndMortyFeedService.swift
//  Navigation
//
//  Created by Sasha Soldatov on 17.09.2026.
//

import Foundation

nonisolated final class RickAndMortyFeedService: FeedContentServiceProtocol {
    
    private let networkService: NetworkServiceProtocol
    private let endpoint = "https://rickandmortyapi.com/api/character"
    
    init(networkService: NetworkServiceProtocol) {
        self.networkService = networkService
    }
    
    func fetchPosts(completion: @escaping (Result<[PostModel], any Error>) -> Void) {
        guard let url = URL(string: endpoint) else {
            completion(.failure(NetworkError.badURL))
            return
        }
        networkService.fetch(
            url,
            as: RMResponse.self) { result in
                completion(result.map { $0.results.map(PostModel.init(from:)) })
            }
    }
}
