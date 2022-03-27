//
//  ContentView.swift
//  AsyncAwait
//
//  Created by Jansen Ducusin on 3/27/22.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var currentDateListViewModel = ContentViewModel()
    
    var body: some View {
        NavigationView {
            List(currentDateListViewModel.currentDates, id: \.id) { currentDate in
                Text("\(currentDate.date)")
            }.listStyle(.plain)
                .navigationTitle("Dates")
                .navigationBarItems(trailing: Button(action: {
                    Task {
                        await currentDateListViewModel.getCurrentDate()
                    }
                }, label: {
                    Image(systemName: "arrow.clockwise.circle")
                }))
                .task {
                    await currentDateListViewModel.getCurrentDate()
                }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
