//
//  ContainerService.swift
//  Leaf
//
//  Created by ddorsat on 26.07.2025.
//

import Foundation
import CoreData
import SwiftUI

final class ContainerService {
    let container: NSPersistentContainer
    let context: NSManagedObjectContext
    
    static let shared = ContainerService()
    
    init() {
        container = NSPersistentContainer(name: "DataContainer")
        container.loadPersistentStores { _, error in
            if let error {
                fatalError("Failed to load container - \(error.localizedDescription)")
            }
        }
        context = container.viewContext
    }
    
    func save() {
        try? context.save()
    }
    
    static func makeInMemoryContext() -> NSManagedObjectContext {
        let container = NSPersistentContainer(name: "DataContainer")

        let description = NSPersistentStoreDescription()
        description.type = NSInMemoryStoreType
        container.persistentStoreDescriptions = [description]

        container.loadPersistentStores { _, error in
            if let error = error {
                fatalError("Failed to load in-memory container - \(error)")
            }
        }

        return container.viewContext
    }
    
    static func createTestCard(context: NSManagedObjectContext) -> Card {
        let card = Card(context: context)
        card.name = "TEST CARD"
        card.balance = 100
        card.number = "1234 5678 9123 4567"
        card.color = UIColor(Color(.blue)).encode()
        card.type = "VISA"
        return card
    }
    
    static func createTestTransaction(_ card: Card? = nil, context: NSManagedObjectContext, category: String? = nil) -> CardTransaction {
        let transaction = CardTransaction(context: context)
        transaction.cardName = "TEST CARD"
        transaction.sum = 100
        transaction.category = category
        transaction.card = card
        return transaction
    }
}
