//
//  ExpenseViewModelMock.swift
//  Leaf_Tests
//
//  Created by ddorsat on 05.08.2025.
//

import Foundation
import CoreData
@testable import Leaf

final class MockTransactionService: TransactionServiceProtocol {
    var transactions: [CardTransaction] = []
    var didCallDelete: Bool = false
    var didCallSave: Bool = false
    
    let context: NSManagedObjectContext
    
    init(context: NSManagedObjectContext) {
        self.context = context
    }
    
    func fetchTransactions(limit: Int) throws -> [CardTransaction] {
        return Array(transactions.prefix(limit))
    }
    
    func addTransaction() -> CardTransaction {
        let transaction = CardTransaction(context: context)
        transactions.append(transaction)
        return transaction
    }
    
    func topUpBalance() -> CardTransaction {
        let transaction = CardTransaction(context: context)
        transactions.append(transaction)
        return transaction
    }
    
    func deleteTransaction(_ transaction: CardTransaction) {
        didCallDelete = true
        if let index = transactions.firstIndex(of: transaction) {
            transactions.remove(at: index)
        }
    }
    
    func save() {
        didCallSave = true
    }
}
