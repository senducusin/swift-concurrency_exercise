import UIKit

enum NetworkError: Error {
    case urlError
    case decodingError
    case dataError
    case idError
}

struct CreditScore: Decodable {
    let score: Int
}

struct Constants {
    struct Urls {
        static func creditCheckerUrl(userId: Int) -> URL? {
            return URL(string: "https://jarvis-nodejs.herokuapp.com/api/credit-score/\(userId)")
        }
    }
}

func calculateAPR(creditScores: [CreditScore]) -> Double {
    let sum = creditScores.reduce(0) { next, credit in
        return next + credit.score
    }
    
    return Double(sum / creditScores.count)
}

func getAPR(userId: Int) async throws -> Double {
    
    if userId % 2 == 0 {
        throw NetworkError.idError
    }
    
    guard let bdoUrl = Constants.Urls.creditCheckerUrl(userId: userId),
          let metrobankUrl = Constants.Urls.creditCheckerUrl(userId: userId) else {
              throw NetworkError.urlError
          }
    
    /// Does not block nor suspend (Non sequential)
    async let (bdoData, _) = URLSession.shared.data(from: bdoUrl)
    async let (metroBankData, _) = URLSession.shared.data(from: metrobankUrl)
    
    /// Sequential
    guard let bdoCreditScore = try? JSONDecoder().decode(CreditScore.self, from: try await bdoData),
          let metroBankCreditScore = try? JSONDecoder().decode(CreditScore.self, from: try await metroBankData) else {
              throw NetworkError.decodingError
          }
    
    return calculateAPR(creditScores: [bdoCreditScore, metroBankCreditScore])
}

// MARK: - Run single async task
Task {
    let apr = try await getAPR(userId: 1)
    print(apr)
}

// MARK: - Multiple async task (loop)
let ids = [1,2,3,4,5]
var invalidIds = [Int]()

/// Sequential and blocking with error handling
func getAprForAllUsers(ids: [Int]) {
    Task {
        for id in ids {
            do {
                try Task.checkCancellation()
                let apr = try await getAPR(userId: id)
                print(apr)
            } catch {
                print(error)
                invalidIds.append(id)
            }
        }
    }
}

/// Non Sequential and non blocking with error handling
func getAprForAllUsers(ids: [Int]) async throws -> [Int: Double?] {
    var userApr = [Int: Double?]()
    
    try await withThrowingTaskGroup(of: (Int, Double?).self, body: { group in
        for id in ids {
            /// returns the task and value to the group NOT outside the method.
            group.addTask {
                do {
                    try Task.checkCancellation()
                    return (id, try await getAPR(userId: id))
                } catch {
                    print(error)
                    return (id, nil)
                }
            }
        }
        
        /// Added task in group are iterated here
        for try await (id, apr) in group {
            userApr[id] = apr
        }
    })
    
    return userApr
}

Task {
    let userAprs = try await getAprForAllUsers(ids: ids)
    print(userAprs)
}
