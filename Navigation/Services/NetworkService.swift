//
//  NetworkService.swift
//  Navigation
//
//  Created by Sasha Soldatov on 17.09.2026.
//

import Foundation

enum NetworkError: LocalizedError {
    case badURL
    case emptyData
    
    var errorDescription: String? {
        switch self {
        case .badURL: return L10n.Feed.loadError
        case .emptyData: return L10n.Feed.loadError
        }
    }
}

nonisolated final class NetworkService: NetworkServiceProtocol {

    private let session: URLSession

    init(session: URLSession = .shared) {
        self.session = session
    }

    func fetch<T: Decodable>(
        _ url: URL,
        as type: T.Type,
        completion: @escaping (Result<T, Error>) -> Void
    ) {
        session.dataTask(with: url) { data, _, error in
            let result: Result<T, Error>
            if let error {
                result = .failure(error)
            } else if let data {
                do {
                    result = .success(try JSONDecoder().decode(T.self, from: data))
                } catch {
                    result = .failure(error)
                }
            } else {
                result = .failure(NetworkError.emptyData)
            }
            DispatchQueue.main.async { completion(result) }
        }.resume()
    }
}
