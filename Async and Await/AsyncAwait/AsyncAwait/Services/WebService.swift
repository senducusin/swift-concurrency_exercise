//
//  WebService.swift
//  AsyncAwait
//
//  Created by Jansen Ducusin on 3/27/22.
//

import Foundation

class WebService {
    func getCurrentDate() async throws -> CurrentDate? {
        guard let url = URL(string: "https://jarvis-nodejs.herokuapp.com/api/dates/current-date")
        else { return nil }
        
        let (data, _) = try await URLSession.shared.data(from: url)
        return try? JSONDecoder().decode(CurrentDate.self, from: data)
    }
}
