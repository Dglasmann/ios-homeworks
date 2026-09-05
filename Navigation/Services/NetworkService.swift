//
//  NetworkService.swift
//  Navigation
//
//  Created by Sasha Soldatov on 01.06.2026.
//
import Foundation


enum NetworkError: LocalizedError {
    case emptyData
    case decodingFailed(Error)
    case transport(Error)
    
    var errorDescription: String? {
        switch self {
        case .emptyData: return L10n.Network.emptyData
        case .decodingFailed: return L10n.Network.decodingFailed
        case .transport(let error): return error.localizedDescription
        }
    }
}


final class NetworkService: NetworkServiceProtocol {
    private let session: URLSession
    
    init(session: URLSession = .shared) {
        self.session = session
    }
    
    func request<T: Decodable>(
        _ url: URL,
        as type: T.Type,
        completion: @escaping (Result<T, any Error>) -> Void
    )  {
        session.dataTask(with: url) { data, _, error in
            let result: Result<T, Error>
            
            if let error {
                result = .failure(NetworkError.transport(error))
            } else if let data {
                do {
                    result = .success(try JSONDecoder().decode(T.self, from: data))
                }
                catch {
                    result = .failure(NetworkError.decodingFailed(error))
                }
            } else {
                result = .failure(NetworkError.emptyData)
            }
            DispatchQueue.main.async {
                completion(result)
            }
        }.resume()
    }
}

