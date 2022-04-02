//
//  AppConstants.swift
//  RandomImageQuote
//
//  Created by Jansen Ducusin on 4/3/22.
//

import Foundation

struct AppConstantsNetwork {
    static func getRandomImageUrl() -> URL? {
        return URL(string: "https://picsum.photos/200/300?uuid=\(UUID().uuidString)")
    }
    
    static var randomQuoteUrl: URL? {
        URL(string: "https://api.quotable.io/random")
    }
}
