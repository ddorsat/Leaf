//
//  TransactionServiceImplementation.swift
//  Leaf
//
//  Created by ddorsat on 05.08.2025.
//

import Foundation
import CoreData

final class TransactionServiceImplementation: TransactionServiceProtocol {
    private let context: NSManagedObjectContext
    
    init(context: NSManagedObjectContext = ContainerService.shared.context) {
        self.context = context
    }
    
    func fetchTransactions(limit: Int) throws -> [CardTransaction] {
        let request = NSFetchRequest<CardTransaction>(entityName: "CardTransaction")
        request.sortDescriptors = [NSSortDescriptor(keyPath: \CardTransaction.timestamp, ascending: false)]
        request.fetchLimit = limit
        
        return try context.fetch(request)
    }
    
    func addTransaction() -> CardTransaction {
        CardTransaction(context: ContainerService.shared.context)
    }
    
    func topUpBalance() -> CardTransaction {
        CardTransaction(context: ContainerService.shared.context)
    }
    
    func deleteTransaction(_ transaction: CardTransaction) {
        context.delete(transaction)
        
        save()
    }
    
    func save() {
        try? context.save()
    }
}
