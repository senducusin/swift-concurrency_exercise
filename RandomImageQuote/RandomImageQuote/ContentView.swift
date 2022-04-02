//
//  ContentView.swift
//  RandomImageQuote
//
//  Created by Jansen Ducusin on 4/3/22.
//

import SwiftUI

struct ContentView: View {
    
    @StateObject private var randomDataListViewModel = RandomDataListViewModel()
    
    var body: some View {
        NavigationView{
            List(randomDataListViewModel.randomDataCollection) { data in
                HStack {
                    data.image.map {
                        Image(uiImage: $0)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                    }
                    
                    Text(data.quote)
                }
            }.task {
                await randomDataListViewModel
                    .getRandomImages(ids: Array(100...105))
            }
            .navigationTitle("Random Data")
            .navigationBarItems(trailing: Button(action: {
                Task {
                    await randomDataListViewModel
                        .getRandomImages(ids: Array(100...105))
                }
            }, label: {
                Image(systemName: "arrow.clockwise.circle")
            }))
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
