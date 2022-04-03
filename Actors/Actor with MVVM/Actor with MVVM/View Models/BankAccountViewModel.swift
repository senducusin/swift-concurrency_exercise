//
//  BankAccountViewModel.swift
//  Actor with MVVM
//
//  Created by Jansen Ducusin on 4/3/22.
//

import Foundation

/// MainActor decorator handles internal async main thread handling with actors
/// MainActor does not work on call backs / completion with @escaping
/// Make sure to use only with structured or unstructured concurrency
@MainActor
class BankAccountViewModel: ObservableObject {
    private var bankAccount: BankAccount
    @Published var currentBalance: Double?
    @Published var transactions = [String]()
    
    init(balance: Double) {
        bankAccount = BankAccount(balance: balance)
    }
    
    /// with side effects
    func withdraw(_ amount: Double) async {
        await bankAccount.withdraw(amount)
        
        currentBalance = await bankAccount.balance
        transactions = await bankAccount.transactions
    }
    
    /// no side effects
    nonisolated func sayHello() -> String {
        let message = "Hello World"
        print(message)
        return message
    }
}
