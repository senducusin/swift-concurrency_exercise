//
//  CurrentDate.swift
//  AsyncAwait
//
//  Created by Jansen Ducusin on 3/27/22.
//

import Foundation

struct CurrentDate: Decodable, Identifiable {
    let id = UUID()
    let date: String
    
    private enum CodingKeys: String, CodingKey {
        case date = "date"
    }
}
