//
//  Utils.swift
//  AsyncAwaitMainActor
//
//  Created by Jansen Ducusin on 3/28/22.
//

import Foundation

struct Constants {
    
    struct Urls {
        
        private static let apiKey = "667356415dcf4df6a74c696651754312"
        
        static func topHeadlines(by source: String) -> URL? {
            return URL(string: "https://newsapi.org/v2/top-headlines?sources=\(source)&apiKey=\(apiKey)")
        }
                
        static let sources: URL? = URL(string: "https://newsapi.org/v2/sources?apiKey=\(apiKey)")
    }
}
