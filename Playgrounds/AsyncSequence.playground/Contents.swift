import UIKit

// MARK: - Over the network
enum NetworkError: Error {
    case urlError
    case domainError
    case decodingError
}

extension URL {
    func allLines() async -> Lines {
        Lines(url: self)
    }
}

struct Lines: Sequence {
    let url: URL
    
    func makeIterator() -> some IteratorProtocol {
        let lines = (try? String(contentsOf: url))?.split(separator: "\n") ?? []
        return LinesIterator(lines: lines)
    }
}

struct LinesIterator: IteratorProtocol {
    typealias Element = String
    var lines: [String.SubSequence]
    
    mutating func next() -> Element? {
        if lines.isEmpty {
            return nil
        }
        
        return String(lines.removeFirst())
    }
}

guard let url = URL(string: "https://earthquake.usgs.gov/earthquakes/feed/v1.0/summary/all_month.csv")
else { throw NetworkError.urlError }

func iterateSequenceFromAPI() {
    Task {
        /// Blocking
    //    for line in await url.allLines() {
    //        print(line)
    //    }
        
        /// Iterates when available
        for try await line in url.lines {
            print(line)
        }
    }
}


// MARK: - Built in
let paths = Bundle.main.paths(forResourcesOfType: "txt", inDirectory: nil)
let fileHandler = FileHandle(forReadingAtPath: paths[0])

func iterateSequenceFromFile() {
    Task {
        for try await line in fileHandler!.bytes{
            print(line )
        }
    }
}

//iterateSequenceFromAPI()
iterateSequenceFromFile()
