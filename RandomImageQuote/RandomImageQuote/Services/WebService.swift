//
//  WebService.swift
//  RandomImageQuote
//
//  Created by Jansen Ducusin on 4/3/22.
//

import Foundation

enum NetworkError: Error {
    case urlError
    case decodeError
    case requestError
}

class WebService {
    static let shared = WebService()
    
    func getRandomData(ids: [Int]) async throws -> [RandomData] {
        var randomData = [RandomData]()
        
        /// This will fetch the data sequentially and blocking
//        for id in ids {
//            let randomDatum = try await getRandomData(id: id)
//            randomData.append(randomDatum)
//        }
        
        /// This will fetch the data concurrently and non-blocking.
        ///
        /// In order for this to work on a simulator,
        /// make sure that the thread sanitizer is enabled
        /// to enable: Edit Scheme > Check 'Thread Sanitizer'
        try await withThrowingTaskGroup(of: (Int, RandomData).self, body: { group in
            for id in ids {
                group.addTask { [unowned self] in
                    return (id, try await self.getRandomData(id: id))
                }
            }
            
            for try await (_, randomDatum) in group {
                randomData.append(randomDatum)
            }
        })
        
        return randomData
    }
    
    func getRandomData(id: Int) async throws -> RandomData {
        guard let imageUrl = AppConstantsNetwork.getRandomImageUrl(),
              let quoteUrl = AppConstantsNetwork.randomQuoteUrl else {
            throw NetworkError.urlError
        }
        
        /// Concurrent requests
        async let (imageData, _) = URLSession.shared.data(from: imageUrl)
        async let (quoteData, _) = URLSession.shared.data(from: quoteUrl)
        
        do {
            let decoder = JSONDecoder()
            let quote = try await decoder.decode(Quote.self, from: quoteData)
            
            return RandomData(image: try await imageData, quote: quote)
        } catch {
            print(error)
            throw NetworkError.decodeError
        }
    }
}
