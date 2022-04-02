//
//  RandomDataListViewModel.swift
//  RandomImageQuote
//
//  Created by Jansen Ducusin on 4/3/22.
//

import UIKit

class RandomDataListViewModel: ObservableObject {
    
    @Published var randomDataCollection = [RandomDataViewModel]()
    
    func getRandomImages(ids: [Int]) async {
        randomDataCollection = []
        
        do {
            /// In order for this to work on a simulator,
            /// make sure that the thread sanitizer is enabled
            /// to enable: Edit Scheme > Check 'Thread Sanitizer'
            try await withThrowingTaskGroup(of: (Int, RandomData).self, body: { group in
                for id in ids {
                    group.addTask {
                        return (id, try await WebService.shared.getRandomData(id: id))
                    }
                }
                
                for try await (_, randomData) in group {
                    DispatchQueue.main.async {
                        self.randomDataCollection.append(RandomDataViewModel(randomData: randomData))
                    }
                }
            })
        } catch {
            print(error)
        }
    }
}

struct RandomDataViewModel: Identifiable {
    let id = UUID()
    fileprivate let randomData: RandomData
    
    var image: UIImage? {
        UIImage(data: randomData.image)
    }
    
    var quote: String {
        randomData.quote.content
    }
}
