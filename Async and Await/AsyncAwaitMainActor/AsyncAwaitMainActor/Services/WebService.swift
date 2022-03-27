//
//  WebService.swift
//  AsyncAwaitMainActor
//
//  Created by Jansen Ducusin on 3/28/22.
//

import Foundation

enum NetworkError: Error {
    case urlError
    case dataError
    case decodingError
}

class Webservice {
    func fetchSources(url: URL?, completion: @escaping (Result<[NewsSource], NetworkError>) -> Void) {
        guard let url = url else {
            completion(.failure(.urlError))
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data = data, error == nil else {
                completion(.failure(.dataError))
                return
            }
            
            if let newsSourceResponse = try? JSONDecoder().decode(NewsSourceResponse.self, from: data) {
                completion(.success(newsSourceResponse.sources))
            } else {
                completion(.failure(.decodingError))
            }
            
        }.resume()
    }
    
    func fetchNews(by sourceId: String, url: URL?, completion: @escaping (Result<[NewsArticle], NetworkError>) -> Void) {
        guard let url = url else {
            completion(.failure(.urlError))
            return
        }
            
        URLSession.shared.dataTask(with: url) { data, _, error in
            
            guard let data = data, error == nil else {
                completion(.failure(.dataError))
                return
            }
            
            if let newsArticleResponse = try? JSONDecoder().decode(NewsArticleResponse.self, from: data) {
                completion(.success(newsArticleResponse.articles))
            } else {
                completion(.failure(.decodingError))
            }
            
        }.resume()
    }
}

// MARK: - Async versions
extension Webservice {
    /// Complete async refactor
    func fetchSources(url: URL?) async throws -> [NewsSource] {
        guard let url = url else { throw NetworkError.urlError }
        
        let (data, _) = try await URLSession.shared.data(from: url)
        if let newsSourceResponse = try? JSONDecoder().decode(NewsSourceResponse.self, from: data) {
            return newsSourceResponse.sources
        }
        
        throw NetworkError.decodingError
    }
    
    /// Extender with 'Continuation' instead of complete refactor
    func fetchNews(sourceId: String, url: URL?) async throws -> [NewsArticle] {
        try await withCheckedThrowingContinuation { continuation in
            fetchNews(by: sourceId, url: url) { result in
                switch result {
                case .success(let newsArticles):
                    continuation.resume(returning: newsArticles)
                case .failure(let error):
                    continuation.resume(throwing: error)
                }
            }
        }
    }
}
