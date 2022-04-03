//
//  ContentView.swift
//  Basic
//
//  Created by Jansen Ducusin on 4/3/22.
//

import SwiftUI

// Reference is shareable and can be accessed by multiple threads
class Counter {
    var value: Int = 0
    
    func increment() -> Int {
        value += 1
        return value
    }
}

// Can only be accessed by a single thread at a time
actor AnotherCounter {
    var value: Int = 0
    
    func increment() -> Int {
        value += 1
        return value
    }
}

struct ContentView: View {
    var body: some View {
        HStack {
            
            /// Concurrent Multithreaded Approach
            Button {
                let counter = Counter()
                
                DispatchQueue.concurrentPerform(iterations: 100) { _ in
                    print(counter.increment())
                }
            } label: {
                Text("Class Increment")
                    .background(Color.blue)
                    .foregroundColor(.white)
            }
            
            /// Concurrent Single Threaded Approach
            Button {
                let counter = AnotherCounter()
                
                DispatchQueue.concurrentPerform(iterations: 100) { _ in
                    Task {
                        print(await counter.increment())
                    }
                }
            } label: {
                Text("Actor Increment")
                    .background(Color.blue)
                    .foregroundColor(.white)
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
