//
//  ContentView.swift
//  Unstructured Concurrency
//
//  Created by Jansen Ducusin on 3/28/22.
//

import SwiftUI

struct ContentView: View {
    
    private func getData() async {
        
    }
    
    var body: some View {
        VStack {
            Button {
                Task {
                    await getData()
                }
            } label: {
                Text("Get Data")
            }.buttonStyle(.bordered)
                .controlSize(.large)
                .tint(.teal)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
