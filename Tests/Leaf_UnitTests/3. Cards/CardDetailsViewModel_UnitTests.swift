//
//  CardDetailsViewModel_Tests.swift
//  Leaf_Tests
//
//  Created by ddorsat on 07.08.2025.
//

import XCTest
import CoreData
@testable import Leaf

final class CardDetailsViewModel_UnitTests: XCTestCase {
    var context: NSManagedObjectContext!
    
    var transactionService: MockTransactionService!
    var cardService: MockCardService!
    var notificationCenter: NotificationCenter!
    
    var viewModel: CardDetailsViewModel!

    override func setUpWithError() throws {
        context = ContainerService.makeInMemoryContext()
        
        transactionService = MockTransactionService(context: context)
        cardService = MockCardService(context: context)
        notificationCenter = NotificationCenter()
        
        viewModel = CardDetailsViewModel(cardService: cardService, transactionService: transactionService)
    }

    override func tearDownWithError() throws {
        context = nil
        transactionService = nil
        cardService = nil
        notificationCenter = nil
        viewModel = nil
    }
    
    func test_fetchTransactions() {
        // Given
        let card = Card(context: context)
        cardService.cards = [card]
        
        XCTAssertEqual(cardService.cards.count, 1)
        
        let transaction = ContainerService.createTestTransaction(card, context: context)
        cardService.transactionsByCard[card] = [transaction]
        
        XCTAssertEqual(viewModel.transactions.count, 0)
        
        // When
        viewModel.fetchTransactions(card)
        
        // Then
        XCTAssertEqual(viewModel.transactions.count, 1)
    }
    
    func test_deleteTransaction() {
        // Given
        let card = Card(context: context)
        let transaction = ContainerService.createTestTransaction(card, context: context)
        viewModel.transactions = [transaction]
        
        XCTAssertFalse(transactionService.didCallDelete)
        XCTAssertEqual(viewModel.transactions.count, 1)
        
        // When
        viewModel.deleteTransaction(transaction: transaction)
        viewModel.fetchTransactions(card)
        
        // Then
        XCTAssertTrue(transactionService.didCallDelete)
        XCTAssertEqual(viewModel.transactions.count, 0)
    }
    
    func test_deleteCard() {
        // Given
        let card = Card(context: context)
        cardService.cards = [card]
        
        XCTAssertFalse(cardService.didCallDeleteCard)
        XCTAssertEqual(cardService.cards.count, 1)
        
        // When
        viewModel.deleteCard(card)
        
        // Then
        XCTAssertTrue(cardService.didCallDeleteCard)
        XCTAssertEqual(cardService.cards.count, 0)
    }
}
