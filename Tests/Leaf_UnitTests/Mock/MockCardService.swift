//
//  ExpenseViewModelMock.swift
//  Leaf_Tests
//
//  Created by ddorsat on 05.08.2025.
//

import Foundation
import CoreData
@testable import Leaf

final class MockCardService: CardServiceProtocol {
    var cards: [Card] = []
    var transactionsByCard: [Card: [CardTransaction]] = [:]
    var didCallDeleteCard: Bool = false
    var didCallSave: Bool = false
    var didCallDisappear: Bool = false
    
    let context: NSManagedObjectContext
    
    init(context: NSManagedObjectContext) {
        self.context = context
    }
    
    func fetchCards() throws -> [Card] {
        return cards
    }
    
    func fetchTransactions(_ card: Card) throws -> [CardTransaction] {
        return transactionsByCard[card] ?? []
    }
    
    func addCard() -> Card {
        let card = Card(context: context)
        cards.append(card)
        didCallSave = true
        didCallDisappear = true
        return card
    }
    
    func deleteCard(_ card: Card) {
        didCallDeleteCard = true
        if let index = cards.firstIndex(of: card) {
            cards.remove(at: index)
        }
    }
    
    func save() {
        didCallSave = true
    }
}
