//
//  ContentViewModel.swift
//  AsyncAwait
//
//  Created by Jansen Ducusin on 3/27/22.
//

import Foundation

class ContentViewModel: ObservableObject {
    @Published var currentDates = [CurrentDateViewModel]()
    
    func getCurrentDate() async {
        do {
            if let currentDate = try await WebService().getCurrentDate() {
                let currentDateViewModel = CurrentDateViewModel(currentDate: currentDate)
                
                DispatchQueue.main.async {
                    /// currentDates is decorated as @Published,
                    /// hence will update UI when setting a new value.
                    self.currentDates.append(currentDateViewModel)
                }
            }
        } catch {
            print(error)
        }
    }
}

struct CurrentDateViewModel {
    let currentDate: CurrentDate
    
    var id: UUID {
        currentDate.id
    }
    
    var date: String {
        currentDate.date
    }
}
