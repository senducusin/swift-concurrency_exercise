//
//  BankAccount.swift
//  Actor with MVVM
//
//  Created by Jansen Ducusin on 4/3/22.
//

import Foundation

actor BankAccount {
    private(set) var balance: Double
    private(set) var transactions = [String]()
    
    init(balance: Double) {
        self.balance = balance
    }
    
    func getBalance() -> Double {
        return balance
    }
    
    func withdraw(_ amount: Double) {
        if balance >= amount {
            let processingTime = UInt32.random(in: 0...3)
            let processMessage = "Withdraw - Processing Time: \(processingTime) - Amount: \(amount)"
            transactions.append(processMessage)
            print(processMessage)
            
            sleep(processingTime)
            
            let withdrawMessage = "Withdrawing \(amount) from account"
            transactions.append(withdrawMessage)
            print(withdrawMessage)
            
            balance -= amount
            let newBalanceMessage = "New balance is \(balance)"
            transactions.append(newBalanceMessage)
        }
    }
}
