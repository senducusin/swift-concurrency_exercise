//
//  NewsSourceListViewModel.swift
//  AsyncAwaitMainActor
//
//  Created by Jansen Ducusin on 3/28/22.
//

import Foundation

@MainActor
class NewsSourceListViewModel: ObservableObject {
    
    @Published var newsSources: [NewsSourceViewModel] = []
    
    func getSourcesAsync() async {
        do {
            let newsSources = try await Webservice().fetchSources(url: Constants.Urls.sources)
            
                self.newsSources = newsSources.map(NewsSourceViewModel.init)
        } catch {
            print(error)
        }
    }
    
    func getSources() {
        Webservice().fetchSources(url: Constants.Urls.sources) { result in
            switch result {
                case .success(let newsSources):
                    DispatchQueue.main.async {
                        self.newsSources = newsSources.map(NewsSourceViewModel.init)
                    }
                case .failure(let error):
                    print(error)
            }
        }
    }
}

struct NewsSourceViewModel {
    
    fileprivate var newsSource: NewsSource
    
    var id: String {
        newsSource.id
    }
    
    var name: String {
        newsSource.name
    }
    
    var description: String {
        newsSource.description
    }
    
    static var `default`: NewsSourceViewModel {
        let newsSource = NewsSource(id: "abc-news", name: "ABC News", description: "This is ABC news")
        return NewsSourceViewModel(newsSource: newsSource)
    }
}
