//
//  CardServiceImplementation.swift
//  Leaf
//
//  Created by ddorsat on 05.08.2025.
//

import Foundation
import CoreData

final class CardServiceImplementation: CardServiceProtocol {
    private let context: NSManagedObjectContext
    
    init(context: NSManagedObjectContext = ContainerService.shared.context) {
        self.context = context
    }
    
    func fetchCards() throws -> [Card] {
        let request = NSFetchRequest<Card>(entityName: "Card")
        request.sortDescriptors = [NSSortDescriptor(keyPath: \Card.timestamp, ascending: false)]
        
        return try context.fetch(request)
    }
    
    func fetchTransactions(_ card: Card) throws -> [CardTransaction] {
        let request = NSFetchRequest<CardTransaction>(entityName: "CardTransaction")
        request.sortDescriptors = [NSSortDescriptor(keyPath: \CardTransaction.timestamp, ascending: false)]
        request.predicate = NSPredicate(format: "card == %@", card)
        
        return try context.fetch(request)
    }
    
    func addCard() -> Card {
        Card(context: ContainerService.shared.context)
    }
    
    func deleteCard(_ card: Card) {
        context.delete(card)
        
        save()
    }
    
    func save() {
        try? context.save()
    }
}
