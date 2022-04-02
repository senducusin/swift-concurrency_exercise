//
//  RandomImage.swift
//  RandomImageQuote
//
//  Created by Jansen Ducusin on 4/3/22.
//

import Foundation

struct RandomData: Decodable {
    let image: Data
    let quote: Quote
}

struct Quote: Decodable {
    let content: String
}
