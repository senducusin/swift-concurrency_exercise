//
//  ContentView.swift
//  Actor with MVVM
//
//  Created by Jansen Ducusin on 4/3/22.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var bankAccountViewModel = BankAccountViewModel(balance: 500)
    let queue = DispatchQueue(label: "ConcurrentQ", attributes: .concurrent)
    
    var body: some View {
        VStack {
            Button("Concurrent Withdraw") {
                
                /// Concurrent tasks
                Task {
                    await bankAccountViewModel.withdraw(500)
                    await bankAccountViewModel.withdraw(200)
                }
                
                _ = bankAccountViewModel.sayHello()
            }
            
            Text("\(bankAccountViewModel.currentBalance ?? 0)")
            
            List(bankAccountViewModel.transactions, id: \.self) { transaction in
                Text(transaction)
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
