import UIKit
import Darwin

class BankAccount {
    var balance: Double
    let lock = NSLock() /// Multi thread solution, only 1 thread can access
    
    init(balance: Double) {
        self.balance = balance
    }
    
    func withdraw(_ amount: Double) {
        
        lock.lock()
        if balance >= amount {
            let processingTime = UInt32.random(in: 0...3)
            print("Withdrawing for \(amount) - \(processingTime) seconds")
            sleep(processingTime)
            print("Withdrawing \(amount) from account")
            balance -= amount
            print("New balance is \(balance)")
        }
        lock.unlock()
        
    }
}

let bankAccount = BankAccount(balance: 500)
let queue = DispatchQueue(label: "ConcurrentQ", attributes: .concurrent)

queue.async {
    bankAccount.withdraw(200)
}

queue.async {
    bankAccount.withdraw(100)
}
