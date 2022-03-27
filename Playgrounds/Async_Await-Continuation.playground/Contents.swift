import UIKit

enum NetworkError: Error {
    case dataError
    case urlError
    case decodingError
}

struct CurrentDate: Decodable {
    let date: String
}

func getCurrentDate(completion: @escaping (Result<CurrentDate, NetworkError>) -> Void) {
    guard let url = URL(string: "https://jarvis-nodejs.herokuapp.com/api/dates/current-date") else {
        completion(.failure(NetworkError.urlError))
        return
    }
    
    URLSession.shared.dataTask(with: url) { data, _, error in
        guard let data = data,
              error == nil else {
                  completion(.failure(.dataError))
                  return
              }
        
        if let currentDate = try? JSONDecoder().decode(CurrentDate.self, from: data) {
            completion(.success(currentDate))
        } else {
            completion(.failure(.decodingError))
        }
        
    }.resume()
}

// MARK: - With 'Continuation'
/// Helpful if the original method is not acessibile or in an uneditable file.
/// And the developer needs to convert that function to await/async
func getCurrentDate() async throws -> CurrentDate {
    return try await withCheckedThrowingContinuation { continuation in
        getCurrentDate { result in
            switch result {
            case .success(let currentDate):
                continuation.resume(returning: currentDate)
            case .failure(let error):
                continuation.resume(throwing: error)
            }
        }
    }
}

Task {
    do {
        let currentDate = try await getCurrentDate()
        print(currentDate)
    } catch {
        print(error)
    }
}

// MARK: - Without using 'Continuation'
/// Traditional
getCurrentDate { result in
    switch result {
    case .success(let currentDate):
        print(currentDate)
    case .failure(let error):
        print(error)
    }
}
