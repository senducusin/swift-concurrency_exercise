import Foundation

// MARK: - Serial Queue
/// Tasks are sequential

let serialQueue = DispatchQueue(label: "SerialQueue")

serialQueue.async {
    // First task to be executed
}

serialQueue.async {
    // Next task to be executed
}


// MARK: - Concurrent Queue
/// Tasks will start in the order they are added but they can finish in ANY order

let concurrentQueue = DispatchQueue(label: "ConcurrentQueue", attributes: .concurrent)

concurrentQueue.async {
    
}

concurrentQueue.async {
    
}

// MARK: - Proper Concurrency
/// Avoid refreshing the UI inside the 'global' queue,
/// and at the same time avoid downloading data from  'main' queue

DispatchQueue.global().async {
    // Download data here
    
    DispatchQueue.main.async {
        // Refresh the UI here
    }
}
